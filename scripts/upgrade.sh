#!/usr/bin/env bash
# Deliberate major-version upgrade of all workspace dependencies.
#
# This CAN break your app. Review the diff, run analyze + tests, and
# pin anything that shouldn't float.
#
# Pipeline:
#   1. pub upgrade --major-versions (root + all workspace members)
#   2. gen-l10n (in case intl/flutter_localizations bumped)
#   3. build_runner rebuild
#   4. flutter analyze + flutter test (fail loud if something broke)

set -euo pipefail

cd "$(dirname "$0")/.."

echo "▶ fvm flutter pub upgrade --major-versions"
fvm flutter pub upgrade --major-versions

echo "▶ fvm flutter gen-l10n"
fvm flutter gen-l10n

# No codegen step here: verify.sh runs it as its first step.
echo "▶ verify"
./scripts/verify.sh

echo "✓ upgrade complete — review the pubspec.lock diff before committing"
