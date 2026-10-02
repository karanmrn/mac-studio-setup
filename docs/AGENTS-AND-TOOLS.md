# Agent CLIs — versions and install paths (MacBook inventory Sep 2026)

Reference versions after `scripts/update-all.sh` on **29 Sep 2026** (`data/deck/update-all.log`). Full install commands: [INSTALL-INVENTORY.md](INSTALL-INVENTORY.md).

| Tool | Version (reference) | Path | Install method |
|------|---------------------|------|----------------|
| Homebrew | 7.0.7 | `/opt/homebrew/bin/brew` | brew installer |
| GitHub CLI | 2.102.0 | `/opt/homebrew/bin/gh` | `brew install gh` |
| Claude Code | 2.1.287 | `/opt/homebrew/bin/claude` | `brew install --cask claude-code@latest` |
| Codex | 0.160.0 | `~/.local/bin/codex` | `npm install -g @openai/codex` |
| cursor-agent | 2026.10.01 | `~/.local/bin/cursor-agent` | `curl -fsSL https://cursor.com/install \| bash` |
| Grok | 1.0.44 | `~/.grok/bin/grok` | `npm install -g @xai-official/grok` (+ `grok update`) |
| OpenCode | 1.18.34 | `~/.opencode/bin/opencode` | `curl -fsSL https://opencode.ai/install \| bash` |
| Pi | 1.0.0 | `~/.local/bin/pi` | `npm install -g @earendil-works/pi-coding-agent` |
| prime-agent | 0.9.7 | `~/.local/bin/prime-agent` | `npm install -g prime-agent` |
| gnhf | 0.1.50 | `~/.local/bin/gnhf` | `npm install -g gnhf` |
| herdr | 0.9.3 | `/opt/homebrew/bin/herdr` | `brew install herdr` |
| treehouse | 3.1.0 | `~/.local/bin/treehouse` | GitHub release `kunchenguid/treehouse` v3.1.0 |
| no-mistakes | 1.84.0 | `~/.no-mistakes/bin/no-mistakes` | GitHub release `kunchenguid/no-mistakes` v1.84.0 |
| acpx | 0.19.4 | `~/.local/bin/acpx` | `npm install -g acpx` |
| gh-axi | 0.1.35 | `~/.local/bin/gh-axi` | `npm install -g gh-axi` |
| chrome-devtools-axi | 0.1.35 | `~/.local/bin/chrome-devtools-axi` | `npm install -g chrome-devtools-axi` |
| lavish-axi | 0.1.79 | `~/.local/bin/lavish-axi` | `npm install -g lavish-axi` |
| tasks-axi | 0.2.6 | `~/.local/bin/tasks-axi` | `npm install -g tasks-axi` |
| quota-axi | 0.1.55 | `~/.local/bin/quota-axi` | `npm install -g quota-axi` |
| vite-plus (`vp`) | 1.0.0 | `~/.local/share/vite-plus/bin/vp` | `curl -fsSL https://vite.plus/install.sh \| bash` |
| gitnexus | 1.6.12 | npm global | `npm install -g gitnexus` |
| agent-browser | 0.38.1 | npm global | `npm install -g agent-browser` |
| skills CLI | 1.7.0 | npm global | `npm install -g skills` |
| Node (vp) | v26.8.1 | via vp | `vp upgrade` |
| pnpm (vp) | 12.6.0 | via vp | bundled |
| Bun (vp) | 1.4.2 | `~/.local/share/vite-plus/bin/bun` | bundled |

**npm global root**: `~/.local/lib/node_modules` (prefix `~/.local`).

**uv tools**: `arize-ax-cli`, `browser-use`, `skillspector` via `uv tool install ...`.

## Claude Code plugins

```bash
claude plugin install caveman@caveman
claude plugin install codex@openai-codex
claude plugin install typesafe@typesafe-ai
# Optional: compound-engineering, mattpocock-skills, ecc — enable in settings when needed
```

## MCP servers (re-add after login; no tokens in repo)

Claude (`claude mcp list`): PostHog, Supabase, Vercel, Linear, Notion, Slack, ElevenLabs, Google (Gmail/Calendar/Drive), Spotify, context.dev, AccuWeather, Floot, Wispr, Claude Docs; Stripe and HDA may need re-auth.

Re-enable hosted connectors through Claude Code settings or vendor `claude mcp add` flows after machine migration.

## Codex and Cursor

- **Codex**: config under `~/.codex/`; `AGENTS.md` symlinked from dotfiles. Auth in `auth.json` (local).
- **Cursor**: rules in `~/.cursor/rules/`; skills under `~/.cursor/skills` and `~/.agents/skills` (synced via `npx skills`).

## Skills reinstall

```bash
~/mac-studio-setup/scripts/reinstall-skills.sh
# or per pack:
npx -y skills add owner/repo -g -a "*" -y
```

Sources listed in `config/skill-sources.txt` (30 packs on reference Mac).

## Herdr and terminals

See [HERDR.md](HERDR.md) and [panels.md](panels.md).
