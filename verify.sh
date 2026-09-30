#!/usr/bin/env bash
# Green/red table for Mac Studio setup verification.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles-karan}"
FM_HOME="${FM_HOME:-$HOME/karan-agent-workspace}"

pass=0
fail=0

check() {
  local name="$1" ok="$2" detail="${3:-}"
  if [ "$ok" = "1" ]; then
    printf '\033[32mPASS\033[0m %-28s %s\n' "$name" "$detail"
    pass=$((pass + 1))
  else
    printf '\033[31mFAIL\033[0m %-28s %s\n' "$name" "$detail"
    fail=$((fail + 1))
  fi
}

has() { command -v "$1" >/dev/null 2>&1; }

ver() {
  local cmd="$1"
  shift
  if has "$cmd"; then
    "$cmd" "$@" 2>/dev/null | head -1 || echo "ok"
  else
    echo "missing"
  fi
}

printf '=== mac-studio-setup verify ===\n\n'

# CLIs
for pair in \
  "brew:brew --version" \
  "gh:gh --version" \
  "claude:claude --version" \
  "codex:codex --version" \
  "cursor-agent:cursor-agent --version" \
  "grok:grok --version" \
  "herdr:herdr --version" \
  "treehouse:treehouse --version" \
  "no-mistakes:no-mistakes --version" \
  "opencode:opencode --version" \
  "pi:pi --version" \
  "quota-axi:quota-axi --version" \
  "gh-axi:gh-axi --version" \
  "tasks-axi:tasks-axi --version" \
  "acpx:acpx --version" \
  "gnhf:gnhf --version" \
  "vp:vp --version"; do
  name="${pair%%:*}"
  cmd="${pair#*:}"
  if eval "$cmd" >/dev/null 2>&1; then
    check "$name" 1 "$(eval "$cmd" 2>/dev/null | head -1)"
  else
    check "$name" 0 "not on PATH"
  fi
done

# Fonts
if fc-list 2>/dev/null | grep -qi 'jetbrains.*nerd' || ls ~/Library/Fonts/*JetBrains* 2>/dev/null | grep -qi nerd; then
  check "font-jetbrains-nerd" 1 ""
else
  check "font-jetbrains-nerd" 0 "install brew cask font-jetbrains-mono-nerd-font"
fi

# Dotfiles links
if [ -L "$HOME/.config/wezterm/wezterm.lua" ] && [ -d "$DOTFILES_DIR" ]; then
  check "wezterm dotfiles link" 1 "$(readlink "$HOME/.config/wezterm/wezterm.lua" 2>/dev/null || true)"
else
  check "wezterm dotfiles link" 0 "run ~/.dotfiles-karan/install.sh"
fi

if [ -f "$HOME/.claude/statusline.sh" ]; then
  check "claude statusline" 1 ""
else
  check "claude statusline" 0 ""
fi

GLOBAL_AGENTS="$DOTFILES_DIR/home/.config/agents/AGENTS.md"
if [ -f "$GLOBAL_AGENTS" ]; then
  ok=1
  detail=""
  for link in \
    "$HOME/.config/agents/AGENTS.md" \
    "$HOME/.codex/AGENTS.md" \
    "$HOME/.grok/AGENTS.md" \
    "$HOME/.config/opencode/AGENTS.md"; do
    if [ ! -L "$link" ]; then
      ok=0
      detail="missing $link"
      break
    fi
  done
  check "global AGENTS symlinks" "$ok" "$detail"
else
  check "global AGENTS symlinks" 0 "missing $GLOBAL_AGENTS"
fi

if [ -f "$FM_HOME/data/deck/quota.sh" ]; then
  check "quota deck script" 1 ""
else
  check "quota deck script" 0 "copy from repo config/deck"
fi

if [ -f "$HOME/.config/herdr/config.toml" ] || [ -L "$HOME/.config/herdr/config.toml" ]; then
  check "herdr config.toml" 1 ""
else
  check "herdr config.toml" 0 "dotfiles install.sh or install.sh config/herdr copy"
fi

# Firstmate
if [ -d "$FM_HOME/.git" ]; then
  check "firstmate clone" 1 "$FM_HOME"
else
  check "firstmate clone" 0 ""
fi

if [ -L "$FM_HOME/projects/pubmax" ] || [ -d "$FM_HOME/projects/pubmax/.git" ]; then
  check "projects/pubmax" 1 ""
else
  check "projects/pubmax" 0 ""
fi

# Runners (launchd)
for label in \
  actions.runner.Singularityszn-pubmax.karan-mac-pubmax \
  actions.runner.Singularityszn-pubmax.karan-mac-pubmax-2 \
  actions.runner.Singularityszn-pubmax.karan-mac-pubmax-3; do
  if launchctl list 2>/dev/null | grep -q "$label"; then
    check "runner $label" 1 "launchd loaded"
  else
    check "runner $label" 0 "not loaded (optional until CI runners needed)"
  fi
done

# keys.env (names only — must exist locally, never in git)
if [ -f "$FM_HOME/data/keys.env" ]; then
  check "data/keys.env" 1 "present (mode should be 600)"
else
  check "data/keys.env" 0 "migrate from old Mac (AirDrop); see docs/MIGRATION.md"
fi

printf '\n=== %d passed, %d failed ===\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
