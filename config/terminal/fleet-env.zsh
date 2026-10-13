# shellcheck shell=bash
# Source this file from an operator-owned shell. No hooks or services start here.
export PATH="$HOME/.local/bin:/opt/homebrew/opt/node@22/bin:/opt/homebrew/opt/python@3.13/libexec/bin:/opt/homebrew/bin:$PATH"
export FM_HOME="${FM_HOME:-$HOME/karan-agent-workspace}"
export FM_BACKEND="${FM_BACKEND:-herdr}"
# Run this function inside a Herdr pane after repository and hook review.
fm() {
  if [ "${HERDR_ENV:-}" != 1 ]; then
    printf '%s\n' 'Open Herdr first, then run fm inside its pane.' >&2
    return 1
  fi
  cd "$FM_HOME" || return
  codex --model gpt-6.1-sol -c 'model_reasoning_effort="high"' "$@"
}
