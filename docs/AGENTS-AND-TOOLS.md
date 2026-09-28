# Agent CLIs — versions and install paths (MacBook inventory Sep 2026)

| Tool | Version (reference) | Path | Install method |
|------|---------------------|------|----------------|
| Claude Code | 2.1.283 | `/opt/homebrew/bin/claude` | `brew install --cask claude-code@latest` |
| Codex | 0.157.1 | `~/.local/bin/codex` | `npm install -g @openai/codex` |
| cursor-agent | 2026.09.26 | `~/.local/bin/cursor-agent` | `curl -fsSL https://cursor.com/install \| bash` |
| Grok | 1.0.41 | `~/.grok/bin/grok` | `npm install -g @xai-official/grok` (+ `grok update`) |
| OpenCode | 1.18.32 | `~/.opencode/bin/opencode` | `curl -fsSL https://opencode.ai/install \| bash` |
| Pi | 0.87.1 | `~/.local/bin/pi` | `npm install -g @earendil-works/pi-coding-agent` |
| prime-agent | 0.9.5 | `~/.local/bin/prime-agent` | `npm install -g prime-agent` |
| gnhf | 0.1.50 | `~/.local/bin/gnhf` | `npm install -g gnhf` |
| herdr | 0.9.1 | `/opt/homebrew/bin/herdr` | `brew install herdr` |
| treehouse | 3.1.0 | `~/.local/bin/treehouse` | GitHub release `kunchenguid/treehouse` |
| no-mistakes | 1.79.0 | `~/.no-mistakes/bin/no-mistakes` | GitHub release `kunchenguid/no-mistakes` |
| acpx | 0.19.3 | `~/.local/bin/acpx` | `npm install -g acpx` |
| gh-axi | 0.1.35 | `~/.local/bin/gh-axi` | `npm install -g gh-axi` |
| tasks-axi | 0.2.6 | `~/.local/bin/tasks-axi` | `npm install -g tasks-axi` |
| quota-axi | 0.1.55 | `~/.local/bin/quota-axi` | `npm install -g quota-axi` |
| vite-plus (`vp`) | 1.0.0-rc.1 | `~/.local/share/vite-plus/bin/vp` | `curl -fsSL https://vite.plus/install.sh \| bash` |
| gitnexus | 1.6.12 | npm global | `npm install -g gitnexus` |
| agent-browser | 0.38.1 | npm global | `npm install -g agent-browser` |

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

Sources listed in `config/skill-sources.txt` (29 packs on reference Mac).
