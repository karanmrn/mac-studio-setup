# Subscriptions and quotas (names only)

What the fleet pays for or routes through, and why. **No API keys, card numbers, or token values.** Refresh numbers with `quota-axi` and `quota-axi --full`.

Snapshot **28 Sep 2026** (from `quota-axi` on reference Mac):

| Provider | Scope | Remaining (approx) | Resets / notes |
|----------|--------|-------------------|----------------|
| Claude | all_models | 91% | Weekly/seven-day window → 4 Oct 2026 |
| Claude | fable | 91% | Same window; firstmate default |
| Codex | all_models | 96% | Weekly → 4 Oct 2026 |
| Cursor | all_models | 0% (exhausted) | API usage → 16 Oct 2026 |
| Cursor | grok_bot | 98% | Separate pool |
| Grok | all_products | 100% | Credits window → 1 Oct 2026 |
| OpenRouter | — | $0 / key capped | Attention: key-limit; crew uses free stealth models when capped |
| OpenCode Go | — | auth issues | `opencode-go` attention in quota-axi |

## By service

### Anthropic — Claude / Claude Code

- **Plan:** Max (captain subscription).
- **Use:** Firstmate orchestration (Fable 5.1); occasionally workers when routing law allows.
- **Limits:** 5-hour session window + weekly budget; captain holds limit resets (1/week)—firstmate does not spend without word.

### OpenAI — ChatGPT / Codex

- **Plan:** ChatGPT Plus / Codex entitlement.
- **Use:** Ship workers, no-mistakes pipeline agents when configured for Codex; Codex desktop app as captain front end.
- **Limits:** Weekly Codex quota per `quota-axi`.

### Cursor

- **Plan:** Cursor Pro (team/personal).
- **Use:** Primary **crewmate** harness (Composer 2.5); Bugbot/reviews when enabled.
- **Limits:** General pool exhausted 28 Sep; **grok_bot** pool still available; reset dates in quota output.

### xAI — Grok

- **Plan:** Grok Build / API credits.
- **Use:** Workers when captain routes to Grok 4.6 high; failover to Cursor when low.
- **Limits:** Weekly credits; `grok update` for CLI.

### ElevenLabs

- **Plan:** ~**$22/mo** (captain).
- **Use:** Voice MCP / TTS in Claude; skills under `elevenlabs/skills`.

### Vercel

- **Team:** `pubmax69`.
- **Production project:** **chengdu** (not `pubmaxx`).
- **Use:** PUBMAXX previews and production deploys (captain word, once/day default).

### Supabase

- **Use:** Postgres, auth, storage for pubmax; MCP in Claude.
- **Limits:** Plan per captain account; migrations captain-applied only.

### PostHog

- **Use:** Product analytics, flags, session replay; large skills pack for ops playbooks.

### OpenRouter

- **Use:** Prime Agent, GNHF, cheap/free models (`stealth/union-alpha`, etc.).
- **Status:** Capped 28 Sep; Nebius/Modal planned fallback (captain 15 Sep).

### Tavily

- **Use:** Dev search key in `keys.env` for enrichment scouts (drink prices, research).
- **Limits:** Dev tier; not production user traffic.

### Nebius Token Factory

- **Use:** Hosted GLM / Kimi / DeepSeek via Prime `nebius/*` models when OpenRouter exhausted.
- **Credits:** Captain account; configured in Prime, key name in `keys.env`.

### Google Cloud

- **Use:** ~**$300 trial credit** (captain); APIs as needed (not primary inference path).

### GitHub

- **Org:** Singularityszn (pubmax), karanmrn (firstmate, mac-studio-setup).
- **Actions:** **Not paid** — billing failed; **self-hosted runners** on Mac (`install-runners.sh`) when CI needed; merge bar is local.

### Arize

- **Use:** LLM tracing / observability experiments on pubmax lanes.

### TypeSafe / Jev

- **Use:** Semantic review adviser (`jev` skill, typesafe plugin); `TYPESAFE_API_KEY` in env/Keychain/Vercel sensitive.
- **Plan:** Per TypeSafe account (metered).

### Context.dev

- **Use:** Scrape/extract MCP; metered credits; captain rotates accounts when exhausted.

### Keenable.ai

- **Use:** Fallback web search API when context.dev credits out (captain supplies key on request).

### Devin / Muse / others

- Listed in `quota-axi --full` when configured; often "no measurable quota".

### Apple / Google Play

- **Use:** Capacitor store submission (captain creates developer accounts; weekend target Sep 2026).

### Blacksmith (historical)

- **Free tier:** 3,000 2-vCPU minutes/month; tried 14 Sep 2026 then abandoned—no card on file.

## Routing policy

1. Run `quota-axi` before large spawn waves.
2. Reserve **Claude/Fable** for firstmate unless captain law says otherwise.
3. Prefer **Cursor** when Claude exhausted; **Grok** when captain routes; **free OpenRouter** models for overnight bursts when authorised.
4. Ping captain when a **metered** account is empty (context.dev, OpenRouter cap, etc.)—captain holds multiple accounts.
