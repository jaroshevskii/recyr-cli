#!/usr/bin/env bash
set -euo pipefail

# Format all Swift sources using swift-format (default settings).
#
# Usage:
#   ./scripts/format.sh            # format in-place
#   ./scripts/format.sh --lint     # lint only (exits non-zero if unformatted)

LINT=0
if [ "${1:-}" == "--lint" ]; then
  LINT=1
fi

if command -v xcrun >/dev/null 2>&1; then
  FORMAT=(xcrun swift-format)
else
  FORMAT=(swift-format)
fi

FILES=$(find Sources Tests -name '*.swift' -not -path '*/.*' 2>/dev/null)

if [ -z "$FILES" ]; then
  echo "No Swift files found."
  exit 0
fi

if [ "$LINT" -eq 1 ]; then
  echo "Linting..."
  echo "$FILES" | xargs "${FORMAT[@]}" lint
  echo "All files are formatted."
else
  echo "Formatting..."
  echo "$FILES" | xargs "${FORMAT[@]}" --in-place
  echo "Done."
fi
