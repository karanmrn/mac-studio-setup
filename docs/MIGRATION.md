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

Rebuild command deck: `scripts/build-command-deck.sh` from `~/karan-agent-workspace`.

## Self-hosted runners (optional on studio)

```bash
~/mac-studio-setup/scripts/install-runners.sh
```

Do **not** set `PW_PORT` in runner `.env` unless pinning a collision; see `docs/SECRETS.md` and pubmax `pubmax-playwright-port` action.

## Verify

```bash
~/mac-studio-setup/verify.sh
```

## Returning the MacBook

1. Deregister GitHub runners: `gh api repos/Singularityszn/pubmax/actions/runners` then DELETE each `karan-mac-pubmax*`.
2. Revoke or rotate tokens created on that machine (GitHub PATs, Vercel, Supabase, OpenRouter, context.dev, etc.).
3. Sign out of Claude, Codex, Cursor, Grok on the laptop.
4. Erase Mac: System Settings → General → Transfer or Reset → Erase All Content and Settings (after backup).
