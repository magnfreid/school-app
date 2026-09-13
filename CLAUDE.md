# CLAUDE.md

Flutter boilerplate. This file documents the project's structure and
architectural conventions — state management, folder layout, the
repository/fake pattern, routing, theming, localization, and testing.

## Project structure

`lib/` is UI-only. No services, repos, APIs, or domain logic inside `lib/`.

```
lib/
  app/
    app.dart            # MaterialApp, theme + l10n wiring
    cubit/
      calendar_config_cubit.dart  # CalendarConfig gate state, mirrors the repo
      theme_cubit.dart  # ThemeMode, cycled from the app bar
    router/
      app_router.dart   # GoRouter construction, config-gate redirect
      routes.dart       # Route definitions, path/name constants
  l10n/
    app_en.arb          # English (source of truth)
    app_sv.arb          # Swedish
                        # Generated l10n files land here
  <feature>/
    bloc/ view/            # always present
    widgets/ models/ extensions/  # added as needed — no current feature has them
  bootstrap.dart        # runApp, long-lived provider setup

packages/
  app_ui/               # Pre-built design system. See below.
  bloc_utils/           # Event transformers; re-exports bloc_concurrency
  calendar_config_repository/  # CalendarConfigRepository + InMemory and Fake impls
  schedule_repository/  # ScheduleRepository + Fake impl and week math

test/
  helpers/app_harness.dart   # The provider stack bootstrap installs
  integration/
```

Copy the shape of an existing feature for a new one. `lib/schedule/`,
`lib/setup/` and `lib/settings/` are placeholder pages only — until a real
feature lands there is no fullest worked example, and the first one sets the
shape. See **Architecture conventions** below for the Page/View split and
when to extract a widget.

## Architecture conventions

### State management

BLoC and Cubit, via `flutter_bloc`. Freezed for every state and event class —
never `Equatable`; Freezed's generated `==` already covers it. Carve-out: a
Cubit whose state is already a plain existing enum with no fields to wrap
(`ThemeCubit`/`ThemeMode`) stays as that enum rather than gaining an
artificial Freezed wrapper.

**Cubit** when state just mirrors something upstream and there's no user
intent worth naming as an event — `CalendarConfigCubit` mirrors
`CalendarConfigRepository.configChanges`, `ThemeCubit` just cycles a mode.
**BLoC** everywhere else, in particular anything with a submit/retry/toggle a
user triggers. No feature ships a BLoC yet — the first one that needs it sets
the worked example.

State shape is a sealed union (`@freezed sealed class`) for screens whose
states are mutually exclusive with different data — forms, gates, onboarding;
see `CalendarConfigState`.

Events are always sealed unions, one file per bloc's event set
(`<feature>_event.dart`). Apply an event transformer only when an event has a
real concurrency requirement — `droppable()` on a submit event so a
double-tap can't fire two requests, for instance. Don't add one by default;
un-transformed (concurrent) is correct for independent events like navigation
or toggles.

Run `fvm dart run build_runner build --delete-conflicting-outputs` (or
`./scripts/codegen.sh`) after touching any `@freezed` file — see Scripts.

### Repositories: interfaces and fakes

Every external dependency — auth, a future API, storage — is an
`abstract interface class` in its own `packages/<name>_repository` package.
Feature code and BLoCs depend on the interface, never on an implementation:
`context.read<CalendarConfigRepository>()` resolves to the contract even
though `bootstrap.dart` is what actually provided
`InMemoryCalendarConfigRepository`.

Each interface package ships three things:

- **The interface**, plus any domain exception type it throws
  (`CalendarConfigException`). Implementations translate vendor errors into
  this before they cross the package boundary — a vendor type must never
  reach `lib/`.
- **A real (or in-memory placeholder) implementation**, wired in exactly one
  place: `bootstrap.dart`. Swapping backends is a one-line change there and
  touches no feature code.
- **A `Fake*` implementation**, scriptable up front
  (`FakeCalendarConfigRepository(initialConfig: ..., saveError: ...)`), for
  tests. Write a mocktail `Mock` only for a dependency that doesn't have a
  fake yet — a repository that already ships one doesn't need a second test
  double.

`calendar_config_repository` is the worked example — read it before adding
the next repository package.

### Router

`go_router`, centralized in `lib/app/router/`: `routes.dart` holds every
`GoRoute` plus an `AppRoutes` namespace of `(name, path)` record constants;
`app_router.dart` builds the `GoRouter` and owns the redirect. Split
`routes.dart` by feature domain only once it gets noisy (~200 lines / ~15
routes) — not before.

Never call `Navigator.push` / `Navigator.pop` from feature code. Navigate with
`context.go()` / `context.push()` against `AppRoutes.*` constants — `go`
replaces the stack at that level, `push` stacks on top; most transitions
should be `go`.

The config-gate redirect is a **guard, not a router**: it names the locations
each gate state may *not* be at and returns `null` (pass through) for
everything else — see the comment on `AppRouter._redirect`. A redirect that
instead pins each state to exactly one location makes every route added later
unreachable, and nothing fails until the app has a fourth screen.

`_GoRouterRefreshStream` (in `app_router.dart`) is hand-rolled, not imported —
`go_router` shipped a `GoRouterRefreshStream` and then removed it. Its
`removeListener` override (stand down only once the *last* listener goes, not
just in `dispose()`) is the part that's easy to drop and the part that
actually prevents a leaked stream subscription per router built. Don't
simplify it away.

### Theming

`packages/app_ui` owns all theme construction — colors, typography, spacing,
radius. `ColorScheme` first (`ColorScheme.fromSeed` + semantic roles like
`primary`/`surface`/`outline`); reach for a `ThemeExtension` only for a value
that has no Material role (a brand surface, a bubble colour), never because an
existing role "isn't quite right" — adjust the seed or the role instead.

No hex literals, no inline `TextStyle`, no magic spacing numbers in
`lib/<feature>/`. If you're typing a colour or a bare `SizedBox(height: 16)` in
feature code, a token in `app_ui` is missing — add it there (named for role,
not appearance: `interviewSurface`, not `warmOffWhite`), then use it. Consume
tokens through the `context.spacing` / `context.radius` / `context.text` /
`context.colors` extensions, and always import the barrel
(`package:app_ui/app_ui.dart`) — never
`package:app_ui/<dir>/<file>.dart` directly.

### Localization

Flutter's built-in `gen-l10n`, wired at the project root (`l10n.yaml`). `en` is
the template and the source of truth — every key and its `@key` metadata lives
in `app_en.arb` first; `app_sv.arb` only needs translated values, and every key
in `app_en.arb` must exist there too. Run `fvm flutter gen-l10n` (or
`./scripts/setup.sh` / `codegen.sh`) after touching either ARB file.

Every user-facing string goes through it. No hardcoded literals, no string
concatenation for dynamic content — use ARB placeholders and `plural`/`select`
syntax instead.

## Testing

**Tests ship in the same PR as the code they cover** — not a follow-up pass.

**Required** for any change that adds one: a new BLoC/Cubit (state
transitions *and* error paths), a new repository/service public contract
(including its failure mapping), pure domain logic, and any `_guard`-style
method whose catch-clause order matters — a handler that rethrows a typed
exception before a catch-all is order-dependent, and getting the order wrong
fails silently. Assert the *specific* failure, not a loose `isA<...>()`. The
same reasoning covers precedence generally — `AppRouter._redirect`'s ordering
is the live example, pinned by `test/app/router/app_router_test.dart`.

**Default:** one widget test per new page, pumped through the real
`<Feature>Page` (not the `View`) so its own `BlocProvider`/`RepositoryProvider`
wiring is exercised — mock the repositories the page's bloc depends on, not
the bloc itself. Add a `View`-level test (injecting a scripted bloc via
`BlocProvider.value`) only when you need to assert how a specific state
renders; that's why `<Feature>View` is public rather than private-prefixed.

**Not required:** pure layout widgets, generated code (`*.freezed.dart`,
`app_localizations*.dart`).

```
test/                          # mirrors lib/ — e.g. lib/app/cubit/calendar_config_cubit.dart
  app/cubit/calendar_config_cubit_test.dart  # is covered at test/app/cubit/calendar_config_cubit_test.dart
  helpers/app_harness.dart     # wrapWithAppProviders — pump through this, not a
                                # hand-built provider subset, so tests exercise
                                # the same wiring bootstrap.dart runs with
  integration/
packages/<pkg>/test/           # each workspace package has its own test/
```

`bloc_test` for BLoC/Cubit tests. `mocktail` for mocks — never
`mockito`/`@GenerateMocks`; this project's fakes and mocks are hand-written, no
codegen. Assert widget text against the resolved `AppLocalizations` delegate,
never a hardcoded English literal — a hardcoded string breaks on a copy edit
and proves nothing about the l10n wiring.

Full coverage is explicitly not the goal — cover the seams that break silently
and the paths a user actually walks; say so in the PR's open items when you
skip something churny.

## Pre-built packages (do not regenerate)

### `app_ui`

```
packages/app_ui/lib/
  colors/ typography/ themes/ spacing/ radius/ sizes/
  extensions/   # context.spacing, context.radius, context.sizes, context.text, context.colors
  widgets/      # ThemeSwitcherWidget
```

`ThemeSwitcherWidget` is driven by `ThemeCubit` in `lib/app/cubit/` and wired
to `MaterialApp.themeMode` in `app.dart`.

### `calendar_config_repository`

`CalendarConfigRepository` (interface) + `InMemoryCalendarConfigRepository`
(what `bootstrap.dart` wires so a fresh clone boots straight to the schedule
without a backend) + `FakeCalendarConfigRepository` (scriptable double tests
use). See **Repositories: interfaces and fakes** above for the pattern this
package exists to demonstrate.

## Workspace

Root `pubspec.yaml` declares each member explicitly (Dart workspaces don't
support globs) **and** lists each as a dependency. Each member pubspec sets
`resolution: workspace`. Add both halves by hand when creating a new package.

## Lint

Line length 80 — `dart format`'s default; the repo configures no `page_width`.
Root and `app_ui` include `package:flutter_lints/flutter.yaml`; the three
Dart-only packages (`bloc_utils`, `calendar_config_repository`,
`schedule_repository`) include `package:lints/recommended.yaml`. Each package
under `packages/` additionally enables `public_member_api_docs`; root `lib/`
does not.

## Scripts

| Script | Purpose |
| --- | --- |
| `setup.sh` | Idempotent. `fvm use stable`, pub get, gen-l10n, codegen. Safe to re-run. |
| `verify.sh` | The full pre-push chain: codegen, analyze, format, tests everywhere. Run before pushing. |
| `codegen.sh` | `build_runner` at the root **and** in every package that needs it. |
| `upgrade.sh` | Deliberate. `pub upgrade --major-versions`, then `verify.sh`. Review the `pubspec.lock` diff. |

`build_runner` and `flutter test` at the repo root do **not** descend into
workspace members. `codegen.sh` and `verify.sh` exist because of that — use them
rather than the bare commands.

## Fresh-clone checklist

- [ ] `./scripts/setup.sh`
- [ ] Commit the generated `.fvmrc`
- [x] Rename the package (`flutter_starter` → your name) in root `pubspec.yaml`
      and all `package:flutter_starter/...` imports
- [ ] Update `AppColors.seed` in `packages/app_ui/lib/colors/app_colors.dart`
- [ ] Replace the placeholder pages in `lib/schedule/`, `lib/setup/` and
      `lib/settings/`
- [ ] Point `bootstrap.dart` at a real `CalendarConfigRepository`
      implementation
- [ ] Add `ANTHROPIC_API_KEY` as a repo secret if you want the `@claude`
      GitHub workflow
- [ ] (Optional) `./scripts/upgrade.sh` if the template has been sitting a while
