#!/usr/bin/env bash
# Fetch one authenticated, immutable setup revision. Do not store credentials.
set -euo pipefail
REF=
DRY_RUN=0
ARGS=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --ref) REF=${2:?--ref needs a full commit SHA}; shift 2 ;;
    --dry-run) DRY_RUN=1; ARGS+=(--dry-run); shift ;;
    --upgrade|--replace-config|--with-pipeline) ARGS+=("$1"); shift ;;
    *) echo "Unknown bootstrap option: $1" >&2; exit 2 ;;
  esac
done
[[ "$REF" =~ ^[0-9a-f]{40}$ ]] || { echo 'Pass --ref with a reviewed 40-character commit SHA.' >&2; exit 1; }
[ -n "${HOME:-}" ] && [[ "$HOME" = /* ]] && [ "$HOME" != / ] || exit 1
DEST="$HOME/.local/share/mac-studio-setup/$REF"
if [ "$DRY_RUN" = 1 ]; then
  printf 'DRY_RUN: fetch karanmrn/mac-studio-setup at %s into %s\n' "$REF" "$DEST"
  printf 'DRY_RUN: run install.sh with the supplied options\n'
  exit 0
fi
command -v gh >/dev/null || { echo 'Run brew install gh first.' >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo 'Run gh auth login and gh auth setup-git first.' >&2; exit 1; }
# Refuse linked parents rather than writing into another config owner.
p="$DEST"
while [ "$p" != / ]; do
  [ ! -L "$p" ] || { echo "Refusing linked path: $p" >&2; exit 1; }
  p=$(dirname "$p")
done
if [ ! -e "$DEST" ]; then
  mkdir -p "$(dirname "$DEST")"
  git clone --no-checkout https://github.com/karanmrn/mac-studio-setup.git "$DEST"
  git -C "$DEST" checkout --detach "$REF"
fi
[ "$(git -C "$DEST" remote get-url origin)" = https://github.com/karanmrn/mac-studio-setup.git ] || exit 1
[ "$(git -C "$DEST" rev-parse HEAD)" = "$REF" ] || exit 1
[ -z "$(git -C "$DEST" status --porcelain)" ] || { echo 'Setup cache has local edits. Preserve them before reinstalling.' >&2; exit 1; }
# macOS Bash 3.2 treats an empty array as unset under nounset.
if [ "${#ARGS[@]}" -gt 0 ]; then
  exec bash "$DEST/install.sh" "${ARGS[@]}"
fi
exec bash "$DEST/install.sh"
