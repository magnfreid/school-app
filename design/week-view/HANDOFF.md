# Handoff: Week View (school schedule wall display)

## Known deviations (recorded before planning)

Flagged by the user ahead of the planning pass — the plan should treat these
as the actual target, not the stricter spec below, and should update this
note if either resolves differently once tried:

- **Nav arrows** (§1, App bar): spec calls for a custom-painted glyph, no
  Material substitute. Planned deviation — use standard icons (e.g. Material
  `arrow_back`/`arrow_forward` equivalents) instead of the `CustomPainter`
  path. Fidelity to the exact arrow geometry is not required.
- **Today marker** (§4, Week grid; `crayon_today_ring.dart`): spec calls for
  the hand-drawn crayon-ring path. Worth attempting as specified first: if
  it proves hard to get looking right in Flutter, fall back to a simpler
  marker (e.g. a plain stroked or filled circle/ring) rather than sinking
  more time into matching the hand-drawn look exactly.
- **Special-event banner presets** (§3, Special-event colour presets): spec
  lists two sample presets (teal, amber) and says "extend as needed." Instead
  treat this as a **small, fixed palette** decided up front — enough presets
  to give the scheduled Claude task real choice, each pre-vetted for
  contrast, rather than an open-ended list the task could add to. The exact
  palette is still to be designed; this just fixes the *approach*
  (closed set, not open-ended).

The right-side icon buttons (2×2 grid / settings glyphs) are **not** a
deviation — the spec already calls for swapping those for
`Icons.grid_view_outlined` / `Icons.settings_outlined`; see *Assets* below.

## Overview

The main screen of the wall-mounted school schedule display. It shows one
school week (Mon–Fri) in full, with no scrolling, on a permanently-on
tablet in a bedroom. Its job is to answer two questions from across the
room: *what is coming next*, and *what does this week look like*.

Target device: **Samsung Galaxy Tab S3 (SM-T825), landscape, 1024 × 768
logical pixels**, Android 9 / API 28. Every measurement in this document is
in logical pixels (= Flutter's dp) at that size. The design is authored to
that exact viewport, not responsively — it is a fixed-purpose kiosk screen.

Data comes from the shared Google Calendar described in `docs/project.md`;
this screen is read-only.

## About the design files

The files in this bundle are **design references created in HTML**. They are
prototypes showing intended look and layout, not production code to port.
The task is to **recreate this design in the existing Flutter app** using the
conventions already documented in `CLAUDE.md` — `app_ui` tokens, BLoC +
Freezed, `go_router`, `gen-l10n`, repository packages with fakes. No CSS or
HTML should end up in the repo.

`Week View.dc.html` opens in any browser at 1024 × 768 and is the visual
source of truth. `crayon_today_ring.dart` is the one exception: real Dart,
provided because that element has no HTML-to-Flutter equivalent.

## Fidelity

**High fidelity.** Colours, type sizes, weights, letter-spacing, and every
spacing value are final and are listed below. Recreate it pixel-for-pixel.

Two caveats that are deliberately *not* final:

1. **Content is placeholder.** The Swedish subject codes, event titles, week
   number and dates are invented samples in the shape the real Veckobrev /
   Kalendarium data takes. Do not hardcode any of it.
2. **Special-event banner colours are a preset set, not fixed values.** Two
   samples are shown (teal, amber). The scheduled Claude task picks one per
   event from a preset list — see *Special events* below.

## Screens / views

### Week view — the only screen in scope

Purpose: passive glance. No navigation, no input, nothing to complete. The
only interactive elements are week nav, settings, and a placeholder for a
future second view.

Root: `Column`, 1024 × 768, background `#0E0F12`, no safe-area insets (the
tablet runs in kiosk / lock-task mode with system bars hidden).

Vertical stack, top to bottom:

| # | Band | Height | Notes |
|---|---|---|---|
| 1 | App bar | 56 | fixed |
| 2 | Next-event hero | 138 | fixed, margin `4, 18, 0, 18` |
| 3 | Special-event lane | 38 + 6 + 32 | fixed, margin `12, 18, 0, 18`; **always occupies its height** |
| 4 | Week grid | remainder | margin `14, 18, 18, 18` |

Bands 1–3 are fixed height so that band 4 never moves. This is a
requirement, not an implementation detail: the screen is looked at every day
and nothing should jump when an event appears or disappears.

---

#### 1. App bar (56 dp)

`Row`, `padding: 0 20`, `spacing: 14`, cross-axis centre.

Left group, in order:

- `Vecka 38` — 21 / w500 / `#E4E1E9`
- `14–18 september` — 17 / w300 / `#8E8E98`
- Week nav arrows — `Row`, spacing 6, `margin-left: 8`. Two tap targets of
  **48 × 44**, no background, no ripple container. Each holds a solid white
  arrow glyph 31 × 22 (`#FFFFFF`), with a visible shaft, not a bare
  chevron. Left = previous week, right = next week. Geometry of the glyph,
  in a 28 × 20 box:
  - right: `M1 7.5 h14 V3 l11 7 -11 7 v-4.5 H1 z`
  - left: `M27 7.5 H13 V3 L2 10 l11 7 v-4.5 h14 z`
  - Implement as a `CustomPainter` or an `IconButton` with a custom
    `CustomPaint` child — do **not** substitute `Icons.arrow_back`, its
    weight and proportions are wrong at this size.

Then `Spacer()`.

Right group, in order:

- Sync indicator — `Row`, spacing 7: a 7 dp circle (`#5C9C72`) + `Uppdaterad
  07:38` at 15 / w300 / `#8E8E98`. The dot is the stale-warning hook: green
  when the last successful pull is recent, amber/red when it is not. Pick the
  thresholds with the polling interval; the design only reserves the slot.
- Icon buttons — `Row`, spacing 6, `margin-left: 14`. Two 44 × 44 circles,
  background `#1C1D22`, `BorderRadius.circular(22)`, 21 dp stroked glyph in
  `#8E8E98` at 1.8 stroke width. First = second view (placeholder, 2 × 2
  grid glyph, wire to nothing for now). Second = settings (gear).

The two 44 dp circles and the two 48 × 44 arrow targets are all at or above
the 44 dp minimum touch target; keep them there.

---

#### 2. Next-event hero (138 dp)

Container: margin `4, 18, 0, 18`, `padding: 0 24 0 22`, background
`#191A1F`, `BorderRadius.circular(4)`, and a **4 dp left edge** in
`#E0483C`. Implement the left edge as a border/`Container` decoration, not
as a child, so it spans the full 138.

`Row`, spacing 22, cross-axis centre.

Left column (`Expanded`, cross-axis start):

1. **Eyebrow row — fixed 24 dp height.** `Row`, spacing 12, centre:
   - `NÄSTA · PROV` — 12 / w500 / letter-spacing **2.6** / `#FF8A80`. The
     severity word changes with the event (`PROV` / `LÄXA` / the event's own
     kind); the colour does not.
   - **Countdown pill** — `padding: 4 10`, `BorderRadius.circular(12)`,
     1 dp border `#4A4B54`, text `3 dagar kvar` at 13 / w400 / `#A8A8B2`.
     **Shown only when the event is more than one day away.** When it is
     today or tomorrow the pill is simply absent — the 24 dp eyebrow row
     already exists, so nothing reflows. This was chosen over putting the
     countdown under the date precisely because it needs no reserved space.
2. Title — `Ekvationer` at **44 / w400 / line-height 1.1 / `#FFFFFF`**,
   `margin-top: 8`. Single line, `TextOverflow.ellipsis`.
3. Subject — `MA · Matematik` at 21 / w300 / `#A8A8B2`, `margin-top: 9`.

Right column (intrinsic width, text right-aligned):

1. `Torsdag` — 40 / w400 / `#FFFFFF`. Relative word where one exists
   (`Idag`, `Imorgon`), otherwise the weekday name.
2. `17 sep · 10:00` — 20 / w300 / `#A8A8B2`, `margin-top: 8`. The time
   segment is omitted for day-only events (`17 sep`).

The date is the dominant element on the right; the countdown must never
compete with it. That is why the countdown is 13 dp in a low-contrast pill
on the *left*, not near the date.

**Empty state:** when there is no upcoming event at all, keep the 138 dp
container and its left edge, and show a single line in `#8E8E98` where the
title sits (copy to be decided — `l10n` key `scheduleNoUpcoming`). Do not
collapse the band.

---

#### 3. Special-event lane

Container: margin `12, 18, 0, 18`, `Column`, spacing 6. Two rows, both
always present:

**Week-spanning row (38 dp)** — full width, `BorderRadius.circular(3)`,
`padding: 0 18`, `Row` spacing 13:
- `HELA VECKAN` — 11 / w500 / letter-spacing 2.2
- `Temavecka: Hållbarhet` — 18 / w400

**Single-day row (32 dp)** — a 5-column grid with 9 dp gaps, matching the
week grid below exactly, so a one-day special sits directly above its own
day column. The occupied cell has `BorderRadius.circular(3)`, centred
content, `Row` spacing 8:
- `HELDAG` — 10 / w500 / letter-spacing 1.8
- `Friluftsdag` — 16 / w400

Both rows hold their height when empty. Two empty rows means 76 dp of
background — that is intended.

Specials are visually outside the event language on purpose: filled colour,
tighter radius (3 vs 4), no subject code, positioned above the grid rather
than inside a day column. They must never be folded into a day's event
list.

##### Special-event colour presets

The scheduled task picks a preset per event. Each preset is a triple
(background, label, title). Two are specified from the design; extend the
list as needed, keeping every pair at 4.5:1 or better against its
background.

| Preset | Background | Label | Title | Measured |
|---|---|---|---|---|
| Teal | `#12514A` | `#7FD9C4` | `#D9F5EE` | 5.35:1 / 7.7:1 |
| Amber | `#5A3D0C` | `#F5C46B` | `#FFE9C2` | 6.15:1 / 8.4:1 |

Constraints on any preset added later: it must not read as red (reserved
for `prov`), it must not read as the neutral card grey, and it must clear
4.5:1 for both text colours **after** the night-mode dim is applied.

---

#### 4. Week grid

Container: margin `14, 18, 18, 18`. A **5-column grid, equal widths, 9 dp
gaps** — i.e. `Row` of five `Expanded` children with 9 dp gaps, not a
`GridView`. Each column is a `Column` with 7 dp gaps, main-axis start.

**Day header — fixed 52 dp**, `padding-left: 4`, centred vertically:
- Day name — 16 / w500 / letter-spacing 1.2
- Date — 14 / w300, `margin-top: 5`

Two variants:

| | Day name | Date | Bottom border |
|---|---|---|---|
| Today | `#FFFFFF` | `#A8A8B2` | none — replaced by the crayon ring |
| Other days | `#C9C6CF` | `#8E8E98` | 1 dp `#33343B` |

The today marker is a hand-drawn ring, not a fill or a pill — see
`crayon_today_ring.dart` for the exact path, box (126 × 56 at offset
−6, −2) and stroke (2.6 dp, round cap, `#E0483C` at 95%). It intentionally
overhangs the header, so nothing in the ancestor chain may clip it.

**Event card** — `BorderRadius.circular(4)`, `padding: 9 12`, main-axis
size min (cards are content-height, not stretched):
- Label — 11 / w500 / letter-spacing 1.6. Format: `SUBJECT · KIND · TIME`,
  with `· KIND` omitted for plain events and `· TIME` omitted for day-only
  ones. Examples in the mock: `MA · LÄXA`, `SO · INLÄMNING · 23:59`,
  `SO · 13:15`, `IDH`.
- Title — 19 / w400 / line-height 1.25, `margin-top: 5`. Wraps to two lines;
  do not truncate.

Two variants only — this is the whole severity system:

| Severity | Background | Left edge | Label | Title |
|---|---|---|---|---|
| `prov` (test) | `#26181A` | 4 dp `#E0483C` | `#FF8A80` | `#FFE2DE` |
| everything else | `#1C1D22` | none | `#8E8E98` | `#E4E1E9` |

Homework and other events are deliberately identical; they are told apart by
the `LÄXA` / `INLÄMNING` word in the label, not by colour. One accent colour
total, because the display is always on in a lived-in room.

**Overflow:** the grid must fit without scrolling. Worst case agreed with
the user is 8–12 items in a week, and the heaviest column in the mock holds
three cards in 470 dp with room to spare — a column fits five. If a column
ever exceeds its height, clip and show a `+N` affordance rather than
scrolling or shrinking type; flag it if that case turns out to be real.

**Weekend:** Saturday and Sunday are not shown. If an event falls on one,
add a sixth (and seventh) column for that week only, at equal width. The
day header for a weekend column uses the "other days" treatment.

## Interactions & behaviour

Minimal by design. This is a display, not an app.

- **Week nav arrows** — go to previous / next week. The user plans to add
  horizontal swipe on the grid later; build the week as a `PageView` page or
  keep the week offset in the BLoC so a swipe gesture can be added without
  restructuring. Nav is week-granular; there is no day or month view.
- **Settings button** — routes to a settings screen (out of scope here; add
  the route in `lib/app/router/routes.dart` and leave the page a stub).
- **Second-view button** — placeholder for a future alternative view.
  Present and correctly sized, wired to nothing.
- **Event cards are not tappable.** No detail view, no completion state.
- **No hover states** — touch-only device.
- **Refresh** is a periodic background fetch (`workmanager`, per
  `docs/project.md`), never a user action. There is no pull-to-refresh.
- **Transitions**: week changes should cross-fade or slide the grid only;
  the app bar, hero and special lane stay put. Keep it under 200 ms — the
  Tab S3 is slow and a long animation on a wall display reads as lag.

### Night dimming

The display is on 24/7 in a frequently-used room, so brightness must come
down on a schedule. Two options, in order of preference:

1. Lower the **device** backlight (`Settings.System.SCREEN_BRIGHTNESS` via a
   platform channel, or the kiosk launcher's own schedule). Preserves all
   contrast ratios exactly.
2. If that is not available, overlay a black `IgnorePointer` layer at
   partial opacity. **Do not re-tint or desaturate the palette** — every
   contrast ratio in this document was measured at full brightness with a
   little headroom, and a uniform dim preserves the ratios while a
   recolour does not.

The HTML prototype's "Night mode" toggle simulates option 2 so you can
sanity-check legibility at various levels.

## State management

Following `CLAUDE.md`: a **BLoC** (not a Cubit) — it has user-triggered
events (week nav) and a refresh with real concurrency requirements.

```
lib/schedule/
  bloc/
    schedule_bloc.dart
    schedule_event.dart     # sealed union, @freezed
    schedule_state.dart     # sealed union, @freezed
  view/
    schedule_page.dart      # provides the BLoC, reads the repository
    schedule_view.dart      # public, so a View-level test can inject states
  widgets/
    week_nav_arrows.dart
    next_event_hero.dart
    special_event_lane.dart
    week_grid.dart
    day_column.dart
    event_card.dart
    crayon_today_ring.dart
```

Events: `ScheduleEvent.started()`, `.weekChanged(int offset)`,
`.refreshRequested()` (apply `droppable()` to the last one so a slow pull
can't stack).

State, as a sealed union: `initial` / `loading` / `loaded(WeekSchedule
week, DateTime lastSyncedAt)` / `failure`. `loaded` is the only state the
full layout renders; `loading` and `failure` should render the same four
bands with the grid empty and the sync dot in its warning colour, so the
screen never changes shape.

Derived in the BLoC (not in widgets): the next upcoming event, its
`daysUntil`, and the relative-date word. Widgets should receive values, not
compute dates.

### Repository package

Per `CLAUDE.md`, the calendar is an external dependency and therefore its
own package with an interface, an implementation, and a `Fake`:

```
packages/schedule_repository/
  lib/
    src/
      schedule_repository.dart      # abstract interface class
      models/
        schedule_event.dart         # @freezed
        event_severity.dart         # enum: prov, laxa, other
        special_event.dart          # @freezed; spansWeek or a single date
        week_schedule.dart          # @freezed
      schedule_exception.dart
      google_calendar_schedule_repository.dart
      fake_schedule_repository.dart
```

`ScheduleEvent` needs at minimum: `id`, `title`, `subjectCode`, `date`,
`time` (nullable — some events are day-only), `severity`, `kindLabel`
(nullable: `LÄXA`, `INLÄMNING`, …). `SpecialEvent` needs `title`,
`colorPreset`, and either a date or a week span. Google Calendar types must
be translated to these before crossing the package boundary.

Wire `GoogleCalendarScheduleRepository` in `bootstrap.dart`; use
`FakeScheduleRepository` seeded with the mock week for tests and for
`fvm flutter run` without credentials.

## Design tokens

Per `CLAUDE.md`, **no hex literals or inline `TextStyle` in
`lib/schedule/`** — all of the below goes into `packages/app_ui`.

### Theme

The display is **dark only** for V1. Set `MaterialApp.themeMode:
ThemeMode.dark` and drop `ThemeSwitcherWidget` from this screen.
`ThemeCubit` can stay in place for other screens.

This palette is a deliberate departure from
`ColorScheme.fromSeed(#2563EB)` — the user asked for a dark, low-colour
display. The neutrals are near-black greys and the only accent is the
`prov` red. Two reasonable ways to land it:

- Re-seed `AppColors` for the dark scheme and map: `surface` → `#0E0F12`,
  `surfaceContainer` → `#191A1F`, `surfaceContainerHigh` → `#1C1D22`,
  `onSurface` → `#E4E1E9`, `onSurfaceVariant` → `#8E8E98`, `outlineVariant`
  → `#33343B`, `error` → `#E0483C`, `onErrorContainer` → `#FFE2DE`.
- Or keep `ColorScheme` as-is and put the whole set in a **`ScheduleColors`
  `ThemeExtension`** — these are brand surfaces for a specific screen and
  several (`todayRing`, the banner presets, `syncOk`) have no Material role
  at all. This is the cleaner fit for the convention in `CLAUDE.md`, which
  says to reach for an extension for values with no Material role.

### Colours

| Token | Hex | Used for |
|---|---|---|
| `background` | `#0E0F12` | screen |
| `heroSurface` | `#191A1F` | hero container |
| `cardSurface` | `#1C1D22` | event cards, icon buttons |
| `onSurface` | `#E4E1E9` | event titles, week label |
| `onSurfaceStrong` | `#FFFFFF` | hero title, hero date, today's day name, nav arrows |
| `onSurfaceMedium` | `#A8A8B2` | hero subject, hero date line, pill text, today's date |
| `onSurfaceMuted` | `#8E8E98` | event labels, day dates, week range, sync text |
| `dayName` | `#C9C6CF` | non-today day names |
| `divider` | `#33343B` | day-header underline |
| `outline` | `#4A4B54` | countdown pill border |
| `provSurface` | `#26181A` | test card background |
| `provAccent` | `#E0483C` | test left edge, hero left edge, crayon ring |
| `provLabel` | `#FF8A80` | test labels, hero eyebrow |
| `provTitle` | `#FFE2DE` | test card title |
| `syncOk` | `#5C9C72` | sync dot, healthy |

Banner presets are listed under *Special events* above.

**Contrast:** every text/background pair here was measured at ≥ 4.5:1
(`#8E8E98` on `#191A1F` = 5.34:1 is the tightest). If you substitute a
colour, re-measure — this screen is viewed dimmed and from several metres.

### Spacing

The design uses these values; they do not all land on the current
`AppSpacing` scale (4 / 8 / 16 / 24 / 32).

| Used | Where |
|---|---|
| 4 | hero top margin, day-header left pad, card radius |
| 5 | label→title gap inside cards and day headers |
| 6 | special-lane row gap, icon-button gaps |
| 7 | event card gap within a column, sync row gap |
| 8 | nav-arrow left margin, banner inner gap, hero title top |
| 9 | grid column gap, card vertical pad, hero subject top |
| 12 | special-lane top margin, card horizontal pad, eyebrow gap |
| 13 | week-banner inner gap |
| 14 | app-bar item gap, grid top margin, icon-group left margin |
| 18 | side margins, week-banner horizontal pad |
| 20 | app-bar horizontal pad |
| 22 | hero row gap, hero left pad |
| 24 | hero right pad |

Either extend `AppSpacing` with the missing steps, or snap to a 4 dp grid
(5→4, 6→8, 7→8, 9→8, 13→12, 14→16, 18→16, 22→24) and accept the small
rhythm change. **If you snap, snap the 32 dp single-day banner grid and the
week grid together** — their column gaps must stay identical or the banner
will no longer line up with its day.

### Sizes (for `AppSizes`)

`appBarHeight` 56 · `heroHeight` 138 · `weekBannerHeight` 38 ·
`dayBannerHeight` 32 · `dayHeaderHeight` 52 · `iconButtonSize` 44 ·
`navArrowWidth` 48 · `navArrowGlyphWidth` 31 · `syncDotSize` 7 ·
`heroAccentWidth` 4 · `cardAccentWidth` 4 · `crayonRingBox` 126 × 56

### Radius (for `AppRadius`)

3 (special banners) · 4 (hero, event cards) · 12 (countdown pill) ·
22 (icon buttons, i.e. fully round). Only 4 exists today as
`AppRadius.xsmall`; 3 and 12 are new.

### Typography

Roboto throughout, matching `Typography.material2021()` already in
`AppTypography`. The sizes are chosen for across-the-room legibility and do
not map cleanly onto the M3 phone scale, so add them as named roles in
`AppTypography` rather than bending `TextTheme`:

| Role | Size / weight / line-height / tracking |
|---|---|
| `heroTitle` | 44 / w400 / 1.1 |
| `heroDate` | 40 / w400 / 1.0 |
| `heroSubject` | 21 / w300 |
| `heroDateSub` | 20 / w300 |
| `heroEyebrow` | 12 / w500 / ls 2.6 |
| `countdownPill` | 13 / w400 |
| `weekLabel` | 21 / w500 |
| `weekRange` | 17 / w300 |
| `syncLabel` | 15 / w300 |
| `bannerLabelWeek` | 11 / w500 / ls 2.2 |
| `bannerTitleWeek` | 18 / w400 |
| `bannerLabelDay` | 10 / w500 / ls 1.8 |
| `bannerTitleDay` | 16 / w400 |
| `dayName` | 16 / w500 / ls 1.2 |
| `dayDate` | 14 / w300 |
| `eventLabel` | 11 / w500 / ls 1.6 |
| `eventTitle` | 19 / w400 / 1.25 |

Nothing is below 10 dp, and nothing carrying real content is below 14.

## Localization

Every string goes through `gen-l10n` (`app_en.arb` is the template,
`app_sv.arb` must carry every key). The mock is in Swedish; the user wants
the app to follow the device locale, so both locales need real values.

Keys this screen needs:

- `scheduleWeekLabel` — `Vecka {week}` (placeholder `week`, number)
- `scheduleWeekRange` — `{start}–{end} {month}`
- `scheduleNextEventEyebrow` — `NÄSTA · {kind}` (`select` on severity)
- `scheduleDaysUntil` — `{days, plural, =1{1 dag kvar} other{{days} dagar kvar}}`
- `scheduleRelativeToday` / `scheduleRelativeTomorrow` — `Idag` / `Imorgon`
- `scheduleLastSynced` — `Uppdaterad {time}`
- `scheduleSpecialWeekLabel` — `HELA VECKAN`
- `scheduleSpecialDayLabel` — `HELDAG`
- `scheduleSeverityProv` / `scheduleSeverityLaxa` /
  `scheduleSeverityInlamning` — the label words
- `scheduleNoUpcoming` — hero empty state
- `scheduleNavPreviousWeekTooltip` / `scheduleNavNextWeekTooltip` /
  `scheduleSettingsTooltip` / `scheduleAlternateViewTooltip`

Day names, month names and times must come from `intl` with the active
locale, never from a hardcoded list. Note the mock shows uppercase day
abbreviations (`MÅN`, `TIS`) — apply `toUpperCase()` with the locale, since
Swedish `å`/`ä`/`ö` need it.

## Assets

None. No images, no icon fonts, no fonts to bundle:

- Roboto ships with Flutter / Android.
- The two app-bar glyphs (2 × 2 grid, gear) are stroked SVG placeholders in
  the prototype — **replace them with `Icons.grid_view_outlined` and
  `Icons.settings_outlined`** at 21 dp, `#8E8E98`. They were drawn only
  because the prototype had no Material icon set.
- The nav arrows and the crayon ring are custom paths and must be painted,
  not swapped for Material icons. Geometry for both is above /
  in `crayon_today_ring.dart`.

## Files

| File | What it is |
|---|---|
| `Week View.dc.html` | The locked design. Open at 1024 × 768. Has toggles for the countdown-present/absent states and for night dimming. |
| `crayon_today_ring.dart` | Reference Dart for the hand-drawn today ring — the one piece with no HTML→Flutter equivalent. Paste in and swap the literal colour for a token. |
| `Week Layouts.dc.html` | The full exploration this design was chosen from (turns 1–3). Useful for *why* — e.g. why severity is not colour-coded, why the specials sit above the grid. The locked design is option `3b`. |

## Open questions for the implementer

1. **Weekend columns** — adding a 6th/7th column changes every column's
   width for that week. Confirm that is acceptable versus a narrower
   fixed-width weekend column.
2. **Column overflow** — the `+N` affordance is specified but not designed.
   If the real data exceeds five cards in a column, ask for a design rather
   than shrinking type.
3. **Stale-sync thresholds** — the sync dot has one healthy colour
   specified. The warning colours and the time thresholds depend on the
   polling interval, which is not yet decided.
4. **Night dimming mechanism** — whether the device backlight can be driven
   on API 28 in kiosk mode determines which of the two options above is
   used.
