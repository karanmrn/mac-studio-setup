#!/usr/bin/env bash
# Reinstall global skills.sh packs recorded on the captain's MacBook.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIST="$REPO_ROOT/config/skill-sources.txt"
if [ ! -f "$LIST" ]; then
  echo "missing $LIST" >&2
  exit 1
fi
while IFS= read -r src; do
  [ -z "$src" ] && continue
  echo "skills add $src"
  npx -y skills add "$src" -g -a "*" -y
done <"$LIST"
