# school-app

A wall-mounted display for a school schedule — tests, homework, and events —
synced automatically from Gmail and Google Drive into a shared Google
Calendar, and rendered read-only on an old Android tablet. See
[`docs/project.md`](docs/project.md) for the full brief (goal, data sources,
architecture, device constraints) and its open items for what's still
unbuilt.

Built on my personal Flutter starter template — `app_ui` design system, BLoC
+ Freezed, `go_router` with a working auth redirect, localization (en/sv),
light/dark theming, FVM, and a repository package wired as an interface with
a fake. Architecture and conventions are documented in [`CLAUDE.md`](CLAUDE.md).

## Getting started

```bash
./scripts/setup.sh   # fvm use stable, pub get, gen-l10n, codegen
fvm flutter run
```

## Daily commands

```bash
fvm flutter run          # run the app
./scripts/verify.sh      # codegen + analyze + format + tests, everywhere
./scripts/codegen.sh     # build_runner, root and every package that needs it
fvm flutter gen-l10n     # after editing any .arb file
```

Prefer the scripts over bare `fvm flutter test` / `build_runner`: neither
descends into workspace members, so a repo with domain logic in `packages/`
reports green having run a fraction of its suite.

## GitHub Actions

Optional. `.github/workflows/claude.yml` runs only when someone writes
`@claude` in an issue or PR comment — never automatically on every PR. Delete
the file if you don't want it.

To use it, add an `ANTHROPIC_API_KEY` repository secret (Settings → Secrets
and variables → Actions → New repository secret; an org-level secret works
too) — without it the workflow fails.

## Upgrading dependencies

```bash
./scripts/upgrade.sh   # major-version upgrade, then the full verify chain
```

Review the `pubspec.lock` diff before committing.
