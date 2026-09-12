#!/usr/bin/env bash
# Idempotent bootstrap for a fresh clone of this template.
#
# Safe to re-run at any time. Performs:
#   1. fvm use stable (creates/updates .fvmrc)
#   2. pub get
#   3. gen-l10n
#   4. build_runner (only if any *.dart file uses @freezed or a codegen
#      annotation — skipped otherwise to keep first-run fast).
#
# Intentionally does NOT upgrade package major versions.
# Run `scripts/upgrade.sh` for that.

set -euo pipefail

cd "$(dirname "$0")/.."

echo "▶ fvm use stable"
fvm use stable --force

echo "▶ fvm flutter pub get"
fvm flutter pub get

echo "▶ fvm flutter gen-l10n"
fvm flutter gen-l10n

./scripts/codegen.sh

echo "✓ setup complete"
