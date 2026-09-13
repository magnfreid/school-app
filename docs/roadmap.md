# Roadmap: school schedule display, starter template → V1

This document maps everything between the current starter-template state and
a working V1. Product rationale lives in [`docs/project.md`](project.md);
code conventions in [`CLAUDE.md`](../CLAUDE.md); the Week View screen spec in
[`design/week-view/HANDOFF.md`](../design/week-view/HANDOFF.md); per-screen
design status in [`design/STATUS.md`](../design/STATUS.md).

**How it is built.** This is a hobby project, assembled in whatever time is
available and deliberately out of order — some chunks by hand, some with
Claude. Pick up any chunk whose dependency is satisfied, whenever. A **hole**
— a chunk that is unbuilt, stubbed, or running against a fake — is a normal
and accepted state of this app, not a defect and not something to tidy up
before starting something else. The only thing that genuinely has to come
first is Foundation, because everything else compiles against the contracts
it defines.

How to use a chunk entry: each is sized to be one `/dev-workflow:feature`
run. The decisions listed under a chunk are settled — that chunk's planning
pass must not re-open them. The items under "Settle before planning" are not
settled, and must be answered before that run starts.

What V1 means: subscribe to one shared Google Calendar, distinguish event
types, cache and sync a rolling window of weeks, navigate weeks (arrows +
swipe + Saturday auto-advance), and one setting (unsubscribe).

## Constraints that apply to every chunk

### Public repository

This GitHub repo is public. The service-account JSON key, the Calendar ID,
and any local `.env` must never be committed, never bundled into a build,
and never written into a repo-tracked file. Credentials are entered at
runtime through the in-app setup screen and held only in on-device secure
storage. `.gitignore` already carries a `# Secrets / local config` block
with placeholder Google-credential filenames; a chunk that introduces a new
credential filename shape extends that block. Treat the Calendar ID
conservatively as secret even though it is arguably not.

### Device: Samsung Galaxy Tab S3, Android 9 / API 28, sideloaded

Hardware ceiling, not a choice (see `docs/project.md`). `minSdkVersion` and
`targetSdkVersion` are both 28. Every dependency any chunk considers must be
checked against API 28 *and* against running without Play Services, since
the build is sideloaded — this is why auth is a service account rather than
Google Sign-In. The values are not pinned in the repo yet; the device
housekeeping chunk does that, and since it depends on nothing it can be done
at any time.

### Cross-repo dependency: the Cowork task's `extendedProperties` schema

Event type and week-span metadata are written onto each Calendar event as
private `extendedProperties` by an external Claude Cowork scheduled task,
which lives outside this repo — this repo only ever *reads* the calendar.
The exact key names and value formats are a shared contract between two
independent systems and are **not yet agreed**. Agreeing them is a blocker
for the Google Calendar repository chunk, not something that chunk can
decide alone.

### Open design question: special events spanning part of a week

The handoff's special-event lane has exactly two rows, "whole week" and
"single day" ([HANDOFF § 3](../design/week-view/HANDOFF.md)); an event
covering 2–3 contiguous days has no treatment. Default direction to take
into planning, **not yet signed off**: render the single-day row as a block
spanning the N contiguous day columns it covers, using the same column
grid, and promote to the "whole week" treatment only when it covers every
school day shown. This needs sign-off (likely a short design pass) before
anything touches `special_event_lane.dart`, and it may add a date range to
the `SpecialEvent` model defined in Foundation.

## Dependency map

The chunks below are written up in this order for presentation only; it is
not an execution order.

| Chunk | Depends on | Standalone? |
|---|---|---|
| Foundation | Nothing | Yes — no UI, no real implementation to wait for. |
| Device housekeeping | Nothing | Yes — affects nothing else here. |
| Auth scaffold removal and the config gate | Foundation | Yes — runs indefinitely on the in-memory placeholder. |
| Week View on fake data | Foundation | Yes, against `FakeScheduleRepository`; needs *a* route to be reachable. |
| Google Calendar repository | Foundation | Buildable and unit-testable alone; only visible once Week View exists, only exercisable on-device once config storage supplies real credentials. |
| Config storage and the setup screen | Foundation | Yes; most useful once the gate chunk has landed. |
| Settings and unsubscribe | Foundation, plus a settings route (creates its own stub if needed) | Yes. |
| Week navigation polish | Week View chunk (extends that bloc) | Yes, against the fake; independent of everything Calendar-related. |
| Cache window and delta sync | Google Calendar repository chunk | Compiles against the Foundation interface long before that chunk lands, but is meaningless without real data to sync. |

## Foundation

### Objective

Define every contract the rest of the app compiles against, and nothing
else. Deliberately small: two Dart-only packages, no real implementation, no
UI, no feature code.

### Scope

- `packages/schedule_repository/` — the file shape in
  [HANDOFF § Repository package](../design/week-view/HANDOFF.md) —
  `ScheduleRepository` (`abstract interface class`), the Freezed models
  (`ScheduleEvent`, `EventSeverity`, `SpecialEvent`, `WeekSchedule`),
  `ScheduleException`, and `FakeScheduleRepository` seeded with the
  handoff's mock week.
- `packages/calendar_config_repository/` — the `CalendarConfigRepository`
  interface, its domain exception, an in-memory placeholder implementation,
  and a scriptable `FakeCalendarConfigRepository`.
- Both packages mirror `packages/auth_repository/` for structure, lints
  (`package:lints/recommended.yaml` plus `public_member_api_docs`) and test
  style; each carries its own `test/`; both are registered in **both**
  halves of the root `pubspec.yaml` (`CLAUDE.md` § Workspace).
- Explicitly deferred: `google_calendar_schedule_repository.dart` and the
  config package's secure-storage-backed implementation belong to their own
  chunks — do not stub either here.

### Already decided

`ScheduleRepository` reads a window of weeks, roughly ±2 weeks around a
given date, not a single week — even though the fake and the Week View
chunk only ever use one week of it — so the cache/sync chunk can put real
windowed and delta behaviour behind the same interface without reshaping
anything already built on it. The asymmetry between the two packages is
deliberate: the config package ships an in-memory placeholder because
`bootstrap.dart` needs something concrete to provide (the role
`InMemoryAuthRepository` played), while the schedule package does not,
because `FakeScheduleRepository` with the handoff's mock week is what
`fvm flutter run` uses until real Calendar data exists — do not invent an
`InMemoryScheduleRepository`. The in-memory config placeholder starts in
the **configured** state with placeholder values, so the app runs straight
to the schedule; the unconfigured branch is reached through the `Fake`.
Repositories are interface + implementation + `Fake` wired to a concrete
type in `bootstrap.dart` only (`CLAUDE.md`), and Google Calendar types must
be translated before crossing the package boundary.

### Settle before planning

What "configured?" looks like on `CalendarConfigRepository` (a stream the
router can refresh on, a future, or a synchronous getter alongside a change
stream), what it carries beyond a yes/no, and how "not configured" is
reported — the gate chunk's splash and refresh-listenable questions both
fall out of this answer; the schedule model fields beyond the handoff's
stated minimum; whether `SpecialEvent` carries a date range (see the
partial-week open design question — the answer changes this model); which
week relative to "today" the fake seeds, so the today-ring and the empty
states are exercisable; how the window is addressed on the interface
(anchor date plus span, explicit date range, or week identifiers).

### Depends on

Nothing. Everything else depends on this, and on nothing else except where
noted.

### Flags

Partial-week specials (may reshape `SpecialEvent`); the cross-repo
dependency, because the `EventSeverity` values have to line up with what
the Cowork task writes even though the mapping code lands in another chunk.

### Done when

Both packages' suites pass under `./scripts/verify.sh` and the schedule
fake can serve a full mock week through the windowed interface.

## Chunk: Device housekeeping

### Objective

Make the Android build say what this app actually is and target what the
tablet actually runs.

### Scope

From `docs/project.md`, observed not yet applied — note it as such: pin
`minSdk`/`targetSdk` to 28 in `android/app/build.gradle.kts`, where both
still read `flutter.minSdkVersion`/`flutter.targetSdkVersion`; rename the
Android `namespace` and `applicationId`, which are still
`com.magnfreid.com.flutter_starter`; move
`android/app/src/main/kotlin/com/magnfreid/com/flutter_starter/MainActivity.kt`
to the directory matching the new package and update its `package`
declaration to match, since `AndroidManifest.xml`'s
`android:name=".MainActivity"` resolves relative to the namespace; update
`android:label` in the manifest, still `flutter_starter`, which is what
the kiosk home screen would show.

### Already decided

API 28 is a hardware ceiling, not a preference.

### Settle before planning

The final `applicationId`.

### Depends on

Nothing, and nothing depends on it. Do it whenever — first, last, or while
waiting on something else.

### Flags

Device constraint (this chunk is where it gets pinned).

### Done when

A release build installs on the Tab S3 under the new id and
`./scripts/verify.sh` is green.

## Chunk: Auth scaffold removal and the config gate

### Objective

Strip the template's per-user login, which this product has no use for, and
leave a router whose entry point is the schedule, gated on whether a
calendar has been configured.

### Scope

Delete `lib/auth/`, `lib/login/`, `lib/home/`, `packages/auth_repository/`
and their tests (`test/auth/`, `test/login/`, `test/home/`,
`packages/auth_repository/test/`); remove `auth_repository` from **both**
halves of the root `pubspec.yaml`; rewrite the redirect in
`lib/app/router/app_router.dart` and the route list in
`lib/app/router/routes.dart` (schedule at `/`, plus stub routes for
settings and for setup/subscribe); update `lib/app/app.dart`, which
imports `AuthCubit` and calls
`AppRouter.build(authCubit: context.read<AuthCubit>())`, to drop both;
drop the auth providers from `lib/bootstrap.dart` and provide the
in-memory `CalendarConfigRepository` placeholder instead; rewrite
`wrapWithAppProviders` in `test/helpers/app_harness.dart`, removing
`SilentAuthRepository` and providing `FakeCalendarConfigRepository` in its
place; rewrite `test/app/router/app_router_test.dart` against the new
guard — redirect precedence is a seam that breaks silently, so it keeps a
test from day one; rewrite `test/app_test.dart`, whose four auth-routing
tests import `auth_repository`, `AuthCubit`, `HomePage`, `LoginPage`, and
`SplashPage`; strip the login/auth keys from `lib/l10n/app_en.arb` and
`app_sv.arb` and give `appTitle` the real app name (it still reads
"Flutter Starter").

### Already decided

There is no per-user login anywhere in this product; the entry gate becomes
"calendar configured? → schedule : setup/subscribe screen", replacing
"authenticated? → home : login". The gate ships here, against the
Foundation interface — the router depends on `CalendarConfigRepository` and
never on an implementation, which is how this repo treats every external
dependency (`CLAUDE.md`), so the config-storage chunk changes what is
provided and not this guard. Both stub routes exist so each branch of the
gate has somewhere to land; the config-storage chunk fills in the setup one
and the settings chunk the settings one, and either may already have
created its own — whichever lands first owns the route, the other adapts.
`_GoRouterRefreshStream` in `app_router.dart` stays as it is — `CLAUDE.md`
explains why its `removeListener` override must not be simplified away.

### Settle before planning

Whether `lib/splash/` survives and whether `_GoRouterRefreshStream` still
has a stream to drive, both of which follow from the read shape Foundation
chose (splash exists to hold the UI while auth resolves, and whether the
config gate has an equivalent unresolved state is open); what the stub
screens show until their own chunks land; the real `appTitle` copy in both
locales.

### Depends on

Foundation — specifically the `CalendarConfigRepository` interface and its
in-memory placeholder. It needs neither the real config storage, nor the
setup screen, nor the Week View: with the placeholder configured, the gate
passes and the schedule route resolves to whatever is behind it at the
time.

### Flags

None. The placeholder holds no credentials, so public-repo secrecy attaches
to the config-storage chunk rather than this one.

### Done when

`./scripts/verify.sh` is green with no auth code left in the tree, the app
boots through the gate on the in-memory placeholder, and the rewritten
router-guard test passes.

## Chunk: Week View on fake data

### Objective

Build the app's only real screen, pixel-for-pixel against the handoff,
driven by `FakeScheduleRepository`.

### Scope

The `app_ui` token pass the handoff specifies (colours, typography roles,
sizes, radii, spacing); `lib/schedule/` per
[HANDOFF § State management](../design/week-view/HANDOFF.md) —
`ScheduleBloc` with Freezed sealed event and state unions,
`SchedulePage`/`ScheduleView`, and the widgets; wiring the fake in
`bootstrap.dart`; dark-only (`MaterialApp.themeMode: ThemeMode.dark`, no
`ThemeSwitcherWidget` on this screen — `ThemeCubit` stays for other
screens); the l10n keys the handoff lists, in both ARB files; tests per
`CLAUDE.md` — bloc transitions and error path, a page test pumped through
`SchedulePage` with the fake, and `View`-level tests for the states that
render differently.

### Already decided

The handoff's own "Known deviations" block wins over its stricter body —
Material icons for the nav arrows, crayon ring attempted first with a plain
ring as fallback, and a small closed set of special-event colour presets
rather than an open-ended list. Bands 1–3 hold their height so the grid
never moves; the grid never scrolls; cards are not tappable; the
second-view button is present and wired to nothing; date derivation (next
event, `daysUntil`, relative word) happens in the bloc, not in widgets; no
hex literals or inline `TextStyle` in `lib/schedule/`. The bloc asks the
repository for a window and renders one week of it — that is the Foundation
contract, not something to narrow here. Carried, cannot be closed here:
handoff open question 3 — the sync dot's warning colours and staleness
thresholds depend on the polling interval the cache chunk picks; ship the
healthy state and reserve the slot.

### Settle before planning

`ScheduleColors` `ThemeExtension` vs. re-seeding the dark `ColorScheme`
(the handoff offers both and prefers the extension); whether to extend
`AppSpacing` with the missing steps or snap to a 4 dp grid — and if
snapping, the handoff's constraint that the single-day banner grid and the
week grid snap together or they stop lining up; the closed banner-preset
palette (needs a design decision); handoff open question 1 (weekend
columns changing every column's width) and 2 (the undesigned `+N` overflow
affordance).

### Depends on

Foundation — the `ScheduleRepository` interface and
`FakeScheduleRepository`. It needs no real Calendar repository, no config
storage and no auth-scaffold removal. It does need *a* route to be
reachable, which is a coordination point with the gate chunk rather than a
dependency: whichever of the two lands first makes the router edit, and the
other adapts to what it finds.

### Flags

Partial-week specials — do not generalize `special_event_lane.dart` before
sign-off; build the two rows the handoff specifies.

### Done when

The screen matches the handoff at 1024 × 768 on fake data and its tests
pass.

## Chunk: Google Calendar repository

### Objective

Implement `ScheduleRepository` against the real calendar, read through a
service account the tablet never signs into.

### Scope

`GoogleCalendarScheduleRepository` reading the Calendar API over plain
HTTPS with a JWT service-account grant, reading the Calendar ID and key
through the `CalendarConfigRepository` interface rather than from anything
of its own; mapping Calendar events plus their `extendedProperties` onto
the Foundation domain models, including failure mapping onto
`ScheduleException`; swapping `bootstrap.dart` off the fake. Tests: the
mapping and its failure mapping are a required-tier repository contract,
and the catch ordering around a typed exception before a catch-all is
exactly the silent seam `CLAUDE.md` calls out — all of it testable against
`FakeCalendarConfigRepository` with no device and no UI. Explicitly not in
this chunk: caching, `syncToken` handling and background refresh — those
are the cache chunk; this one answers a window request by fetching it.

### Already decided

A service account with the family calendar shared to it read-only, created
outside this repo; no interactive Google sign-in on the device, ever; pure
Dart/HTTP (the `googleapis` / `googleapis_auth` route) rather than anything
needing Play Services; event type and week-span metadata come from private
`extendedProperties`, not from parsing the title text; the window shape is
Foundation's, so this implementation serves a window even if it does so
with one request per week at first.

### Settle before planning

The `extendedProperties` key names and value formats, agreed with the
Cowork task — blocker, see Constraints; the fallback when a property is
missing or malformed (the candidate is treating it as `other` severity,
deliberately left to this chunk); how the access token is obtained and
refreshed.

### Depends on

Foundation. Not the Week View — this is buildable and fully unit-testable
with no UI on screen; it simply is not *visible* until that chunk exists,
and not exercisable on the device until the config-storage chunk can
supply real credentials.

### Flags

The cross-repo dependency in full; device constraint (no
Play-Services-only dependency); public-repo secrecy — credentials pass
through this code and must never be logged, echoed into an error message,
or committed as a test fixture.

### Done when

The repository returns real calendar data for a requested window against a
real calendar, its mapping and failure-mapping tests pass, and no
credential exists anywhere in the repo.

## Chunk: Config storage and the setup screen

### Objective

Persist the two pieces of local config on-device, and give the user a way
to enter them.

### Scope

The real, secure-storage-backed implementation of the Foundation
`CalendarConfigRepository` interface, holding the Calendar ID and the
service-account JSON key — same interface + `Fake` + real shape every
repository in this repo has (`CLAUDE.md`), so `bootstrap.dart` swapping off
the in-memory placeholder is a one-line change; the setup / "subscribe"
screen that captures both values and writes them through that interface
(plain Material 3 — `design/STATUS.md` records that this screen has no
design), filling in the stub route if the gate chunk has already created
one and adding the route itself if it has not; tests for the storage
implementation as a required-tier repository contract, and a page test for
the screen. Explicitly not in this chunk: the entry gate. It belongs to the
auth-scaffold chunk, which depends on the interface and not on this
implementation; if that chunk has landed, the router does not change here,
and if it has not, this chunk does not add a gate ahead of it. If the guard
appears to need rewriting to make this work, that is a signal the
Foundation interface was shaped wrong — raise it rather than reworking the
router inside this chunk.

### Already decided

"Subscribing" means storing the ID and credentials locally — there is no
Google-side subscribe action; credentials are entered at runtime and live
only in on-device secure storage; storage swaps behind the interface, so
the router, the schedule bloc and every widget are untouched by the swap.

### Settle before planning

Which secure-storage package works on API 28 sideloaded, and whether its
failure modes map onto the exception type Foundation defined or need a new
case; whether the JSON key is pasted or file-picked, since a file picker is
another plugin to check against API 28; the screen's copy in both locales.

### Depends on

Foundation. Most useful once the gate chunk has landed, since that is what
routes a user here, but it does not wait on it.

### Flags

Public-repo secrecy in full (runtime entry only, secure storage only,
never a tracked file, extend `.gitignore`'s `# Secrets / local config`
block if a new filename shape appears); device constraint (secure storage
and any file picker must work on API 28 without Play Services).

### Done when

The Calendar ID and key entered once on-device survive a restart, and no
credential exists anywhere in the repo.

## Chunk: Settings and unsubscribe

### Objective

Give the one screen V1 needs beyond the schedule, with the one action it
needs.

### Scope

A plain Material 3 settings screen (no design exists — `design/STATUS.md`)
behind the settings route, filling in the gate chunk's stub if it exists
and adding the route itself if it does not; a single **unsubscribe** action
that clears the stored Calendar ID and the stored credentials through the
`CalendarConfigRepository` interface, returning the app to the "not
configured" state — once the cache chunk exists, it drops its own cached
window in response to that state on its own, which this chunk does not
implement; l10n keys in both locales; tests for the screen and for the
state transition it triggers.

### Already decided

Unsubscribe is local only — it revokes nothing on Google's side; the user
un-shares the calendar from the service account by hand if they want that.
Unsubscribe is the only setting in V1. Returning to "not configured" is
what sends the app back to the setup/subscribe screen, via whatever gate
exists at the time — this chunk does not implement routing logic of its
own.

### Settle before planning

Whether a destructive-action confirmation is warranted and its copy in
both locales; whether unsubscribing also stops the background worker, if
one exists by then.

### Depends on

Foundation, plus a settings route existing — and it can create that stub
itself in a couple of lines if the gate chunk has not landed.

### Flags

Public-repo secrecy — this is the path that deletes credentials, so it
must not log or echo them.

### Done when

Unsubscribing leaves nothing stored and the app is back in the "not
configured" state.

## Chunk: Week navigation polish

### Objective

Make "which week am I looking at" correct by default and navigable by
finger.

### Scope

An anchor week computed from the current date — the current ISO week, or
**next** week whenever today is Saturday or Sunday — with the bloc's week
offset expressed relative to that anchor rather than a fixed epoch, so
offset 0 simply resolves to a different week on a Saturday and no
special-cased jump animation is needed; recomputation on each new calendar
day (at midnight while running, and on resume); swipe-to-navigate the grid
implemented as a `PageView` or equivalent, driving the same week-change
event as the arrows; transitions under 200 ms, moving the grid only while
the app bar, hero and special lane stay put.

### Already decided

Swipe is in V1 scope, not deferred; navigation is week-granular — no day or
month view; the arrows and the swipe share one event.

### Settle before planning

Whether a manually chosen offset survives a day rollover or resets to the
anchor; the recompute mechanism (timer vs. lifecycle observer) — this chunk
and the cache chunk both want a day-rollover hook, and whichever lands
second adopts the first one's rather than adding a second timer; whether
the `PageView`'s page range is bounded to the window the repository serves
and what happens at its edge.

### Depends on

The Week View chunk, whose bloc it extends. Independent of every Calendar
integration chunk — it is developed and tested entirely against the fake.

### Flags

Device constraint — the Tab S3 is slow and a long transition on a wall
display reads as lag.

### Done when

The display shows next week from Saturday morning onward without anyone
touching it, and the grid can be swiped.

## Chunk: Cache window and delta sync

### Objective

Keep roughly a month of schedule in memory so week-to-week navigation never
waits on the network, and keep it fresh without a foreground service.

### Scope

Holding the window the interface already speaks in — about two weeks back
and two weeks forward from today — behind the same `ScheduleRepository`
contract; one full pull of the window, then incremental refreshes using the
Calendar API's `syncToken`; a periodic background refresh (the
`workmanager` pattern `docs/project.md` prescribes); the `droppable()`
transformer on the refresh event so a slow pull cannot stack; the sync
indicator's warning colours and staleness thresholds, which closes handoff
open question 3.

### Already decided

Persistence is in-memory only for V1 — a deliberate choice, not an
oversight: every cold start does one full pull of the window, and neither
the `syncToken` nor the cached events are written to disk. Refresh is
periodic and automatic only — no user-triggered refresh, no
pull-to-refresh, matching the handoff's *Refresh* section; which isolate
actually delivers that refresh into the cache is not settled here (see
below). Because the window shape was fixed in Foundation, nothing that
already consumes the interface has to change when this lands.

### Settle before planning

The polling interval (the sync-dot thresholds follow from it); what
happens when the `syncToken` is rejected or expires; when the window
recomputes as the date rolls over; whether `workmanager` can actually wake
this app on API 28 sideloaded, and the fallback if it cannot; whether a
background-isolate refresh can reach an in-memory cache at all, and if
not, whether an in-app timer replaces `workmanager` for this always-on
foreground display.

### Depends on

The Google Calendar repository chunk — there has to be something real to
sync. It compiles against the Foundation interface well before that, and it
does not wait on the Week View chunk, though the sync indicator it drives
only becomes visible once that exists.

### Flags

Device constraint (`workmanager` on API 28); record in-memory-only
persistence in the document's "Deferred" section as a decision to revisit
if reboots turn out to be frequent, not as a gap to quietly fix.

### Done when

Moving several weeks in either direction triggers no network call and the
sync indicator reflects real sync health.

## Deferred, and why

- On-disk persistence of the cache and `syncToken` — in-memory only for V1,
  revisit if device reboots turn out to be frequent (the cache chunk).
- The alternative (non-week) view — the handoff's second-view button stays
  wired to nothing.
- Light mode — the display is dark-only for V1; `ThemeCubit` stays but
  nothing in V1 needs it.
- The handoff's `+N` column-overflow affordance — specified but not
  designed; ask for a design if real data ever exceeds five cards in a
  column.

## Out of scope for this repo

- The Claude Cowork scheduled task itself — its prompt, curation and dedup
  logic, and its Calendar writes. This repo only reads the calendar.
- Kiosk / lock-task setup for the tablet.
- The night-dimming mechanism (handoff open question 4) — it depends on
  whether the device backlight can be driven on API 28 in kiosk mode, which
  is device infrastructure rather than app code.

See [`docs/project.md`](project.md)'s own open-items list for those three.
