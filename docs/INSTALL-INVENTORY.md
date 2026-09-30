# Install inventory (Mac Studio replica)

Everything the captain's MacBook had installed for fleet work as of **29 Sep 2026**, with the exact install command and whether `install.sh` covers it. Versions match `verify.sh` / `data/deck/update-all.log` unless noted.

**Bootstrap order:** Xcode CLT → Homebrew → `gh auth login` → clone this repo → `./install.sh` → copy `keys.env` → `./verify.sh`. See [MIGRATION.md](MIGRATION.md).

## `install.sh` coverage legend

| Symbol | Meaning |
|--------|---------|
| **auto** | Installed or updated by `install.sh` |
| **brew** | Via `Brewfile` / `brew bundle` inside `install.sh` |
| **manual** | Interactive or captain-only; documented here |

---

## Xcode and Apple toolchain

| Item | Version (ref) | Install | `install.sh` |
|------|---------------|---------|--------------|
| Xcode Command Line Tools | Xcode.app developer dir | `xcode-select --install` (GUI) | manual |
| Full Xcode (optional, iOS builds) | App Store | Install Xcode.app | manual |

---

## Homebrew

Install: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` then `eval "$(/opt/homebrew/bin/brew shellenv)"`.

**Version:** Homebrew 6.0.1.

`install.sh` runs `brew bundle install --file=Brewfile` when Brewfile exists.

### Formulae (`Brewfile`)

| Package | Purpose | Install command |
|---------|---------|-----------------|
| azure-cli | Azure CLI | `brew install azure-cli` |
| coreutils | GNU coreutils | `brew install coreutils` |
| gh | GitHub CLI | `brew install gh` |
| herdr | Terminal workspaces | `brew install herdr` |
| osv-scanner | Security scanning (pubmax CI) | `brew install osv-scanner` |
| postgresql@16 | Local Postgres | `brew install postgresql@16` |
| postgrest | PostgREST (if used locally) | `brew install postgrest` |
| rustup | Rust toolchain | `brew install rustup` |
| semgrep | Static analysis | `brew install semgrep` |
| shellcheck | Shell lint | `brew install shellcheck` |
| uv | Python tooling | `brew install uv` |
| zizmor | GitHub Actions lint | `brew install zizmor` |
| zsh-autosuggestions | Zsh plugin | `brew install zsh-autosuggestions` |
| zsh-syntax-highlighting | Zsh plugin | `brew install zsh-syntax-highlighting` |

Tap on reference machine: `owo-network/brew` (listed in Brewfile header comment; add with `brew tap owo-network/brew` if a formula from that tap is needed).

### Casks (`Brewfile`)

| Cask | Purpose | Install command |
|------|---------|-----------------|
| android-commandlinetools | Capacitor/Android builds | `brew install --cask android-commandlinetools` |
| claude-code@latest | Claude Code CLI | `brew install --cask claude-code@latest` |
| font-hack-nerd-font | Ghostty / fallback | `brew install --cask font-hack-nerd-font` |
| font-jetbrains-mono-nerd-font | WezTerm primary | `brew install --cask font-jetbrains-mono-nerd-font` |
| google-chrome | Browser / testing | `brew install --cask google-chrome` |
| opensuperwhisper | Dictation | `brew install --cask opensuperwhisper` |
| wezterm | Primary terminal | `brew install --cask wezterm` |

**Studio-only note:** drop `android-commandlinetools` if you never build Android locally.

### Dotfiles extras (not in repo Brewfile)

Optional packages in `~/.dotfiles-karan/Brewfile` (cmux, graphite, deno, etc.): `brew bundle install --file=~/.dotfiles-karan/Brewfile` after cloning [karan-herdr-shortcut-setup](https://github.com/karanmrn/karan-herdr-shortcut-setup).

`brew bundle dump` may fail under nix-wrapped Homebrew; maintain `Brewfile` from `brew leaves` and `brew list --cask` when refreshing.

---

## Node, pnpm, Bun (Vite+)

| Item | Version (ref) | Install | `install.sh` |
|------|---------------|---------|--------------|
| vite-plus (`vp`) | 1.0.0 | `curl -fsSL https://vite.plus/install.sh \| bash` | auto (`vp upgrade`) |
| Node | v26.8.1 | Bundled with vp | auto |
| pnpm | 12.6.0 | Bundled with vp | auto |
| Bun | 1.4.2 | Bundled with vp (`~/.local/share/vite-plus/bin/bun`) | auto |

npm global prefix: `npm config set prefix ~/.local` (install.sh sets if needed).

---

## npm global packages

Installed with `npm install -g <pkg>`. `install.sh` installs the **fleet core** list; others are manual or from historical experiments.

### Fleet core (`install.sh` loop)

| Package | Version (ref) | Command |
|---------|---------------|---------|
| `@openai/codex` | 0.158.0 | `npm install -g @openai/codex` |
| `@earendil-works/pi-coding-agent` (`pi`) | 0.87.1 | `npm install -g @earendil-works/pi-coding-agent` |
| `@xai-official/grok` | 1.0.41 | `npm install -g @xai-official/grok` |
| acpx | 0.19.3 | `npm install -g acpx` |
| agent-browser | 0.38.1 | `npm install -g agent-browser` |
| chrome-devtools-axi | 0.1.35 | `npm install -g chrome-devtools-axi` |
| gh-axi | 0.1.35 | `npm install -g gh-axi` |
| gitnexus | 1.6.12 | `npm install -g gitnexus` |
| gnhf | 0.1.50 | `npm install -g gnhf` |
| lavish-axi | 0.1.79 | `npm install -g lavish-axi` |
| prime-agent | 0.9.7 | `npm install -g prime-agent` |
| quota-axi | 0.1.55 | `npm install -g quota-axi` |
| skills | 1.7.0 | `npm install -g skills` |
| tasks-axi | 0.2.6 | `npm install -g tasks-axi` |

`scripts/update-all.sh` runs `npm update -g` for all globals.

### Other globals on the MacBook (manual if needed)

Examples from `npm ls -g --depth=0` not in `install.sh`: `@aqualia/alph-cli`, `@dbx-app/cli`, `backpass`, `carbonyl`, `cline`, `openwiki`, `pi-web-access`, etc. Install only if you still use them.

---

## Curl / GitHub release binaries

| Tool | Version (ref) | Path | Install | `install.sh` |
|------|---------------|------|---------|--------------|
| cursor-agent | 2026.09.28 | `~/.local/bin/cursor-agent` | `curl -fsSL https://cursor.com/install \| bash` | auto |
| OpenCode | 1.18.33 | `~/.opencode/bin/opencode` | `curl -fsSL https://opencode.ai/install \| bash` | auto |
| treehouse | 3.1.0 | `~/.local/bin/treehouse` | Release tarball `kunchenguid/treehouse` `TREEHOUSE_VERSION=v3.1.0` | auto |
| no-mistakes | 1.84.0 | `~/.no-mistakes/bin/no-mistakes` | Release tarball `kunchenguid/no-mistakes` `NO_MISTAKES_VERSION=v1.84.0` | auto |

Grok binary path after npm install: `~/.grok/bin/grok` (`grok update` in install.sh when present).

---

## Python `uv` tools

When `uv` is on PATH (`brew install uv`):

| Tool | Install | `install.sh` |
|------|---------|--------------|
| arize-ax-cli | `uv tool install arize-ax-cli` | auto if uv present |
| browser-use | `uv tool install browser-use` | auto if uv present |
| skillspector | `uv tool install git+https://github.com/NVIDIA/skillspector.git` | auto if uv present |

---

## Dotfiles and shell

| Item | Install | `install.sh` |
|------|---------|--------------|
| karan-herdr-shortcut-setup | `git clone https://github.com/karanmrn/karan-herdr-shortcut-setup.git ~/.dotfiles-karan && ~/.dotfiles-karan/install.sh` | auto |
| WezTerm, Ghostty, Herdr keys, starship, statusline | Symlinks from dotfiles `install.sh` | auto |
| Global `AGENTS.md` symlinks | install.sh + dotfiles | auto |
| Herdr `config.toml` fallback | `config/herdr/config.toml` copied if missing | auto |

---

## Herdr

See [HERDR.md](HERDR.md). Summary:

```bash
brew install herdr
herdr integration install claude codex cursor grok opencode pi   # plus others as needed
cd ~/karan-agent-workspace && ~/mac-studio-setup/scripts/build-command-deck.sh
```

---

## Claude Code plugins

```bash
claude plugin install caveman@caveman
claude plugin install codex@openai-codex
claude plugin install typesafe@typesafe-ai
```

`install.sh` installs these when `claude` is on PATH. Optional: compound-engineering, mattpocock-skills, ecc (enable in settings).

### MCP servers (names only; re-auth on new machine)

From `claude mcp list` (29 Sep): Claude Docs, Wispr Flow, AccuWeather, Slack, Floot, ElevenLabs, Supabase, Vercel, Linear, Notion, Spotify, Gmail, Google Calendar, Google Drive, posthog; Stripe and HDA may need authentication.

No tokens in this repo. Reconnect via Claude Code UI or vendor `claude mcp add` flows.

---

## Skills catalogue

Sources: `config/skill-sources.txt` (30 packs). Reinstall:

```bash
~/mac-studio-setup/scripts/reinstall-skills.sh
```

Uses `npx skills add owner/repo -g` per line. `install.sh` calls `reinstall-skills.sh`.

---

## Git clones (fleet layout)

| Repo | Path | `install.sh` |
|------|------|--------------|
| firstmate | `~/karan-agent-workspace` | auto clone |
| pubmax | `~/Documents/projects/pubmaxx` + symlink `~/karan-agent-workspace/projects/pubmax` | auto |
| fleet-deck | `~/fleet-deck` | auto |
| mac-studio-setup | captain clones to `~/mac-studio-setup` | manual clone step |

---

## no-mistakes config

Template: `config/no-mistakes/config.yaml.example` → `~/.no-mistakes/config.yaml` on first install.

---

## Self-hosted GitHub Actions runners

```bash
~/mac-studio-setup/scripts/install-runners.sh
```

**manual** on migration day (tokens, labels `karan-mac-pubmax*`); deregister old MacBook runners in GitHub UI.

---

## Secrets and keys

`~/karan-agent-workspace/data/keys.env` (mode 600). **manual** copy from old Mac. Key names only in [SECRETS.md](SECRETS.md).

---

## Daily updates

```bash
~/mac-studio-setup/scripts/update-all.sh
```

See [UPDATING.md](UPDATING.md).

---

## Verify

```bash
~/mac-studio-setup/verify.sh
```

Checks CLIs, fonts, dotfiles links, firstmate clone, optional runners, `keys.env` presence.

---

## Known issues after Migration Assistant

See [MIGRATION.md](MIGRATION.md#known-issues-after-migration-assistant) for the full narrative. Short form:

| Symptom | Cause | Fix |
|---------|-------|-----|
| `mkdir: .../.config/wezterm: No such file or directory` during `~/.dotfiles-karan/install.sh` | Copied nix symlinks with missing `/nix/store` targets | Re-run `~/mac-studio-setup/install.sh` (quarantines dangling symlinks first) or manually `mv` dead symlinks aside |
| `brew` / `gh` / `herdr` not found in a new shell | Homebrew not on `PATH` | Add `eval "$(/opt/homebrew/bin/brew shellenv)"` to `~/.zprofile` and re-login or `source ~/.zprofile` |

`install.sh` **auto** step: `quarantine_dangling_symlinks` before dotfiles install.
