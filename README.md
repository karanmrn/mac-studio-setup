# Mac Studio Setup

Reproducible bootstrap for the captain's Apple Silicon dev machine: Homebrew, terminals (WezTerm + Ghostty via dotfiles), agent CLIs, Firstmate fleet layout, Herdr command deck, and pubmax self-hosted runners.

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
export GITHUB_TOKEN=ghp_xxxx   # fine-grained or classic with repo scope; never commit
git clone "https://${GITHUB_TOKEN}@github.com/karanmrn/mac-studio-setup.git" ~/mac-studio-setup
~/mac-studio-setup/install.sh
unset GITHUB_TOKEN
```

### Dry run

```bash
INSTALL_DRY_RUN=1 ~/mac-studio-setup/install.sh
```

## Documentation

- [docs/AGENTS-AND-TOOLS.md](docs/AGENTS-AND-TOOLS.md) — CLI versions and install methods
- [docs/panels.md](docs/panels.md) — Herdr command deck
- [docs/MIGRATION.md](docs/MIGRATION.md) — moving day
- [docs/SECRETS.md](docs/SECRETS.md) — key names only
- [docs/FIRSTMATE.md](docs/FIRSTMATE.md) — captain / firstmate workflow

## GitHub Actions runners

```bash
~/mac-studio-setup/scripts/install-runners.sh
```

## Secret scan before push

```bash
git diff | rg 'sk_|tvly-|ghp_|gho_|xoxb|AKIA|eyJ|-----BEGIN' && echo BAD || echo OK
```
