#!/usr/bin/env bash
# Repeat reviewed pins. Broad Studio updates require explicit opt-in.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
if [ "${1:-}" = --studio ]; then
  shift
  exec bash "$ROOT/scripts/update-studio.sh" "$@"
fi
exec bash "$ROOT/install.sh" --upgrade "$@"
