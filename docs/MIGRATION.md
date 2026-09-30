# Migration checklist (MacBook → Mac Studio)

Ordered steps for moving day. **Never commit** `data/keys.env`, runner credentials, or MCP OAuth tokens.

## Before shutdown (old Mac)

1. Push or merge any in-flight work; note open PRs (`gh pr list`).
2. Export secrets (encrypted):
   - `~/karan-agent-workspace/data/keys.env` (mode 600)
   - Entire `~/karan-agent-workspace/data/` tree if you rely on checkpoints, deck logs, or captain docs not in git
   - `~/.no-mistakes/` only if you customized beyond `config.yaml` (evidence dirs are disposable)
3. AirDrop or encrypted USB for the above. Do not use git, Slack, or email for secret values.
4. Optional: screenshot `herdr pane list` and `quota-axi` for comparison after cutover.

## New Mac Studio (automated base)

1. Install Xcode Command Line Tools when prompted (`xcode-select --install`).
2. Homebrew + GitHub CLI:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install gh
   gh auth login
   ```
3. Clone this repo and run install:
   ```bash
   gh repo clone karanmrn/mac-studio-setup ~/mac-studio-setup
   ~/mac-studio-setup/install.sh
   ```
   Full package list: [INSTALL-INVENTORY.md](INSTALL-INVENTORY.md). Herdr and command deck: [HERDR.md](HERDR.md). Fleet state handover: [sol6.md](../sol6.md).
4. Copy `keys.env` into `~/karan-agent-workspace/data/keys.env` and `chmod 600`.
5. Source keys in shell when needed: `set -a; source ~/karan-agent-workspace/data/keys.env; set +a` (add a guarded line to your private zshrc if desired — not in this repo).

## Sign-ins (interactive)

| Service | Purpose |
|---------|---------|
| GitHub (`gh auth login`) | PRs, runners, fleet |
| Claude Code (`claude`) | Firstmate, workers |
| Codex (`codex` + Codex app) | Ship workers, app at ~12:30 BST cutover |
| Cursor | Crewmates, Bugbot |
| Grok | Overflow harness |
| Vercel (team pubmax69, project **chengdu**) | Production deploys |
| Supabase | DB, MCP |
| PostHog | Analytics MCP |
| ElevenLabs | Voice MCP |
| Google (Gmail/Calendar/Drive MCPs) | Integrations |

Re-authenticate Claude MCP servers that show “Needs authentication” after `claude mcp list` (Stripe, HDA, etc.).

## Firstmate and projects

```bash
# install.sh already clones firstmate; refresh:
cd ~/karan-agent-workspace && git pull

# Canonical pubmax clone + symlink
git clone https://github.com/Singularityszn/pubmax.git ~/Documents/projects/pubmaxx
ln -sf ~/Documents/projects/pubmaxx ~/karan-agent-workspace/projects/pubmax

git clone https://github.com/karanmrn/fleet-deck.git ~/fleet-deck
```

Run `no-mistakes init` inside each repo you pipeline (pubmax, fleet-deck, mac-studio-setup). Agent order on the MacBook: `cursor`, `codex`, `claude` (see `config/no-mistakes/config.yaml.example`).

Rebuild command deck: `scripts/build-command-deck.sh` from `~/karan-agent-workspace` (see [HERDR.md](HERDR.md)).

## Self-hosted runners (optional on studio)

```bash
~/mac-studio-setup/scripts/install-runners.sh
```

Do **not** set `PW_PORT` in runner `.env` unless pinning a collision; see `docs/SECRETS.md` and pubmax `pubmax-playwright-port` action.

## Verify

```bash
~/mac-studio-setup/verify.sh
```

## Known issues after Migration Assistant

### Dangling nix symlinks (`mkdir: .../wezterm: No such file or directory`)

On the MacBook, some paths under `~/.config` (and elsewhere) were **nix home-manager symlinks** into `/nix/store/...`. Migration Assistant copies the symlink nodes; the Studio has no nix store, so targets are missing. Dotfiles `install.sh` runs `mkdir -p` on parents like `~/.config/wezterm` and can fail when a parent is a broken symlink.

**Automatic fix:** `install.sh` in this repo runs `quarantine_dangling_symlinks` before `~/.dotfiles-karan/install.sh`, moving each broken symlink to `<path>.dangling-<timestamp>` (never deletes real files).

**Manual fix** (if install already failed):

```bash
# Example: remove or rename a broken wezterm config path, then re-run install
ls -la ~/.config/wezterm
mv ~/.config/wezterm ~/.config/wezterm.dangling-$(date +%Y%m%d-%H%M%S)  # if it is a dead symlink
~/mac-studio-setup/install.sh
```

Repeat for any other dead symlinks under `~/.config`, `~/.local/bin`, `~/.claude`, `~/.codex`, `~/.grok`, or `~/.cursor` (max depth 3).

**Dotfiles repo:** the same guard belongs in `link()` in [karan-herdr-shortcut-setup](https://github.com/karanmrn/karan-herdr-shortcut-setup) (`~/.dotfiles-karan/install.sh`) so `mkdir -p` never runs through a dangling parent. Track that change in the dotfiles repo separately.

### Homebrew `PATH` on a fresh Studio login shell

After installing Homebrew, ensure `~/.zprofile` loads the brew environment (Apple Silicon default):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

Dotfiles also append the firstmate hook to `~/.zprofile` on first `~/.dotfiles-karan/install.sh`. Open a new terminal or `source ~/.zprofile` before `brew`, `gh`, or `herdr`.

## Returning the MacBook

1. Deregister GitHub runners: `gh api repos/Singularityszn/pubmax/actions/runners` then DELETE each `karan-mac-pubmax*`.
2. Revoke or rotate tokens created on that machine (GitHub PATs, Vercel, Supabase, OpenRouter, context.dev, etc.).
3. Sign out of Claude, Codex, Cursor, Grok on the laptop.
4. Erase Mac: System Settings → General → Transfer or Reset → Erase All Content and Settings (after backup).
