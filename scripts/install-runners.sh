#!/usr/bin/env bash
# Install three self-hosted GitHub Actions runners for Singularityszn/pubmax.
# Requires: gh auth login with repo admin, no sudo. Registration token fetched at install time.
set -euo pipefail

ORG_REPO="${ORG_REPO:-Singularityszn/pubmax}"
RUNNER_USER="${RUNNER_USER:-$(whoami)}"
RUNNER_HOME="${RUNNER_HOME:-$HOME}"
LABELS="${LABELS:-self-hosted,pubmax-mac}"
RUNNER_VERSION="${RUNNER_VERSION:-2.328.0}"

install_one() {
  local name="$1"
  local dir="$RUNNER_HOME/actions-runner-pubmax${2}"
  local svc_suffix="$3"
  echo "=== $name -> $dir ==="
  mkdir -p "$dir"
  cd "$dir"
  if [ ! -f ./config.sh ]; then
    curl -fsSL -o actions-runner.tar.gz \
      "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz"
    tar xzf actions-runner.tar.gz
    rm -f actions-runner.tar.gz
  fi
  token="$(gh api -X POST "repos/${ORG_REPO}/actions/runners/registration-token" --jq .token)"
  ./config.sh --url "https://github.com/${ORG_REPO}" --token "$token" --name "$name" --labels "$LABELS" --unattended --replace
  # Do NOT set PW_PORT in .env — pubmax-playwright-port derives from RUNNER_NAME (or set PW_PORT per runner if you must pin).
  ./svc.sh install
  ./svc.sh start
  echo "launchd label: actions.runner.Singularityszn-pubmax.${name}"
}

install_one "karan-mac-pubmax" "" ""
install_one "karan-mac-pubmax-2" "-2" "-2"
install_one "karan-mac-pubmax-3" "-3" "-3"

cat <<'EOF'

Remove runners from GitHub when decommissioning a machine:
  gh api -X DELETE repos/Singularityszn/pubmax/actions/runners/<runner-id>
List runners:
  gh api repos/Singularityszn/pubmax/actions/runners --jq '.runners[] | {id,name,status}'

Playwright ports: workflows use .github/actions/pubmax-playwright-port — stable hash from RUNNER_NAME into 3100–3990 (step 10). Pin PW_PORT in runner .env only if two names collide.

EOF
