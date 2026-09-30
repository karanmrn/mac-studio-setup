# Herdr setup (exact replica)

Reference capture from the captain's MacBook on **29 Sep 2026** (brew may show **0.9.3** after later upgrades). Herdr is the terminal workspace manager for firstmate, crewmates, and the read-only command deck. This doc matches the live machine; runtime state (`session.json`, sockets, logs) is never copied into git.

## Install

| Item | Value |
|------|--------|
| Version | `herdr 0.9.3` (`herdr --version`; was 0.9.1 on 29 Sep inventory) |
| Formula | Homebrew **core** tap (not a third-party tap): `brew install herdr` |
| Also in repo | `Brewfile` line `brew "herdr"`; `install.sh` runs `brew bundle` and ensures `~/.config/herdr` from `config/herdr/` when missing |

After install, start or attach to the persistent session:

```bash
herdr          # launch client or attach to running server
herdr status   # client + server versions, socket path
```

Optional login item (Homebrew caveats): `brew services start herdr` if you want the server at login. On the MacBook the server was already running under `~/.config/herdr/herdr.sock`.

Update channel on reference machine: **stable** (`herdr channel set stable`).

Self-update: `herdr update` (also run from `scripts/update-all.sh` via `brew upgrade herdr`).

## Config files

Live layout under `~/.config/herdr/`:

| Path | Purpose |
|------|---------|
| `config.toml` | Keybindings, UI, agent sidebar colours (canonical copy in this repo: `config/herdr/config.toml`) |
| `herdr.sock` | API socket (runtime) |
| `herdr-client.sock` | Client socket (runtime) |
| `session.json` | Workspace/tab/pane persistence (runtime; do not commit) |
| `herdr-server.log`, `herdr-client.log` | Logs (runtime) |
| `.plugins.lock` | Plugin lock (runtime) |

**Dotfiles symlink (preferred on the MacBook):** `~/.config/herdr/config.toml` → `~/.dotfiles-karan/home/.config/herdr/config.toml` after `~/.dotfiles-karan/install.sh` from [karan-herdr-shortcut-setup](https://github.com/karanmrn/karan-herdr-shortcut-setup).

**Repo fallback:** `install.sh` copies files from `config/herdr/` into `~/.config/herdr/` only when the destination does not exist. If a file already exists, install logs a skip (no overwrite). To replace manually: move aside, then copy, or keep the dotfiles symlink.

Reload after editing `config.toml`:

```bash
herdr server reload-config
```

## Keybindings (`config.toml` `[keys]`)

| Action | Binding |
|--------|---------|
| Prefix | `ctrl+b` |
| Focus pane left/down/up/right | `prefix+h` / `j` / `k` / `l` |
| Split horizontal / vertical | `prefix+"` / `prefix+%` |
| New tab / close tab | `prefix+c` / `prefix+&` |
| Workspace picker | `prefix+w` |
| Goto | `prefix+g` |
| Copy mode | `prefix+y` |

Copy mode internal keys (`v`, space, `y`, Enter, `q`, Esc) are Herdr defaults and are not configurable.

## Sidebar and theme (`[ui]`)

- `agent_panel_sort = "spaces"` (group agents by workspace, not priority).
- `[ui.sidebar.agents]` three-row layout with Catppuccin Mocha colours:
  - Row 1: state icon, **workspace** label (rules for `karan-agent-workspace`, `2ndmate-*`, `pubmaxx`), tab name.
  - Row 2: **agent** harness colour (claude, codex, grok, cursor, pi, opencode, muse, hermes) plus `$role` token (firstmate, secondmate, crewmate, scout) from `herdr pane report-metadata --source firstmate --token role=...`.
  - Row 3: `terminal_title_stripped`, dimmed.

Captain call still open: tune sidebar colours further (`herdr-sidebar-colours` in backlog).

## Workspaces, tabs, and panes (read-only layout)

Captured with `herdr workspace list`, `herdr tab list`, `herdr pane list` on 29 Sep 2026 (IDs change after rebuild; labels and structure are what matter).

### Workspace 1: `karan-agent-workspace` (firstmate + workers)

| Tab label | Role | Typical cwd | Harness |
|-----------|------|-------------|---------|
| `cc` | Firstmate | `~/karan-agent-workspace` | Claude (`herdr:claude`) |
| `fm-pubmax-map-ui-sweep` | Crewmate | `~/Documents/projects/pubmaxx` (treehouse worktree) | Cursor |
| `fm-mac-studio-sol6-herdr` | Crewmate | mac-studio-setup treehouse worktree | Cursor |

Worker tabs are spawned by firstmate; pane metadata uses `role=crewmate` or `role=firstmate`.

### Workspace 2: `◢ COMMAND DECK ◣` (telemetry, 3×3)

Nine panes built by `scripts/build-command-deck.sh` (see [docs/panels.md](panels.md)). Labels on the reference machine:

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| quota · models | fleet board | agents |
| memory · swap | disk · worktrees | watcher log |
| open PRs | postgres · shm | backlog |

All panes use `cwd` `~/karan-agent-workspace` and loop the commands in `build-command-deck.sh`.

**Do not** run `build-command-deck.sh` on a machine that already has a deck you care about unless you intend to create another workspace (the script always `herdr workspace create`).

## Agent integrations

Install hooks so Herdr can track harness state (run once per machine after Herdr install):

```bash
herdr integration install claude
herdr integration install codex
herdr integration install cursor
herdr integration install grok
herdr integration install opencode
herdr integration install pi
herdr integration install omp
herdr integration install devin
herdr integration install droid
herdr integration install hermes
```

Check: `herdr integration status`.

Firstmate shell sets `FM_BACKEND=herdr` via `~/.dotfiles-karan/home/firstmate-env.zsh` (sourced from `~/.zprofile`).

## WezTerm and Ghostty

**WezTerm** (primary): `brew install --cask wezterm`. Config symlinked from dotfiles (`~/.config/wezterm/wezterm.lua`):

- Font: JetBrainsMono Nerd Font 14pt (fallbacks Hack Nerd Font, JetBrains Mono, Menlo).
- Colours: `rose-pine-moon`, 80% opacity, blur 50.
- Leader: `ctrl+a` for local WezTerm splits (separate from Herdr's `ctrl+b` prefix inside a Herdr pane).

On the MacBook reference config, `wezterm.lua` does **not** set `default_prog`. Herdr **0.9** spawns and attaches **WezTerm** panes through its server (`terminal_id` on each pane in `herdr pane list`). Day-to-day flow:

1. Ensure `herdr status` shows `server: running`.
2. Run `herdr` to attach, or let firstmate open new tabs/panes via the Herdr API.
3. Use `fm` from dotfiles `.zshrc` for firstmate in the active Herdr session (`HERDR_ENV` avoids nesting).

**Ghostty** (secondary): same theme via `~/.config/ghostty/config` from dotfiles (Hack Nerd Font 15pt).

Fonts (Homebrew casks): `font-jetbrains-mono-nerd-font`, `font-hack-nerd-font`.

## Rebuild the command deck

From firstmate home (after Herdr server is up):

```bash
cd ~/karan-agent-workspace
~/mac-studio-setup/scripts/build-command-deck.sh
```

The script:

1. Creates workspace label `◢ COMMAND DECK ◣` with `cwd` `~/karan-agent-workspace`.
2. Splits a 3×3 grid with `herdr pane split`.
3. Renames each pane and sends startup commands (`quota-axi --tui`, `fm-fleet-view.sh`, `tasks-axi list`, etc.).

Quota one-liner for Claude statusline: `config/deck/quota.sh` copied to `~/karan-agent-workspace/data/deck/quota.sh` by `install.sh`.

## Related docs

- [docs/panels.md](panels.md) — deck diagram and pane commands
- [docs/MIGRATION.md](MIGRATION.md) — cutover checklist
- [docs/INSTALL-INVENTORY.md](INSTALL-INVENTORY.md) — full install list including Herdr and WezTerm
