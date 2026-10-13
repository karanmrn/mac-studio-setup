#!/usr/bin/env bash
# Exercise the public installer without host packages, credentials, or services.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
LAB=$(mktemp -d "$ROOT/.validation/installer.XXXXXX")
trap 'rm -rf "$LAB"' EXIT
mkdir -p "$LAB/home" "$LAB/tmp"
HOME="$LAB/home" FM_HOME="$LAB/home/karan-agent-workspace" TMPDIR="$LAB/tmp" INSTALL_DRY_RUN=1 bash "$ROOT/install.sh" --dry-run > "$LAB/plan"
if find "$LAB/home" -mindepth 1 | read -r _; then
  echo 'FAIL: dry-run changed HOME' >&2
  exit 1
fi
grep -q 'gpt-6.1-sol' "$LAB/plan"
echo 'PASS: dry-run keeps HOME empty and selects Codex'
