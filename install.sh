#!/usr/bin/env bash
# Idempotent Mac Studio / Apple Silicon setup for the captain's fleet machine.
# Safe to re-run. Never uses sudo. Never writes secrets into the repo.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="${INSTALL_LOG:-$REPO_ROOT/install.log}"
DRY_RUN="${INSTALL_DRY_RUN:-0}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/karanmrn/karan-herdr-shortcut-setup.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles-karan}"
FM_HOME="${FM_HOME:-$HOME/karan-agent-workspace}"
TREEHOUSE_VERSION="${TREEHOUSE_VERSION:-v3.1.0}"
NO_MISTAKES_VERSION="${NO_MISTAKES_VERSION:-v1.79.0}"

log() { printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG"; }
run() {
  if [ "$DRY_RUN" = "1" ]; then
    log "DRY_RUN: $*"
  else
    log "RUN: $*"
    eval "$@"
  fi
}

need_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    log "skip $1 (present: $(command -v "$1"))"
    return 1
  fi
  return 0
}

log "=== mac-studio-setup install (DRY_RUN=$DRY_RUN) ==="

# --- Homebrew ---
if need_cmd brew; then
  run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- GitHub CLI ---
if need_cmd gh; then
  run 'brew install gh'
fi

# --- Dotfiles (WezTerm, Ghostty, herdr keys, shell, statusline symlink) ---
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  run "git clone '$DOTFILES_REPO' '$DOTFILES_DIR'"
else
  log "skip dotfiles clone ($DOTFILES_DIR exists)"
fi
if [ -x "$DOTFILES_DIR/install.sh" ]; then
  run "'$DOTFILES_DIR/install.sh'"
fi

# --- Global AGENTS.md symlinks (shared Codex, Grok, OpenCode, Claude; Kunchen pattern) ---
GLOBAL_AGENTS="$DOTFILES_DIR/home/.config/agents/AGENTS.md"
if [ -f "$GLOBAL_AGENTS" ]; then
  run "mkdir -p '$HOME/.config/agents' '$HOME/.codex' '$HOME/.grok' '$HOME/.config/opencode' '$HOME/.claude'"
  for dest in \
    "$HOME/.config/agents/AGENTS.md" \
    "$HOME/.codex/AGENTS.md" \
    "$HOME/.grok/AGENTS.md" \
    "$HOME/.config/opencode/AGENTS.md" \
    "$HOME/.claude/CLAUDE.md"; do
    run "ln -sfn '$GLOBAL_AGENTS' '$dest'"
  done
else
  log "warn: missing $GLOBAL_AGENTS (dotfiles not installed yet)"
fi

# --- Brewfile from this repo ---
if [ -f "$REPO_ROOT/Brewfile" ]; then
  run "HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file='$REPO_ROOT/Brewfile'"
fi

# --- Node toolchain via Vite+ (vp) ---
if need_cmd vp; then
  run 'curl -fsSL https://vite.plus/install.sh | bash'
fi
if command -v vp >/dev/null 2>&1; then
  run 'vp upgrade'
fi

# --- npm global prefix (~/.local) ---
mkdir -p "$HOME/.local/bin"
if ! npm config get prefix 2>/dev/null | grep -q '.local'; then
  run "npm config set prefix '$HOME/.local'"
fi
export PATH="$HOME/.local/bin:$PATH"

NPM_GLOBAL_PKGS=(
  '@openai/codex'
  '@earendil-works/pi-coding-agent'
  '@xai-official/grok'
  'acpx'
  'agent-browser'
  'chrome-devtools-axi'
  'gh-axi'
  'gitnexus'
  'gnhf'
  'prime-agent'
  'quota-axi'
  'skills'
  'tasks-axi'
)
for pkg in "${NPM_GLOBAL_PKGS[@]}"; do
  if npm list -g --depth=0 "$pkg" >/dev/null 2>&1; then
    log "skip npm -g $pkg (installed)"
  else
    run "npm install -g '$pkg'"
  fi
done

# --- Cursor agent CLI ---
if need_cmd cursor-agent; then
  run 'curl -fsSL https://cursor.com/install | bash'
elif command -v cursor-agent >/dev/null 2>&1; then
  run 'cursor-agent update'
fi

# --- OpenCode ---
if need_cmd opencode; then
  run 'curl -fsSL https://opencode.ai/install | bash'
fi

# --- Grok self-update when present ---
if command -v grok >/dev/null 2>&1; then
  run 'grok update'
fi

# --- treehouse (kunchenguid binary release) ---
if need_cmd treehouse; then
  arch="$(uname -m)"
  case "$arch" in
    arm64) asset="treehouse-${TREEHOUSE_VERSION}-darwin-arm64.tar.gz" ;;
    x86_64) asset="treehouse-${TREEHOUSE_VERSION}-darwin-amd64.tar.gz" ;;
    *) log "unknown arch $arch; install treehouse manually"; asset="" ;;
  esac
  if [ -n "$asset" ]; then
    tmp="$(mktemp -d)"
    run "curl -fsSL -o '$tmp/$asset' 'https://github.com/kunchenguid/treehouse/releases/download/${TREEHOUSE_VERSION}/$asset'"
    run "tar -xzf '$tmp/$asset' -C '$tmp'"
    run "install -m 755 '$tmp/treehouse' '$HOME/.local/bin/treehouse'"
    run "rm -rf '$tmp'"
  fi
fi

# --- no-mistakes (release tarball) ---
if need_cmd no-mistakes; then
  nm_asset="no-mistakes-${NO_MISTAKES_VERSION}-darwin-arm64.tar.gz"
  tmp="$(mktemp -d)"
  run "curl -fsSL -o '$tmp/$nm_asset' 'https://github.com/kunchenguid/no-mistakes/releases/download/${NO_MISTAKES_VERSION}/$nm_asset'"
  run "mkdir -p '$HOME/.no-mistakes/bin'"
  run "tar -xzf '$tmp/$nm_asset' -C '$tmp'"
  run "install -m 755 '$tmp/no-mistakes' '$HOME/.no-mistakes/bin/no-mistakes'"
  run "rm -rf '$tmp'"
elif [ -x "$HOME/.no-mistakes/bin/no-mistakes" ]; then
  run "'$HOME/.no-mistakes/bin/no-mistakes' update"
fi

# --- uv tools (optional, from captain's machine) ---
if command -v uv >/dev/null 2>&1; then
  for tool in arize-ax-cli browser-use skillspector; do
    if uv tool list 2>/dev/null | grep -q "^$tool "; then
      log "skip uv tool $tool"
    else
      case "$tool" in
        arize-ax-cli) run 'uv tool install arize-ax-cli' ;;
        browser-use) run 'uv tool install browser-use' ;;
        skillspector) run 'uv tool install git+https://github.com/NVIDIA/skillspector.git' ;;
      esac
    fi
  done
fi

# --- Claude Code plugins (names only; auth is interactive) ---
if command -v claude >/dev/null 2>&1; then
  for plugin in caveman@caveman codex@openai-codex typesafe@typesafe-ai; do
    if claude plugin list 2>/dev/null | grep -q "$plugin"; then
      log "skip claude plugin $plugin"
    else
      run "claude plugin install '$plugin'"
    fi
  done
fi

# --- Global skills (from config/skill-sources.txt) ---
if [ -f "$REPO_ROOT/scripts/reinstall-skills.sh" ]; then
  run "'$REPO_ROOT/scripts/reinstall-skills.sh'"
fi

# --- Firstmate workspace ---
if [ ! -d "$FM_HOME/.git" ]; then
  run "git clone 'https://github.com/karanmrn/firstmate.git' '$FM_HOME'"
else
  log "skip firstmate clone ($FM_HOME exists)"
fi

# --- Project clones (canonical paths) ---
mkdir -p "$HOME/Documents/projects"
if [ ! -d "$HOME/Documents/projects/pubmaxx/.git" ]; then
  run "git clone 'https://github.com/Singularityszn/pubmax.git' '$HOME/Documents/projects/pubmaxx'"
fi
if [ ! -d "$FM_HOME/projects/pubmax" ]; then
  run "ln -sf '$HOME/Documents/projects/pubmaxx' '$FM_HOME/projects/pubmax'"
fi
if [ ! -d "$HOME/fleet-deck/.git" ]; then
  run "git clone 'https://github.com/karanmrn/fleet-deck.git' '$HOME/fleet-deck'"
fi

# --- no-mistakes config template ---
if [ ! -f "$HOME/.no-mistakes/config.yaml" ] && [ -f "$REPO_ROOT/config/no-mistakes/config.yaml.example" ]; then
  run "cp '$REPO_ROOT/config/no-mistakes/config.yaml.example' '$HOME/.no-mistakes/config.yaml'"
fi

# --- Deck scripts into FM_HOME (optional copy for quota pane) ---
if [ -d "$FM_HOME" ]; then
  run "mkdir -p '$FM_HOME/data/deck'"
  run "cp '$REPO_ROOT/config/deck/quota.sh' '$FM_HOME/data/deck/quota.sh'"
  run "chmod +x '$FM_HOME/data/deck/quota.sh' '$REPO_ROOT/scripts/build-command-deck.sh'"
fi

log "=== install complete ==="
log "Next: gh auth login, sign into Claude/Codex/Cursor, copy data/keys.env to $FM_HOME/data/ (never git), run scripts/install-runners.sh if needed."
