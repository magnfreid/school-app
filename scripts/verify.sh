#!/usr/bin/env bash
# The full pre-push check, in the order CLAUDE.md's testing conventions define.
#
#   1. build_runner   (only when a codegen annotation exists)
#   2. analyze
#   3. format --set-exit-if-changed
#   4. test (root)
#   5. test (each workspace member that has a test/)
#
# Step 5 is the point of this script. `fvm flutter test` at the root does NOT
# descend into workspace members, so a repo that keeps its domain logic in
# packages/ reports green having run a fraction of its suite.

set -euo pipefail

cd "$(dirname "$0")/.."

./scripts/codegen.sh

echo "▶ analyze"
fvm flutter analyze

echo "▶ format check"
fvm dart format --set-exit-if-changed lib packages test

echo "▶ test (root)"
fvm flutter test

for pkg in packages/*/; do
  # find, not a glob: `**` is not recursive unless globstar is set, so a glob
  # silently skips a package whose tests sit more than one level deep — the
  # exact miss this loop exists to prevent.
  if find "${pkg}test" -name '*_test.dart' -print -quit 2>/dev/null | grep -q .; then
    echo "▶ test ($pkg)"
    (cd "$pkg" && fvm flutter test)
  fi
done

echo "✓ verify complete"
