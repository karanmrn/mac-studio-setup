#!/usr/bin/env bash
# Reinstall every global skill pack and gstack; matches docs/SKILLS.md and config/skill-sources.txt.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIST="$REPO_ROOT/config/skill-sources.txt"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx missing; install Node via vp or brew" >&2
  exit 1
fi

if [ ! -f "$LIST" ]; then
  echo "missing $LIST" >&2
  exit 1
fi

echo "=== skills.sh packs from $LIST ==="
while IFS= read -r src; do
  [ -z "$src" ] && continue
  [[ "$src" =~ ^# ]] && continue
  echo "skills add $src"
  npx -y skills add "$src" -g -a "*" -y
done <"$LIST"

echo "=== gstack (git clone + setup) ==="
GSTACK_DIR="${GSTACK_DIR:-$HOME/.agents/skills/gstack}"
tmp="$(mktemp -d)"
git clone --depth 1 https://github.com/garrytan/gstack.git "$tmp/gstack"
rm -rf "$GSTACK_DIR"
mv "$tmp/gstack" "$GSTACK_DIR"
rm -rf "$tmp"
if [ -x "$GSTACK_DIR/setup" ]; then
  (cd "$GSTACK_DIR" && ./setup)
else
  echo "warn: no gstack setup script" >&2
fi

echo "=== Claude Code plugins (user) ==="
if command -v claude >/dev/null 2>&1; then
  for plugin in caveman@caveman codex@openai-codex typesafe@typesafe-ai; do
    if claude plugin list 2>/dev/null | grep -qF "$plugin"; then
      echo "skip plugin $plugin"
    else
      claude plugin install "$plugin" || echo "warn: plugin install $plugin failed"
    fi
  done
  for optional in compact-adviser@compact-adviser compound-engineering@compound-engineering-plugin mattpocock-skills@mattpocock ecc@ecc; do
    echo "optional: claude plugin install $optional"
  done
else
  echo "skip claude plugins (claude not on PATH)"
fi

echo "=== symlink harness skill dirs to ~/.agents/skills (best effort) ==="
AGENTS_SKILLS="$HOME/.agents/skills"
for harness_dir in "$HOME/.claude/skills" "$HOME/.cursor/skills" "$HOME/.codex/skills"; do
  mkdir -p "$harness_dir"
  if [ -d "$AGENTS_SKILLS" ]; then
    for skill in "$AGENTS_SKILLS"/*; do
      [ -d "$skill" ] || continue
      name="$(basename "$skill")"
      ln -sfn "$skill" "$harness_dir/$name" 2>/dev/null || true
    done
  fi
done

echo "=== done ==="
