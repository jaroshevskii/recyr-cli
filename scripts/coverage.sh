#!/usr/bin/env bash
set -euo pipefail

# Unified coverage measurement for RecyrCLI.
#
# Produces:
#   * a per-file llvm-cov report for every RecyrCore source file
#   * a combined `coverage.lcov` file (suitable for Codecov / shield badges)
#
# Usage:
#   ./scripts/coverage.sh            # run tests, then report
#   ./scripts/coverage.sh --no-test  # only report (reuse existing profraw)
#
# Tools are resolved for both Apple and Linux toolchains.

SKIP_TEST=0
if [ "${1:-}" == "--no-test" ]; then
  SKIP_TEST=1
fi

# Resolve llvm-profdata / llvm-cov.
# macOS: under the active toolchain via `xcrun`.
# Linux: the Swift container ships llvm tools alongside the `swift` binary.
if command -v xcrun >/dev/null 2>&1; then
  PROF=(xcrun llvm-profdata)
  COV=(xcrun llvm-cov)
else
  SWIFT_BIN="$(dirname "$(command -v swift)")"
  PROF=("$SWIFT_BIN/llvm-profdata")
  COV=("$SWIFT_BIN/llvm-cov")
fi

if [ "$SKIP_TEST" -eq 0 ]; then
  swift test --enable-code-coverage
fi

CODECOV_DIR=".build/debug/codecov"
PROFDATA="$CODECOV_DIR/default.profdata"

if [ -n "$(ls "$CODECOV_DIR"/*.profraw 2>/dev/null)" ]; then
  "${PROF[@]}" merge -sparse "$CODECOV_DIR"/*.profraw -o "$PROFDATA"
fi

: > coverage.lcov
for obj in .build/debug/RecyrCore.build/*.o; do
  "${COV[@]}" report -instr-profile "$PROFDATA" -object "$obj"
  "${COV[@]}" export -format=lcov -instr-profile "$PROFDATA" -object "$obj" >> coverage.lcov
  echo
done