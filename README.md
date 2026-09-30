# Mac Studio Setup

Reproducible bootstrap for the captain's Apple Silicon dev machine: Homebrew, terminals (WezTerm + Ghostty via dotfiles), agent CLIs, Firstmate fleet layout, Herdr command deck, skills catalog, and pubmax self-hosted runners.

## Moving day (three commands)

After Homebrew, `gh auth login`, and cloning this repo:

```bash
~/mac-studio-setup/install.sh
# copy keys.env into ~/karan-agent-workspace/data/ (see docs/MIGRATION.md)
~/mac-studio-setup/verify.sh
```

Dry run: `INSTALL_DRY_RUN=1 ~/mac-studio-setup/install.sh`

## Table of contents

| Doc | Contents |
|-----|----------|
| [sol6.md](sol6.md) | Fleet handover: executed work, queue, Studio cutover |
| [docs/MIGRATION.md](docs/MIGRATION.md) | MacBook → Studio checklist, sign-ins, projects |
| [docs/HERDR.md](docs/HERDR.md) | Exact Herdr + WezTerm setup and command deck |
| [docs/INSTALL-INVENTORY.md](docs/INSTALL-INVENTORY.md) | Every package and install command |
| [docs/AGENT-INSTRUCTIONS.md](docs/AGENT-INSTRUCTIONS.md) | Global vs firstmate vs pubmax `AGENTS.md` layering |
| [docs/SKILLS.md](docs/SKILLS.md) | Full skill inventory by upstream (generated from lock file) |
| [docs/KUNCHEN-STACK.md](docs/KUNCHEN-STACK.md) | Kunchen Guid tools, dotfiles credit, optional nix |
| [docs/HOW-WE-WORK.md](docs/HOW-WE-WORK.md) | Captain laws, daily rhythm, Sep 2026 fleet history |
| [docs/ORCHESTRATION.md](docs/ORCHESTRATION.md) | Firstmate brief/spawn/watcher/away mode |
| [docs/SUBSCRIPTIONS.md](docs/SUBSCRIPTIONS.md) | Paid/free services and quota routing |
| [docs/UPDATING.md](docs/UPDATING.md) | Daily `update-all.sh` and defer rules |
| [docs/FIRSTMATE.md](docs/FIRSTMATE.md) | Roles and captain law summary |
| [docs/AGENTS-AND-TOOLS.md](docs/AGENTS-AND-TOOLS.md) | CLI versions and install paths |
| [docs/SECRETS.md](docs/SECRETS.md) | Key **names** only |
| [docs/panels.md](docs/panels.md) | Herdr command deck |

## Quick start (private repo)

**Step 1 — Homebrew and GitHub CLI**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
```

**Step 2 — Authenticate GitHub**

```bash
gh auth login
```

**Step 3 — Clone and install**

```bash
gh repo clone karanmrn/mac-studio-setup ~/mac-studio-setup
~/mac-studio-setup/install.sh
```

**Step 4 — Verify**

```bash
~/mac-studio-setup/verify.sh
```

### Clone without `gh` (HTTPS + token)

```bash
export GITHUB_TOKEN="<github-pat>"   # fine-grained or classic with repo scope; never commit
git clone "https://${GITHUB_TOKEN}@github.com/karanmrn/mac-studio-setup.git" ~/mac-studio-setup
~/mac-studio-setup/install.sh
unset GITHUB_TOKEN
```

## Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Idempotent bootstrap (no sudo) |
| `verify.sh` | Green/red checks |
| `scripts/update-all.sh` | Daily harness + skills update |
| `scripts/reinstall-skills.sh` | Full skills.sh packs + gstack + plugins |
| `scripts/build-command-deck.sh` | Herdr deck panes |
| `scripts/install-runners.sh` | GitHub Actions self-hosted runners |

## GitHub Actions runners

```bash
~/mac-studio-setup/scripts/install-runners.sh
```

## Secret scan before push

```bash
git diff | rg 'sk_|tvly-|ghp_|gho_|xoxb|AKIA|eyJ|-----BEGIN' && echo BAD || echo OK
```

## Config templates

- `config/agents/` — sanitised global `AGENTS.md` and firstmate `CLAUDE.md` pointer
- `config/no-mistakes/config.yaml.example`
- `config/claude/settings.json.example`, `statusline.sh`
- `config/skill-sources.txt` — skills.sh pack list
