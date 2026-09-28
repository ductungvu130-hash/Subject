#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v pwsh >/dev/null 2>&1; then
  echo "PowerShell 7+ (pwsh) is required. Install with: brew install powershell" >&2
  exit 1
fi

for cmd in java javac jar; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "JDK required: '$cmd' not found on PATH." >&2
    exit 1
  fi
done

cd "$ROOT"
exec pwsh -NoProfile -File "$SCRIPT_DIR/build-simulations-common.ps1" -LauncherPlatform Unix "$@"
