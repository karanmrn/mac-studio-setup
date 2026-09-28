#!/usr/bin/env bash
set -u
HOME_DIR=$HOME/karan-agent-workspace
newpane() { # split $1 in direction $2 ratio $3 -> prints new pane id
  out=$(herdr pane split --pane "$1" --direction "$2" --ratio "$3" --cwd "$HOME_DIR" --no-focus 2>&1)
  echo "$out" | jq -r '[.. | objects | .pane_id? // empty] | unique | .[]' | grep -v "^$1$" | head -1
}
run() { herdr pane rename "$1" "$2" >/dev/null 2>&1; herdr pane send-text "$1" "source ~/.zprofile; clear; $3" >/dev/null; herdr pane send-keys "$1" Enter >/dev/null; }
ws=$(herdr workspace create --cwd "$HOME_DIR" --label "◢ COMMAND DECK ◣" --no-focus)
W=$(echo "$ws" | jq -r '.result.workspace.workspace_id'); P1=$(echo "$ws" | jq -r '.result.root_pane.pane_id')
echo "workspace $W root $P1"
# three columns
P2=$(newpane "$P1" right 0.34); P3=$(newpane "$P2" right 0.5)
# three rows per column
P4=$(newpane "$P1" down 0.34); P7=$(newpane "$P4" down 0.5)
P5=$(newpane "$P2" down 0.34); P8=$(newpane "$P5" down 0.5)
P6=$(newpane "$P3" down 0.34); P9=$(newpane "$P6" down 0.5)
echo "panes: $P1 $P2 $P3 $P4 $P5 $P6 $P7 $P8 $P9"
run "$P1" "quota · models" 'quota-axi --tui --refresh 1m'
run "$P2" "fleet board" 'while :; do clear; date "+%H:%M:%S  fleet board"; bin/fm-fleet-view.sh 2>&1 | head -40; sleep 20; done'
run "$P3" "agents" 'while :; do clear; date "+%H:%M:%S  agents"; herdr agent list | jq -r ".result.agents[] | \"\(.agent_status)\t\(.agent)\t\(.name // \"-\")\t\(.pane_id)\t\(.terminal_title_stripped // \"\")\"" | column -t -s "	"; sleep 10; done'
run "$P4" "memory · swap" 'while :; do clear; date "+%H:%M:%S  memory"; vm_stat | awk "NR==1{print} /free|active|inactive|wired|compressed/{print}"; sysctl vm.swapusage; echo; memory_pressure -Q 2>/dev/null | tail -2; sleep 15; done'
run "$P5" "disk · worktrees" 'while :; do clear; date "+%H:%M:%S  disk"; df -h / | tail -1 | awk "{print \"root \" \$4 \" free of \" \$2 \" (\" \$5 \" used)\"}"; echo; (cd projects/pubmax && treehouse status 2>&1 | head -12); sleep 60; done'
run "$P6" "watcher log" 'mkdir -p state; touch state/.watch-cycle-exits.log; echo "watcher cycle exits (tail -f)"; tail -n 30 -f state/.watch-cycle-exits.log'
run "$P7" "open PRs" 'while :; do clear; date "+%H:%M:%S  open PRs  Singularityszn/pubmax"; gh pr list -R Singularityszn/pubmax --limit 15 2>&1 | cut -c1-110; sleep 60; done'
run "$P8" "postgres · shm" 'while :; do clear; date "+%H:%M:%S  postgres test clusters"; echo "shm segments: $(ipcs -m | grep -c "^m ")  (32 max)"; echo "pubmax-rls-* dirs: $(find /var/folders -maxdepth 4 -name "pubmax-rls-*" 2>/dev/null | wc -l | tr -d "[:space:]")"; pgrep -fl "postgres -D" | head -6; sleep 30; done'
run "$P9" "backlog" 'while :; do clear; date "+%H:%M:%S  backlog (tasks-axi)"; tasks-axi list 2>&1 | head -30; sleep 60; done'
