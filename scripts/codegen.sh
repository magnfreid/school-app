#!/usr/bin/env bash
# Runs build_runner wherever it is actually needed.
#
# `build_runner` at the repo root only builds the root package — it does NOT
# descend into workspace members. A member with @freezed models silently keeps
# stale (or missing) .freezed.dart files until something fails to compile.
# So: root first, then every packages/* that has both a codegen annotation and
# build_runner in its dev_dependencies.

set -euo pipefail

cd "$(dirname "$0")/.."

CODEGEN_ANNOTATIONS="@(freezed|Freezed|JsonSerializable|HiveType)"

run_if_needed() {
  local dir="$1" label="$2"
  [ -d "$dir/lib" ] || return 0
  grep -rqE "$CODEGEN_ANNOTATIONS" "$dir/lib" 2>/dev/null || return 0
  grep -q "build_runner" "$dir/pubspec.yaml" 2>/dev/null || {
    echo "⚠  $label uses codegen annotations but has no build_runner dev dependency"
    return 0
  }
  echo "▶ build_runner ($label)"
  (cd "$dir" && fvm dart run build_runner build --delete-conflicting-outputs)
}

run_if_needed "." "root"
for pkg in packages/*/; do
  run_if_needed "${pkg%/}" "${pkg%/}"
done
