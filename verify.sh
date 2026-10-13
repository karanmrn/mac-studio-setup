#!/usr/bin/env bash
# Read-only portable verification. Never starts Herdr, hooks, or a daemon.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ "${1:-}" = --studio ]; then shift; exec bash "$ROOT/scripts/verify-studio.sh" "$@"; fi
CONFIG_ONLY=0
if [ "${1:-}" = --config-only ]; then CONFIG_ONLY=1; shift; fi
[ "$#" = 0 ] || { echo 'Usage: verify.sh [--config-only|--studio]' >&2; exit 2; }
FM_HOME=${FM_HOME:-$HOME/karan-agent-workspace}
fail=0
check() {
  if "$@"; then printf 'PASS: %s\n' "$*";
  else printf 'FAIL: %s\n' "$*"; fail=$((fail + 1)); fi
}
check test -f "$HOME/.codex/config.toml"
check test -f "$HOME/.config/herdr/config.toml"
check test -f "$HOME/.config/wezterm/wezterm.lua"
check test -f "$HOME/.config/mac-studio-setup/fleet-env.zsh"
check cmp -s "$ROOT/config/codex/crew-dispatch.json" "$FM_HOME/config/crew-dispatch.json"
check grep -qx herdr "$FM_HOME/config/backend"
check grep -qx codex "$FM_HOME/config/crew-harness"
if [ "$CONFIG_ONLY" != 1 ]; then
  for cmd in brew gh git node python3 jq rg codex gh-axi tasks-axi quota-axi chrome-devtools-axi herdr treehouse; do
    check command -v "$cmd"
  done
  check test -d "$FM_HOME/.git"
  # Local readback only. Authentication and runtime compatibility require operator checks.
  check codex --version
  check herdr --version
  check treehouse --version
  printf '%s\n' 'LOGIN/RUNTIME: review codex login status, /model, hook trust, and Herdr client/server compatibility interactively.'
fi
printf 'Verification failures: %s\n' "$fail"
[ "$fail" = 0 ]
