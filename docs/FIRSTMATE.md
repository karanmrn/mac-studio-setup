# Firstmate and the captain

## Roles

- **Captain** — product owner, merge and deploy authority, quota resets, destructive calls.
- **Firstmate** — orchestrator in Claude Code (Fable 5.1 by default), writes briefs, merges when local bar is green, dispatches workers (Cursor/Codex/Claude/Grok per routing laws).
- **Crewmates** — short-lived workers in Herdr panes (often Cursor), one branch per task.

Fleet home: `~/karan-agent-workspace` (`FM_HOME`). Clone: `github.com/karanmrn/firstmate`.

## Captain laws (summary)

From `data/captain.md` (sanitised):

- **USP**: speed, performance, design, customer onboarding; UI runs taste/unslop skills before ship.
- **Merges and deploys** only on the captain's word; migrations on explicit `apply <n>`; at most one production deploy per day unless overridden.
- **Nothing red**: fix CI/local bar before merge; no loosening performance ceilings in feature PRs.
- **Cursor-first** for implementation when quota allows; routing changes with quota (Grok, Opus, Fable) are documented in captain.md with dates.
- **Zero data churn**: do not delete unlanded work; deep-verify before teardown.
- **No GitHub Actions billing** on pubmax: local merge bar is CI; self-hosted runners when needed.
- **PR bodies**: show-me section (pseudocode, Mermaid, TDD evidence) for ship PRs.
- **Secrets** in `data/keys.env` only, never in chat or git.

## Operational learnings (high signal)

From `data/learnings.md`:

- **Postgres tests on macOS**: SysV shm cap (32 segments) — watch `ipcs -m`; leak causes "PostgreSQL did not start".
- **Treehouse pool**: `projects/pubmax` → `~/Documents/projects/pubmaxx`; pool under `~/.treehouse/pubmaxx-*`; dirty slots block spawn.
- **Command deck**: after herdr restart, rerun `build-command-deck.sh`; quota pane uses `data/deck/quota.sh`.
- **Session limits**: Claude 5-hour window stalls workers — check panes for "session limit" before relaunch spam.
- **Vercel**: production project is **chengdu**; previews can hit production Supabase if misconfigured.
- **no-mistakes**: never restart the shared daemon from a worker; firstmate owns daemon lifecycle.
- **Merge API**: if GraphQL merge fails on permissions, REST squash merge via `gh api` (documented 13 Sep).

## Session start

1. Open WezTerm (herdr attaches via dotfiles `default_prog`).
2. `cd ~/karan-agent-workspace` — firstmate session + command deck.
3. `bin/fm-sessionstart-run.sh` / SessionStart hooks refresh digest and network checks.
4. Captain talks to **firstmate**, not individual workers, except for explicit steering.

## This repo in the fleet

`mac-studio-setup` is a crewmate-delivered bootstrap (install scripts, Brewfile, migration docs). It does not replace the firstmate repo; it reproduces the MacBook environment on the studio.
