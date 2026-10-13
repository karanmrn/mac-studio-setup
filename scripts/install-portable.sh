#!/usr/bin/env bash
# Install reviewed portable source without copying machine state or enabling hooks.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=config/portable-versions.sh
. "$ROOT/config/portable-versions.sh"
DRY_RUN=${INSTALL_DRY_RUN:-0}
CONFIG_ONLY=0
UPGRADE=0
PIPELINE=0
REPLACE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --config-only) CONFIG_ONLY=1 ;;
    --upgrade) UPGRADE=1 ;;
    --replace-config) REPLACE=1 ;;
    --with-pipeline) PIPELINE=1 ;;
    --help)
      echo 'Usage: install.sh [--dry-run] [--config-only] [--upgrade] [--replace-config] [--with-pipeline]'
      exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done
[ -n "${HOME:-}" ] && [ "$HOME" != / ] && [[ "$HOME" = /* ]] || {
  echo 'HOME must be an absolute user home.' >&2; exit 1;
}
FM_HOME=${FM_HOME:-$HOME/karan-agent-workspace}
[[ "$FM_HOME" = /* ]] && [ "$FM_HOME" != / ] || {
  echo 'FM_HOME must be an absolute workspace path.' >&2; exit 1;
}
BACKUP_ROOT="$HOME/.local/state/mac-studio-setup/backups"
BACKUP_DIR="$BACKUP_ROOT/$(date -u +%Y%m%dT%H%M%SZ)-$$"
TMP=
trap '[ -z "$TMP" ] || rm -rf "$TMP"' EXIT
say() { printf '%s\n' "$*"; }
run() {
  if [ "$DRY_RUN" = 1 ]; then printf 'DRY_RUN:'; printf ' %q' "$@"; printf '\n';
  else "$@"; fi
}
# Back up symlink nodes without following their targets. Refuse linked parents.
safe_parent() {
  local p
  p=$(dirname "$1")
  while [ "$p" != / ]; do
    [ ! -L "$p" ] || { say "Refusing linked parent: $p" >&2; exit 1; }
    p=$(dirname "$p")
  done
}
backup() {
  local dest=$1 saved
  saved="$BACKUP_DIR${dest}"
  safe_parent "$saved"
  run mkdir -p "$(dirname "$saved")"
  run cp -RPp "$dest" "$saved"
  say "Backup: $saved"
}
put() {
  local src=$1 dest=$2
  safe_parent "$dest"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then say "Unchanged: $dest"; return; fi
    if [ "$REPLACE" != 1 ]; then
      say "Preserved existing config: $dest"
      say 'Review the template, then use --replace-config for a backed-up replacement.'
      return
    fi
    [ ! -d "$dest" ] || [ -L "$dest" ] || { say "Refusing directory: $dest" >&2; exit 1; }
    backup "$dest"
    run rm -f "$dest"
  fi
  run mkdir -p "$(dirname "$dest")"
  run cp "$src" "$dest"
}
fetch_binary() {
  local name=$1 version=$2 url=$3 digest=$4 archive=${5:-0} actual dest
  dest="$HOME/.local/bin/$name"
  safe_parent "$dest"
  if [ "$DRY_RUN" = 1 ]; then
    say "DRY_RUN: $name $version from $url (SHA-256 $digest)"
    return
  fi
  if [ -f "$dest" ] && [ ! -L "$dest" ] && "$dest" --version 2>/dev/null | grep -Eq "(^|[ v])${version//./\\.}($|[ ])"; then
    say "Unchanged: $name $version"; return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    [ "$UPGRADE" = 1 ] || { say "Preserved existing binary: $dest (use --upgrade)"; return; }
  fi
  [ -n "$TMP" ] || TMP=$(mktemp -d)
  curl --proto '=https' --tlsv1.2 -fsSL --max-filesize 100000000 "$url" -o "$TMP/asset"
  actual=$(shasum -a 256 "$TMP/asset" | awk '{print $1}')
  [ "$actual" = "$digest" ] || { say "Checksum mismatch: $name" >&2; exit 1; }
  if [ "$archive" = 1 ]; then
    mkdir -p "$TMP/unpack-$name"
    # Extract only the expected member, never arbitrary archive paths.
    tar -xzf "$TMP/asset" -C "$TMP/unpack-$name" "$name"
    [ -f "$TMP/unpack-$name/$name" ] && [ ! -L "$TMP/unpack-$name/$name" ] || exit 1
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then backup "$dest"; rm -f "$dest"; fi
  mkdir -p "$(dirname "$dest")"
  if [ "$archive" = 1 ]; then install -m 755 "$TMP/unpack-$name/$name" "$dest";
  else install -m 755 "$TMP/asset" "$dest"; fi
  "$dest" --version
}
checkout_firstmate() {
  local remote=https://github.com/karanmrn/firstmate.git head
  safe_parent "$FM_HOME/.git"
  if [ "$DRY_RUN" = 1 ]; then say "DRY_RUN: clone $remote at $FIRSTMATE_COMMIT to $FM_HOME"; return; fi
  if [ -e "$FM_HOME" ] || [ -L "$FM_HOME" ]; then
    [ -d "$FM_HOME/.git" ] && [ ! -L "$FM_HOME" ] || {
      say "Refusing non-clone Firstmate path: $FM_HOME" >&2; exit 1;
    }
    [ "$(git -C "$FM_HOME" remote get-url origin)" = "$remote" ] || {
      say 'Firstmate origin differs from the reviewed source.' >&2; exit 1;
    }
    head=$(git -C "$FM_HOME" rev-parse HEAD)
    [ "$head" = "$FIRSTMATE_COMMIT" ] || {
      say 'Existing Firstmate revision differs. Preserve it and use its owned update procedure.' >&2; exit 1;
    }
    [ -z "$(git -C "$FM_HOME" status --porcelain --untracked-files=no)" ] || {
      say 'Firstmate has tracked edits. Preserve them before setup.' >&2; exit 1;
    }
    say "Unchanged: Firstmate $head"
  else
    mkdir -p "$(dirname "$FM_HOME")"
    git clone --no-checkout "$remote" "$FM_HOME"
    git -C "$FM_HOME" checkout -B main "$FIRSTMATE_COMMIT"
    [ "$(git -C "$FM_HOME" rev-parse HEAD)" = "$FIRSTMATE_COMMIT" ] || exit 1
  fi
}
say 'Portable Codex/Herdr setup: gpt-6.1-sol, high reasoning.'
say 'Capacity: one supervisor, one worker, one build at a time.'
if [ "$CONFIG_ONLY" != 1 ]; then
  [ "$(uname -s)-$(uname -m)" = Darwin-arm64 ] || {
    say 'Package installation requires Apple Silicon macOS. Use --config-only for fixtures.' >&2; exit 1;
  }
  if [ "$DRY_RUN" != 1 ]; then
    command -v brew >/dev/null || { say 'Install Homebrew from brew.sh first.' >&2; exit 1; }
    command -v gh >/dev/null || { say 'Run brew install gh, then gh auth login and gh auth setup-git.' >&2; exit 1; }
    gh auth status >/dev/null 2>&1 || { say 'Run gh auth login and gh auth setup-git first.' >&2; exit 1; }
  fi
  # Homebrew verifies its signed metadata and package checksums. No broad upgrade.
  for package in node@22 jq ripgrep python@3.13; do
    if [ "$DRY_RUN" != 1 ] && brew list --versions "$package" >/dev/null 2>&1; then continue; fi
    run env HOMEBREW_NO_AUTO_UPDATE=1 brew install "$package"
  done
  for cask in wezterm font-jetbrains-mono-nerd-font font-hack-nerd-font; do
    if [ "$DRY_RUN" != 1 ] && brew list --cask --versions "$cask" >/dev/null 2>&1; then continue; fi
    run env HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask "$cask"
  done
  if [ "$DRY_RUN" != 1 ]; then
    NODE_PREFIX=$(brew --prefix node@22)
    export PATH="$NODE_PREFIX/bin:$PATH"
  fi
  for package in "@openai/codex@$CODEX_VERSION" "gh-axi@$GH_AXI_VERSION" "tasks-axi@$TASKS_AXI_VERSION" "quota-axi@$QUOTA_AXI_VERSION" "chrome-devtools-axi@$CHROME_DEVTOOLS_AXI_VERSION"; do
    name=${package%@*}
    version=${package##*@}
    if [ "$DRY_RUN" != 1 ] && npm list --global --prefix "$HOME/.local" --depth=0 "$name" 2>/dev/null | grep -Fq "$name@$version"; then continue; fi
    if [ "$DRY_RUN" != 1 ] && [ "$UPGRADE" != 1 ] && npm list --global --prefix "$HOME/.local" --depth=0 "$name" >/dev/null 2>&1; then
      say "Preserved existing npm package: $name (use --upgrade)"; continue
    fi
    case "$name" in @openai/codex) cli=codex ;; *) cli=$name ;; esac
    dest="$HOME/.local/bin/$cli"
    module="$HOME/.local/lib/node_modules/$name"
    safe_parent "$dest"
    safe_parent "$module"
    if [ -e "$dest" ] || [ -L "$dest" ] || [ -e "$module" ]; then
      if [ "$UPGRADE" != 1 ]; then
        say "Preserved existing npm destination: $name (use --upgrade)"
        continue
      fi
      if [ -e "$module" ] || [ -L "$module" ]; then backup "$module"; fi
      if [ -e "$dest" ] || [ -L "$dest" ]; then backup "$dest"; run rm -f "$dest"; fi
    fi
    # npm verifies registry tarball integrity. Explicit prefix avoids global config edits.
    run npm install --global --prefix "$HOME/.local" --registry=https://registry.npmjs.org "$package"
  done
  fetch_binary herdr "$HERDR_VERSION" "$HERDR_URL" "$HERDR_SHA256"
  fetch_binary treehouse "$TREEHOUSE_VERSION" "$TREEHOUSE_URL" "$TREEHOUSE_SHA256" 1
  if [ "$PIPELINE" = 1 ]; then
    fetch_binary no-mistakes "$NO_MISTAKES_VERSION" "$NO_MISTAKES_URL" "$NO_MISTAKES_SHA256" 1
  fi
  checkout_firstmate
fi
put "$ROOT/config/codex/config.toml" "$HOME/.codex/config.toml"
put "$ROOT/config/herdr/config.toml" "$HOME/.config/herdr/config.toml"
put "$ROOT/config/terminal/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
put "$ROOT/config/terminal/fleet-env.zsh" "$HOME/.config/mac-studio-setup/fleet-env.zsh"
# These are Firstmate-supported configuration files, not private task state.
if [ "$CONFIG_ONLY" = 1 ] || [ "$DRY_RUN" = 1 ] || [ -d "$FM_HOME/.git" ]; then
  put "$ROOT/config/codex/crew-dispatch.json" "$FM_HOME/config/crew-dispatch.json"
  if [ "$DRY_RUN" = 1 ]; then
    say "DRY_RUN: select herdr in $FM_HOME/config/backend and codex in config/crew-harness"
  else
    [ -n "$TMP" ] || TMP=$(mktemp -d)
    printf 'herdr\n' > "$TMP/backend"
    printf 'codex\n' > "$TMP/crew-harness"
    put "$TMP/backend" "$FM_HOME/config/backend"
    put "$TMP/crew-harness" "$FM_HOME/config/crew-harness"
  fi
fi
say 'Next: source ~/.config/mac-studio-setup/fleet-env.zsh, then run codex login.'
say 'Review Firstmate repository hooks interactively before supervision. No trust store was copied.'
say 'Read docs/HOW-WE-WORK.md for startup, project registration, delivery, and capacity rules.'
