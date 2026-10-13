# Herdr and terminal setup

The portable profile uses Herdr 0.9.3, matching the current Studio client.
The isolated laboratory also reported server 0.9.3 and protocol 22 with compatible endpoints.
The installer downloads the official Apple Silicon release and verifies its pinned SHA-256 checksum.
It does not start a service or restart a running session.

## Presentation owners

The observed Herdr config resolves to `~/.dotfiles-karan/home/.config/herdr/config.toml`.
The observed WezTerm config resolves to `~/.dotfiles-karan/home/.config/wezterm/wezterm.lua`.
The portable installer copies reviewed templates instead of running the complete dotfiles installer.
It preserves existing files and symlinks unless you request a backed-up replacement.

| Setting | Portable value |
| --- | --- |
| Herdr prefix | `ctrl+b` |
| Focus left, down, up, right | `prefix+h`, `prefix+j`, `prefix+k`, `prefix+l` |
| Split horizontal, vertical | `prefix+double_quote`, `prefix+percent` |
| New tab, close tab | `prefix+c`, `prefix+ampersand` |
| Workspace picker, goto, copy mode | `prefix+w`, `prefix+g`, `prefix+y` |
| Agent order | Group by workspace with `agent_panel_sort="spaces"` |
| Sidebar rows | State and workspace, harness and role, terminal title |
| WezTerm font | JetBrainsMono Nerd Font, 14 pt, with Hack, JetBrains Mono, and Menlo fallbacks |
| WezTerm theme | `rose-pine-moon` |
| WezTerm opacity and blur | 0.8 and 50 |
| WezTerm leader | `ctrl+a` for terminal-local actions |

The WezTerm template does not set `default_prog`.
Run `herdr` to open the session, then run `fm` inside its pane.
The portable core does not install Ghostty. Its optional observed theme is Rose Pine Moon with Hack Nerd Font at 15 pt.

## Reconnect without copying credentials

1. Open WezTerm on the new machine.
2. Load `~/.config/mac-studio-setup/fleet-env.zsh`.
3. Run `herdr` to attach to the machine's local session.
4. Run `fm` inside a pane with `HERDR_ENV=1`.
5. Use `codex resume` to select a local saved session when recovery requires it.
6. Let Firstmate reconcile its home lock, task state, and current source before resuming dispatch.

Saved Codex sessions remain local to their machine. This installer does not transfer session IDs or authentication stores.
If client and server versions differ, inspect compatibility before using new operations.
A mismatch does not authorize a worker to restart a shared server.

Optional Herdr Codex integration requires operator review through the installed `herdr integration` help.
The installer does not enable integrations or install unknown hooks.
Firstmate's primary hooks and worker notification mechanism have their own tracked owners.
The optional command deck remains a Studio tool. It is not required on a memory-limited Air.

## Check lifecycle in an isolated lab

Use the Firstmate clone's `bin/fm-herdr-lab.sh` for lifecycle experiments.
Changing `HOME`, `XDG_CONFIG_HOME`, or `HERDR_CONFIG_PATH` does not prove socket isolation.
Every laboratory command must carry the generated non-default session through the helper.

1. Generate a name with `fm-herdr-lab.sh name <label>`.
2. Install one EXIT cleanup that calls the helper's teardown before provisioning.
3. Provision through `fm-herdr-lab.sh provision <name>`.
4. Execute probes through `fm-herdr-lab.sh run <name> <arguments>`.
5. Teardown through `fm-herdr-lab.sh teardown <name>`.

The helper records the default session and checks the same state after teardown.
A changed or missing default session is a test failure.
Never replace these calls with a direct server stop, session stop, or session delete.
Ambient `HERDR_SESSION` alone does not establish isolation.
