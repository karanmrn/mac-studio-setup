# Secret and config key names (no values)

Where the fleet expects configuration. **Values never belong in git.**

## `~/karan-agent-workspace/data/keys.env`

Private file (mode `600`). Referenced by deck scripts, scouts, and deploy tooling. Names observed on the captain's machine (add only what you use):

| Variable | Used for |
|----------|-----------|
| `OPENROUTER_API_KEY` | Prime Agent, pi, OpenRouter routes, quota deck balance line |
| `CONTEXT_DEV_API_KEY` | context.dev scrape/MCP |
| `TYPESAFE_API_KEY` | typesafe-ai / jev skill (optional) |
| `CHROME_DEVTOOLS_AXI_BROWSER_URL` | Strawberry remote debugging for gh-axi / dashboard |
| `SSL_CERT_FILE` | Python HTTPS (Keychain-exported bundle for last30days) |
| `LAST30DAYS_PYTHON` | Pin Python for last30days engine |
| `FM_ARM_CONFIRM_TIMEOUT` | Watcher arm timeout (e.g. `60`) |
| `DEVELOPER_DIR` | `/Library/Developer/CommandLineTools` when Xcode license blocks git |

Copy the full file from the old Mac; do not reconstruct from chat.

## Vercel project `chengdu` (team pubmax69)

Production PUBMAXX env vars live in Vercel — not in this repo. Typical names (see `vercel env ls` on a trusted machine):

- Supabase URL and anon/service keys
- Feature flags that must match production for previews (e.g. rehydration flags called out in learnings)
- Analytics (PostHog) keys
- Map and third-party API keys

Deploy recipe: `npm run deploy:preview -- --prod --scope pubmax69` on captain word only.

## GitHub Actions self-hosted runners

Per runner directory `~/actions-runner-pubmax*`:

| Item | Notes |
|------|--------|
| `.runner` | Runner identity (gitignored) |
| `.credentials` | Registration secret (gitignored) |
| `.env` | `RUNNER_NAME`, labels; **no `PW_PORT`** unless intentionally pinned |
| Registration token | Fetched at install time via `gh api .../registration-token` — never stored in repo |

Labels: `self-hosted`, `pubmax-mac`.

## Harness auth files (local only)

| Path | Purpose |
|------|---------|
| `~/.codex/auth.json` | Codex login |
| `~/.local/share/opencode/auth.json` | OpenCode Go / Zen |
| `~/.config/gh/hosts.yml` | `gh` OAuth token |
| `~/.config/secrets/claudex.env` | Optional Anthropic token for `claudex` shell helper (dotfiles) |
| MCP OAuth | Claude `claude mcp` / Codex / Cursor server configs — re-login on new machine |

## `no-mistakes`

Global `~/.no-mistakes/config.yaml` has **no** API keys; agents use harness logins. OpenRouter models need `OPENROUTER_API_KEY` in the environment when using Prime/pi routes.
