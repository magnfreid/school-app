# flutter-starter

My personal Flutter project template — `app_ui` design system, BLoC + Freezed,
`go_router` with a working auth redirect, localization (en/sv), light/dark
theming, FVM, and a repository package wired as an interface with a fake.

Its architecture and conventions are documented in `CLAUDE.md`.

## Fresh clone

```bash
./scripts/setup.sh
```

Then:

1. Commit the generated `.fvmrc`
2. Rename the package — find/replace `flutter_starter` with your app name in
   `pubspec.yaml` and all `package:flutter_starter/` imports
3. Set your seed color in `packages/app_ui/lib/colors/app_colors.dart`
4. Replace `lib/home/` with your first real feature
5. Point `bootstrap.dart` at a real `AuthRepository` — see below

## What's wired already

**Auth flow.** `splash → login → home`, driven by `AuthCubit` mirroring
`AuthRepository.authStateChanges` into `AuthState`, with a single `redirect` in
`lib/app/router/app_router.dart` reacting to it. The redirect is a *guard*: it
names the locations each auth state may not be at and lets everything else
through, so routes you add later are reachable without touching it. Add public
routes (sign-up, password reset) to `AppRouter._publicPaths`.

**Swapping in a real backend.** `AuthRepository` is an `abstract interface
class`. `InMemoryAuthRepository` is the placeholder so a fresh clone runs
end-to-end; `FakeAuthRepository` is the scriptable double for tests. Write your
own implementation, change the one line in `bootstrap.dart` that names it, and
no feature code moves.

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

## Adding a feature or package

Copy the shape of an existing feature (`lib/login/` is the fullest example) or
package (`packages/auth_repository/`) by hand — see `CLAUDE.md` for the folder
layout and the interface/fake pattern.

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
