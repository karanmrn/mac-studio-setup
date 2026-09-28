# Kunchen Guid stack (credit and install map)

The captain's fleet borrows heavily from [Kunchen Guid](https://github.com/kunchenguid)'s tooling and dotfiles patterns. This doc maps **what we use**, **how it is installed here**, and **where to read upstream**.

Upstream references:

- [dotfiles](https://github.com/kunchenguid/dotfiles) — nix-darwin + home-manager; shared `AGENTS.md` symlinks; [walkthrough video](https://youtu.be/5N-okeDdIuI)
- [dotfiles-mac-nix](https://github.com/kunchenguid/dotfiles-mac-nix) — Apple Silicon nix flake variant
- [homebrew-tap](https://github.com/kunchenguid/homebrew-tap) — e.g. `pi-launcher` cask

Captain's Mac today: **Homebrew-first** dotfiles clone (`DOTFILES_REPO` in `install.sh`), not a full nix switch. Optional nix path below.

## Tools from Kunchen Guid

| Tool | Purpose | Install on this fleet |
|------|---------|------------------------|
| **firstmate** | Fleet orchestrator (briefs, spawn, merge bar) | `git clone` → `~/karan-agent-workspace` (`install.sh`) |
| **treehouse** | Isolated git worktrees + pool | Release tarball → `~/.local/bin/treehouse` |
| **no-mistakes** | PR pipeline / axi gates | Release → `~/.no-mistakes/bin`; config from `config/no-mistakes/config.yaml.example` |
| **herdr** | Terminal workspace / panes | `brew install herdr` (Brewfile) |
| **gnhf** | Overnight agent loops (Prime/ACP) | `npm install -g gnhf` + skill pack |
| **tasks-axi** | Task board CLI | npm global |
| **quota-axi** | Quota windows for routing | npm global; deck pane `data/deck/quota.sh` |
| **gh-axi** | GitHub CLI wrapper for fleet | npm global |
| **chrome-devtools-axi** | Browser automation via CDP | npm global |
| **axi** | Shared axi patterns skill | skills.sh `kunchenguid/axi` |
| **lavish** | Lavish axi variant | skills.sh `kunchenguid/lavish-axi` |
| **kun** | Kun skill pack | skills.sh `kunchenguid/kun` |
| **no-mistakes** (skill) | Pipeline playbooks | skills.sh `kunchenguid/no-mistakes` |
| **vision** / **whathappened** | Fleet introspection | skills.sh packs |
| **grok-ship** | Grok shipping helpers | skills.sh pack |
| **backpass** | (when used) backpass integration | npm/skill per project |
| **compact-adviser** | Claude plugin (optional) | `claude plugin install compact-adviser@compact-adviser` |
| **pi-launcher** | Pi GUI launcher | `brew install --cask kunchenguid/tap/pi-launcher` (optional) |

## Ideas adopted from dotfiles

| Upstream idea | Captain implementation |
|---------------|------------------------|
| One `AGENTS.md` symlinked into Codex, Grok, OpenCode | `~/.dotfiles-karan/home/.config/agents/AGENTS.md` + `install.sh` symlinks |
| WezTerm + Herdr default workspace | Dotfiles `wezterm.lua` + firstmate `FM_HOME` |
| `cc` / `co` high-agency aliases | Optional in dotfiles; captain uses controlled spawn scripts instead |
| Pi themes/extensions via home-manager | Pi installed via npm; extensions under `~/.pi/agent/` |
| `rebuild.sh` / flake switch | Captain: `~/.dotfiles-karan/install.sh` (no sudo in mac-studio-setup) |

## Optional nix path (Mac Studio)

For a machine that should match Kunchen's **nix-darwin** workflow:

1. Install Determinate Nix and clone [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles) (or fork).
2. Edit `flake.nix` user/host/cpu; read Homebrew `cleanup = "zap"` warning in README.
3. Run `./bootstrap.sh` once, then `./rebuild.sh` for changes.

Keep **mac-studio-setup** as the fleet-specific layer (firstmate clone, pubmax paths, runners, skill lists) even when nix manages shell and terminals.

## Structure comparison

| Kunchen dotfiles | mac-studio-setup |
|------------------|------------------|
| `home/.config/agents/AGENTS.md` | Copied pattern in dotfiles-karan |
| `home.nix` symlinks | `install.sh` `ln -sf` block |
| `brews` / `casks` in nix | `Brewfile` |
| Tool versions in flake | `docs/AGENTS-AND-TOOLS.md` + `verify.sh` |

Credit: patterns and several CLIs are by Kunchen Guid; fleet-specific law lives in `~/karan-agent-workspace/data/captain.md`.
