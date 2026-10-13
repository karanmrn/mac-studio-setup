#!/usr/bin/env bash
# Daily fleet update: brew, npm globals, self-updaters, skills, gstack, Claude plugins, firstmate.
# Safe to run while workers are active except no-mistakes (see docs/UPDATING.md).
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FM_HOME="${FM_HOME:-$HOME/karan-agent-workspace}"
LOG="${FM_DECK_DIR:-$FM_HOME/data/deck}/update-all.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1

export PATH="$HOME/.local/share/vite-plus/bin:$HOME/.local/bin:$HOME/.no-mistakes/bin:/opt/homebrew/bin:$HOME/.grok/bin:$PATH"

echo "===== update-all $(date -u '+%F %T')Z repo=$REPO_ROOT ====="

step() { echo "--- $1"; }

step brew
brew update >/dev/null 2>&1 || true
brew upgrade 2>&1 | grep -iE 'upgrad|already|error' | head -20 || true

step npm-globals
npm update -g 2>&1 | grep -viE '^npm warn' | tail -5 || true

step self-updaters
command -v grok >/dev/null 2>&1 && grok update 2>&1 | tail -1 || echo "skip grok"
command -v cursor-agent >/dev/null 2>&1 && cursor-agent update 2>&1 | tail -1 || echo "skip cursor-agent"
if command -v no-mistakes >/dev/null 2>&1; then
  if no-mistakes axi status 2>/dev/null | grep -q running; then
    echo "skip no-mistakes update (pipeline running)"
  else
    no-mistakes update 2>&1 | tail -1 || true
  fi
else
  echo "skip no-mistakes"
fi
command -v vp >/dev/null 2>&1 && vp upgrade 2>&1 | tail -1 || echo "skip vp"
command -v treehouse >/dev/null 2>&1 && treehouse update 2>&1 | tail -1 || echo "skip treehouse"

step skills
npx -y skills@latest update -g -y 2>&1 | grep -E 'Updated|up to date|failed|error' | tail -8 || true

step gstack
GSTACK_DIR="$HOME/.agents/skills/gstack"
local_v=""
up_v=""
if [ -f "$GSTACK_DIR/VERSION" ]; then
  local_v="$(cat "$GSTACK_DIR/VERSION")"
fi
if command -v gh >/dev/null 2>&1; then
  up_v="$(gh api repos/garrytan/gstack/contents/VERSION --jq .content 2>/dev/null | base64 -d 2>/dev/null | tr -d '\n' | head -1)"
fi
echo "gstack local=${local_v:-missing} upstream=${up_v:-unknown}"
if [ -n "$up_v" ] && [ -n "$local_v" ] && [ "$local_v" != "$up_v" ]; then
  tmp="$(mktemp -d)"
  if git clone -q --single-branch --depth 1 https://github.com/garrytan/gstack.git "$tmp/gstack"; then
    mv "$GSTACK_DIR" "$HOME/.agents/skills/gstack.prev-$local_v" 2>/dev/null || true
    mv "$tmp/gstack" "$GSTACK_DIR"
    if [ -x "$GSTACK_DIR/setup" ]; then
      (cd "$GSTACK_DIR" && ./setup >/dev/null 2>&1) || echo "gstack setup warned"
    fi
    echo "gstack upgraded to $up_v"
  fi
  rm -rf "$tmp"
fi

step claude-plugins
if command -v claude >/dev/null 2>&1; then
  while IFS= read -r p; do
    [ -z "$p" ] && continue
    claude plugin update "$p" 2>&1 | tail -1 | cut -c1-120 || true
  done < <(claude plugin list 2>/dev/null | grep -oE '❯ [^ ]+' | sed 's/❯ //' || true)
else
  echo "skip claude plugins"
fi

step firstmate
if [ -x "$FM_HOME/bin/fm-update.sh" ]; then
  (cd "$FM_HOME" && bin/fm-update.sh 2>&1 | head -3) || true
else
  echo "skip fm-update (no clone)"
fi

step versions
for c in brew gh claude codex opencode pi grok cursor-agent herdr no-mistakes treehouse quota-axi; do
  if command -v "$c" >/dev/null 2>&1; then
    ver="$("$c" --version 2>&1 | head -1 | grep -oE '[0-9]+(\.[0-9]+){0,2}' | head -1)"
    printf '%s=%s ' "$c" "${ver:-ok}"
  fi
done
echo

echo "===== done $(date -u '+%F %T')Z ====="
