#!/usr/bin/env bash
# Test only through the owning Firstmate lab helper. Never use a live session.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
HERDR_LAB_HELPER=${HERDR_LAB_HELPER:?Set the reviewed Firstmate bin/fm-herdr-lab.sh path}
[ -x "$HERDR_LAB_HELPER" ] || exit 1
mkdir -p "$ROOT/.validation"
LAB=$(mktemp -d "$ROOT/.validation/herdr-workflow.XXXXXX")
HERDR_LAB_SESSION=$("$HERDR_LAB_HELPER" name portable-codex-workflow)
cleanup() {
  rc=$?
  trap - EXIT
  if "$HERDR_LAB_HELPER" teardown "$HERDR_LAB_SESSION"; then
    printf 'PASS: helper teardown preserved the default-session tripwire\n'
  else
    rc=1
  fi
  rm -rf "$LAB"
  exit "$rc"
}
# Install the single combined cleanup before provisioning.
trap cleanup EXIT
mkdir -p "$LAB/home" "$LAB/codex"
cat > "$LAB/probe.sh" <<'PROBE'
#!/bin/sh
set -eu
printf 'FIXED_%s\n' HERDR_RESULT
printf 'EXECUTED\n' > "$1"
codex --version > "$2"
codex --model gpt-6.1-sol -c 'model_reasoning_effort="high"' --help > "$3"
printf 'CODEX_CLI_EXECUTED\n' > "$4"
PROBE
"$HERDR_LAB_HELPER" provision "$HERDR_LAB_SESSION"
"$HERDR_LAB_HELPER" viewer start "$HERDR_LAB_SESSION"
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane run --help > "$LAB/run-help"
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" status --json > "$LAB/status.json"
jq -e '.server.running == true and .server.compatible == true' "$LAB/status.json" >/dev/null
created=$("$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" workspace create \
  --cwd "$LAB" --label portable-workflow-proof --no-focus \
  --env "HOME=$LAB/home" --env "ZDOTDIR=$LAB/home" --env "CODEX_HOME=$LAB/codex")
pane=$(printf '%s' "$created" | jq -er '.result.root_pane.pane_id')
# The CLI joins argv into shell text. This old form loses shell quoting.
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane run "$pane" /usr/bin/printf 'BROKEN_%s\n' ARGV_RESULT
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane wait-output "$pane" \
  --match BROKEN_ARGV_RESULTn --timeout 10000 > "$LAB/wrong-output.json"
# The expected newline contract must fail on the reproduced old command.
if "$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane wait-output "$pane" \
  --regex '^BROKEN_ARGV_RESULT$' --timeout 250 > "$LAB/expected-timeout.json" 2>&1; then
  echo 'FAIL: the broken command passed the exact-line assertion' >&2
  exit 1
fi
jq -e '.error.code == "timeout"' "$LAB/expected-timeout.json" >/dev/null
printf 'PASS: the old argv form produces the wrong newline and fails the exact-line check\n'
# Send one shell command string with explicit quoting. Its echo lacks the output marker.
command_text="/bin/sh '$LAB/probe.sh' '$LAB/executed' '$LAB/codex-version' '$LAB/codex-help' '$LAB/codex-executed'"
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane run "$pane" "$command_text"
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane wait-output "$pane" \
  --regex '^FIXED_HERDR_RESULT$' --timeout 10000 > "$LAB/output.json"
jq -e '.result.matched_line == "FIXED_HERDR_RESULT"' "$LAB/output.json" >/dev/null
for ((attempt=0; attempt<50; attempt++)); do
  [ ! -f "$LAB/codex-executed" ] || break
  sleep 0.1
done
[ "$(cat "$LAB/executed")" = EXECUTED ]
[ "$(cat "$LAB/codex-executed")" = CODEX_CLI_EXECUTED ]
grep -q '^codex-cli ' "$LAB/codex-version"
grep -q -- '--model' "$LAB/codex-help"
"$HERDR_LAB_HELPER" run "$HERDR_LAB_SESSION" pane close "$pane" > "$LAB/close.json"
printf 'PASS: exact output, independent execution receipts, Codex CLI flags, and pane close\n'
