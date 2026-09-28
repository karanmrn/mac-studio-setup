# How we work (~20 days, Sep 2026)

Readable summary of the captain + firstmate fleet from **3 Sep** (new Mac) through **28 Sep** (mac-studio-setup v2). Sources: `~/karan-agent-workspace/data/captain.md`, `data/learnings.md`, checkpoints, scout reports, and pubmax/firstmate git history. Sanitised: no secret values.

## North star

Build **PUBMAXX** (web + Capacitor mobile) fast, with agent-first delivery: captain sets goals, **firstmate** orchestrates, **crewmates** ship in isolated worktrees. Humans go out; agents handle the repo. USP: **speed, performance, design, onboarding**, with **taste** and **unslop** on UI.

## Daily rhythm

| Who | Does what |
|-----|-----------|
| **Captain** | Goals, merge/deploy/migration words, quota top-ups, destructive calls |
| **Firstmate** | Reads fleet state, writes briefs, spawns workers, runs local CI bar, merges when green (yolo posture on pubmax) |
| **Crewmates** | One branch per task; report via `state/<task>.status`; never talk to captain |
| **no-mistakes** | Validates pipeline PRs when mode requires it; shared daemon (workers never restart it) |

**Deploy:** at most **one production Vercel deploy per day**, captain's word only. **Migrations:** `apply <n>` only, never bundled with merge.

**CI:** GitHub Actions billing is off for pubmax; **local bar** (ESLint, typecheck, full unit suite, diff-check, data validation, Postgres proof for migrations) **is** CI. Self-hosted runners optional on the studio.

## Captain laws (stable)

- Nothing red: fix tests, lint, flakes, and perf regressions at source; ceilings only ratchet **down**.
- PR bodies for ship work: **show-me** (pseudocode, Mermaid, TDD table).
- No agent co-authors on commits; no secrets in git (use `data/keys.env`, mode 600).
- Never tear down unlanded work; scouts are scratch only after report + decisions closed.
- UI PRs: design skills + screenshots at 390 / 768 / 1440.
- Price colours: red/yellow/green = **price band**, not trust state.

## Harness routing (it changed often)

Quota drove routing more than preference:

| Period | Workers | Orchestrator |
|--------|---------|--------------|
| 3–5 Sep | Codex Luna max, then Claude Opus/Fable | Fable 5.1 firstmate |
| 7–10 Sep | Opus 5, then Grok 4.6 high waves | Fable plans; Grok/Cursor execute |
| 11 Sep | Grok everything (quota wall) | Opus orchestration |
| 13 Sep | Claude Opus workers; Fable plans | Routing law refresh |
| 14–16 Sep | Prime + OpenRouter (GLM, union-alpha free), GNHF overnight | Codex handover evening 16 Sep |
| 17 Sep | Cursor composer-2.5 xhigh; away mode silent until all tasks done | Claude firstmate only |
| 21 Sep | Grok 4.6 high; auto-failover to Cursor | No Claude on crew |
| 20–28 Sep | Jev on every subagent diff; Cursor/Grok per `crew-dispatch.json` | Fable + quota-axi |

**Rule of thumb today:** read `quota-axi` and `config/crew-dispatch.json` before spawn; never burn Fable/Claude on crew when captain reserved it for firstmate.

## Infrastructure themes

- **Treehouse** pool on `~/Documents/projects/pubmaxx` (`projects/pubmax` symlink in FM_HOME).
- **Herdr** command deck: quota pane, context pane, worker panes; rebuild with `scripts/build-command-deck.sh`.
- **Blacksmith** tried 14 Sep then dropped (3k free minutes exhausted); CI stayed local.
- **Skills audit** 14 Sep: global cap ~300; pruned bloat; kept ponytail, gstack, taste, impeccable, PostHog STE, Jev.
- **GateGuard / ECC** toggled for pipeline agents; timeouts raised in no-mistakes config.
- **Mac Studio setup** repo: reproducible bootstrap for moving off the MacBook.

## Away mode and overnight

- Captain **AFK**: finish in-flight lanes, merge on green, **no deploy** unless already worded; morning checkpoint in `data/checkpoints/`.
- **GNHF** loops for long autonomous slices (design-review nights, dependency sweeps); watch for context overflow on flash models.
- **Watcher** escalates stale panes; workers declare `paused:` for known waits so firstmate does not spam.

## Scout and review waves (examples)

Reports under `data/*/report.md` include: **astra-review**, **astra-plan**, **harness-inventory-13sep**, **fleet-deck-ideation**, **performance-review**, **pentest-authenticated**, **pubmax-deploy-gate**, **merge-gate-13sep**. These informed perf A/B instrument, invite/drink waves, and merge policy—not repeated here; citations live in PR bodies.

## Pubmax shipping arc (since 8 Sep, titles only)

Major themes from merged PRs: **Vitest 5** integration, **plan-astra** merge, dependency integration trains, **perf budget** instrument (captain chose build A/B over merging past red), **Blacksmith** runner experiment then revert, **RLS/migration** lanes, **mobile/Capacitor** store readiness, **soft drinks / Lucia** feature, **desktop design** polish, **Tavily** enrichment scouts, **Dependabot** batches, **Arize** tracing, **browser journeys**. Exact numbers: `gh pr list --state merged` on `Singularityszn/pubmax`.

## Firstmate repo arc

Recent firstmate work: **Prime Agent** harness, **Herdr** long socket paths, **away-mode** daemon ownership, **secondmate** sync, **build methodology** in briefs, watcher **paused** honouring. Clone: `github.com/karanmrn/firstmate`.

## Lessons (high signal)

1. **SysV shm** on macOS caps embedded Postgres in parallel tests—watch `ipcs -m`.
2. **Dirty treehouse slots** block spawn; never spawn into primary clone (read `worktree=` line).
3. **Vercel** production is project **chengdu**, team **pubmax69**; previews can hit prod Supabase if misconfigured.
4. **Session limit** on Claude stalls all Claude workers—grep pane before relaunch storm.
5. **OpenRouter key cap** is separate from account balance—Prime/GNHF stop together.
6. **Classifier** blocks many firstmate fixes—workers or captain `!` one-liners for allowed ops.
7. **Skills**: user skill named `compact` shadowed `/compact`—renamed to `.disabled`.

## Moving to Mac Studio

Use this repo's [MIGRATION.md](MIGRATION.md) + [README](../README.md) three-command bootstrap; copy `data/` and `keys.env` encrypted; re-auth harnesses; run `verify.sh`.
