# Herdr command deck and WezTerm layout

The captain runs **WezTerm** as the primary terminal (rose-pine-moon, JetBrains Mono Nerd Font 14pt, 80% opacity, ctrl+a leader splits). **Ghostty** uses the same theme via `~/.dotfiles-karan` (Hack Nerd Font 15pt). Config is not duplicated here: clone [karan-herdr-shortcut-setup](https://github.com/karanmrn/karan-herdr-shortcut-setup) to `~/.dotfiles-karan` and run `./install.sh` (symlinks `~/.config/wezterm/wezterm.lua`, Ghostty, herdr `config.toml`, starship, `~/.claude/statusline.sh`).

Nix home-manager on the old Mac also exposed WezTerm at `~/dotfiles`; the **plain-dotfiles** repo above is the source of truth on the MacBook being replaced.

## Command deck workspace

Built by `scripts/build-command-deck.sh` (same logic as `~/karan-agent-workspace/state/build-command-deck.sh`):

```bash
cd ~/karan-agent-workspace
./mac-studio-setup/scripts/build-command-deck.sh   # or copy script into state/
```

Creates herdr workspace **◢ COMMAND DECK ◣** with nine panes (3×3). Pane labels from `herdr pane list` (workspace `w6` on the reference machine):

```
┌─────────────────────┬─────────────────────┬─────────────────────┐
│ quota · models      │ fleet board         │ agents              │
│ quota-axi --tui     │ fm-fleet-view.sh    │ herdr agent list    │
├─────────────────────┼─────────────────────┼─────────────────────┤
│ memory · swap       │ disk · worktrees    │ watcher log         │
│ vm_stat, swap       │ df + treehouse      │ tail watch-cycle    │
├─────────────────────┼─────────────────────┼─────────────────────┤
│ open PRs            │ postgres · shm      │ backlog               │
│ gh pr list pubmax   │ ipcs, pgrep postgres│ tasks-axi list        │
└─────────────────────┴─────────────────────┴─────────────────────┘
```

| Pane | What it shows |
|------|----------------|
| **quota · models** | `quota-axi --tui --refresh 1m` — per-harness windows, reset countdown. Compact bar also via `data/deck/quota.sh` → `quota.line` for Claude statusline. |
| **memory · swap** | `vm_stat`, `sysctl vm.swapusage`, `memory_pressure` — fleet sizing on 24GB+ machines. |
| **open PRs** | `gh pr list -R Singularityszn/pubmax` every 60s. |
| **fleet board** | `bin/fm-fleet-view.sh` — lanes, tasks, worker states. |
| **disk · worktrees** | Root disk free; `treehouse status` from `projects/pubmax`. |
| **postgres · shm** | SysV shm segment count (macOS cap 32), ephemeral `pubmax-rls-*` dirs, running `postgres -D` lines. |
| **agents** | `herdr agent list` — status, harness, pane, title. |
| **watcher log** | `tail -f state/.watch-cycle-exits.log` — firstmate watcher cycles. |
| **backlog** | `tasks-axi list` — captain backlog. |

Worker panes (separate workspace, e.g. `w5`) hold Cursor/Codex/Claude crewmates; the deck is read-only telemetry.

## Claude Code statusline

- Script: `config/claude/statusline.sh` (live copy symlinked from dotfiles into `~/.claude/statusline.sh`).
- Shows model, cwd, branch, context %, session cost, cached `quota-axi` summary, optional caveman suffix.
- Quota one-liner file: `~/karan-agent-workspace/data/deck/quota.line` (written by `config/deck/quota.sh`; keep panes ≤53 columns wide).

## WezTerm agent panes

`wezterm cli list` shows multiple tabs: firstmate (Claude), pubmax crewmates (Cursor), and this repo's worktree under `~/.treehouse/mac-studio-setup-*`.
