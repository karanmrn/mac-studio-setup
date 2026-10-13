#!/usr/bin/env bash
# Portable Codex/Herdr is the default. The historical Studio profile is opt-in.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ "${1:-}" = --studio ]; then
  shift
  exec bash "$ROOT/scripts/install-studio.sh" "$@"
fi
exec bash "$ROOT/scripts/install-portable.sh" "$@"
