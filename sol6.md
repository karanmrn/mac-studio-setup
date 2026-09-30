# sol6 - state of the fleet, 29 Sep 2026

The single handover document for the move from the MacBook Pro to the Mac Studio M5 Max. It records what the captain and firstmate have executed since 3 Sep 2026, what is live, what is waiting, and what to execute next. It holds no secret values; key names only.

Written by firstmate on 29 Sep 2026, after the 28 Sep wind-down and the 29 Sep production build.

## 1. How to use this document

1. Read section 2 for the one-screen summary.
2. On the Mac Studio, follow `docs/MIGRATION.md` in this repo (and the migration checklist doc linked in section 9) before starting firstmate.
3. Start firstmate in `~/karan-agent-workspace`. It reads `data/checkpoints/2026-09-28-codex-app-handover.md` and its 29 Sep update section first.
4. Use section 8 as the work queue. Nothing in it starts without the captain's word.

## 2. One-screen summary

| Area | State on 29 Sep 2026 |
|------|----------------------|
| Production (pubmaxxing.com) | Built once on 29 Sep from `main` at `b49b58500` (PR 1866). Includes every merge listed in section 5. |
| Open pubmax PRs owned by the fleet | None. Draft PR 1861 (map UI sweep, paused) is the only fleet branch left open. |
| Workers running | None. Fleet stopped on the captain's word. |
| Harnesses and tools | Updated on 29 Sep (section 7). |
| Migrations | 0158 (Drink Wall), 0159 (Supabase hygiene), 0160 (pub_pal_tool_turns) applied on 28 Sep. No migration pending. |
| Machine | MacBook Pro to be returned. Mac Studio M5 Max becomes the only machine. |
| Biggest known risk | Self-hosted CI runners leave orphaned test servers on port 3670 after a cancelled browser job (section 8.2). |

## 3. The operating model

### 3.1 Roles

- **Captain** sets goals and gives every merge, deploy, migration and destructive-action word.
- **Firstmate** (Claude Code in `~/karan-agent-workspace`, the `firstmate` repo) is the only point of contact. It writes briefs, spawns workers, supervises them, merges when the captain's rules allow, and reports outcomes.
- **Workers (crewmates)** run one task each in an isolated treehouse worktree of the project and report through `state/<task>.status`. They never talk to the captain.
- **Scouts** produce reports in `data/<task>/report.md`, never PRs.
- **no-mistakes** is the validation pipeline (review, test, document, lint, push, PR, CI). The worker that starts a run owns every gate response.

### 3.2 Standing laws (short form; canonical copy in `data/captain.md`)

- Merges, deploys and migrations happen only on the captain's word. Migrations use `apply <n>`, never bundled with a merge.
- One production build per captain word. The Vercel project `chengdu` (team `pubmax69`) keeps `commandForIgnoringBuildStep = "exit 0"`, so pushes to `main` never build by themselves.
- No GitHub Actions billing. CI runs on three self-hosted runners on the Mac (`karan-mac-pubmax`, `-2`, `-3`).
- Zero `public/data` and `uk_base/public/data` churn in feature PRs.
- Never print or commit secrets. Keys live in `data/keys.env` (mode 600).
- Never run `sudo` for the captain.
- Use Cursor (`composer-2.5`) for workers unless the captain says otherwise. Faster is better.
- Keep Google spend inside the $300 credit.
- Every PR body carries a show-me section (pseudocode, one Mermaid diagram, TDD evidence).
- Never tear down unlanded work.

### 3.3 One-off decisions of 28 Sep (not standing rules)

- For the 28 Sep batch only: skip the slow local no-mistakes test gate and let GitHub CI be the proof.
- For the 28 Sep batch only: merge past the known `e2e/map-surface-history.spec.ts` flake when it is the only red check.

## 4. Timeline, 3 Sep to 29 Sep 2026

| Dates | What happened |
|-------|---------------|
| 3 Sep | New MacBook set up. Firstmate home rebuilt, captain laws reconstructed, pubmax canonical clone at `~/Documents/projects/pubmaxx`, WezTerm opens into Herdr. |
| 4 to 6 Sep | Release decisions grilled (web relaunch London, iOS and Android store track, value-first journey). First big merge days; review waves (merged-code, thermonuclear, codebase design) with captain calls filed. |
| 7 to 10 Sep | USP set as speed, performance, design and onboarding. Show-me PR bodies became law. Performance-review scout; perf A/B instrument; Grok waves when Claude quota ran low. |
| 11 to 13 Sep | Quota wall: Grok for all workers. Harness inventory and Herdr sidebar ideas. Merge-gate review. |
| 14 to 16 Sep | Prime Agent plus OpenRouter workers, GNHF overnight loops. Blacksmith CI tried and dropped. Skills audit (~300 cap). Issue 1623 audit (285 unnamed OSM pubs, UK seed age). Codex handover. |
| 17 to 22 Sep | Cursor composer-2.5 became the default worker. Away mode ran silently to completion. GitHub branch clean-up on 22 Sep. Codex handoffs. |
| 20 to 26 Sep | Jev reviews on subagent diffs; `crew-dispatch.json` routing; hackathon pause on 26 Sep with eight lanes parked. |
| 27 Sep | Lanes resumed. Pal (Pub Pal) moved to the ElevenLabs agent. Firstmate PR 6 (paused wakes during pipeline). |
| 28 Sep | Biggest merge day (section 5). Migrations 0158 to 0160 applied. Production built at 12:00. Mac Studio setup repo v1 and v2 merged. Evening: captain chose speed over local gates; fleet finished and stopped. |
| 29 Sep | PR 1866 merged on the captain's word. One production build of `main`. Tools, harnesses and skills updated. This document written. |

## 5. Everything merged on 28 and 29 Sep

### 5.1 pubmax (`Singularityszn/pubmax`)

| PR | Change |
|----|--------|
| 1841, 1842, 1848 | Older fixes: price budget partial denial, GBP formatting through `formatGbp`, current-city venue priority in Map search. |
| 1850 | Supabase hygiene (migration 0159). |
| 1851 | Faster rate-limit test. |
| 1852 | Security CI on self-hosted runners: zizmor, osv-scanner, Semgrep. |
| 1853 | Pal runs on the ElevenLabs agent (no OpenRouter needed). |
| 1854 | Pal greeting fix. |
| 1855 | Root cause of `public/data` churn in the no-mistakes test step (restore wrapper). |
| 1856 | Mobile polish. |
| 1857 | Pal live tools (14 webhook tools at `https://pubmaxxing.com/api/pub-pal/tools/*`). |
| 1862 | Vercel Speed Insights, mounted like Analytics right after consent. |
| 1863 | Soft drinks: one zero-sugar cola family chip (Coke Zero, Diet Coke, Pepsi Max, Diet Pepsi) with the verbatim brand per row. |
| 1864 | Plan flush race fixed: one tap now sends one POST, not about 44. |
| 1865 | Old cola leaf `?sub=` links rewrite to the family chip. |
| 1866 | Security audit fixes: iOS shell treats only the real host as in-app, CSP Supabase host, API trailing-slash bypass closed, `/api/version` anonymous shape, OAuth error envelope, `*.env` gitignore. |
| 1867 | Map List view: Escape closes the venue drawer, the list comes back, focus returns to the row. |
| 1868 | Map toolbar e2e hardening: Browser law pins failures dropped from 5 to 7 per run to 1. |

### 5.2 Other repos

- `karanmrn/firstmate` PR 6: watcher honours a declared `paused:` status during an active pipeline step.
- `karanmrn/mac-studio-setup` PRs 1 and 2: reproducible bootstrap, agent instructions, skills catalogue, working method, orchestration, subscriptions, updates, Kun Chen stack.
- This document and the Herdr and install instructions (the PR that adds `sol6.md`).

### 5.3 Services configured on 28 Sep (names only)

- Vercel production env: `ELEVENLABS_API_KEY`, `ELEVENLABS_PUB_PAL_AGENT_ID`, `ELEVENLABS_LLM_SHARED_SECRET`, `TAVILY_API_KEY`.
- ElevenLabs agent "PUBMAXX Pub Pal" on gemini-2.5-flash-lite with 14 webhook tools. After any build that changes Pal tools, re-run `npm run pubpal:agent -- --base-url https://pubmaxxing.com` with `data/keys.env` loaded.
- PostHog dashboard with 7 charts. Alerts need an API key with `alert:write`.

## 6. Scouts and reports worth reading

All under `~/karan-agent-workspace/data/`:

- `pubmax-scout-ratings-diary/report.md` - recommends a Letterboxd-style diary with half-star ratings first.
- `pubmax-scout-london-depth-prices/report.md` - 1,901 curated London pubs plus about 1,750 from OSM; recommends a nightly Tavily pass, bounded OSM promotion and labelled price estimates.
- `pubmax-security-audit/report.md` - findings F-01 to F-10 (now fixed in 1866 except the deferred middleware call).
- `performance-review`, `review-merged-code`, `review-thermonuclear`, `review-codebase-design`, `harness-inventory-13sep` - sources of the open captain calls in section 8.3.
- `storage-audit` notes (28 Sep): 271 GB free; Downloads 80 GB, tool caches 30 GB, Xcode 20 GB, npm 7 GB, runners 15 GB.

## 7. Tools, harnesses and skills (updated 29 Sep)

Update procedure: `scripts/update-all.sh` in this repo, plus the self-updaters listed in `docs/UPDATING.md`. On 29 Sep firstmate ran it with the fleet idle (log tail `2026-09-29 03:36:32Z` in `~/karan-agent-workspace/data/deck/update-all.log`), which upgraded **no-mistakes** v1.79.0 to **v1.84.0**, **claude-code** cask, and npm globals. Canonical version table: `docs/AGENTS-AND-TOOLS.md` and full install commands: `docs/INSTALL-INVENTORY.md`.

| Tool | Role |
|------|------|
| Claude Code | Firstmate (orchestrator). |
| Cursor agent (`composer-2.5`) | Default worker harness. |
| Codex CLI and Codex app | Alternative front end and workers. |
| Grok, opencode, pi, Prime Agent, gnhf | Overflow and overnight harnesses. |
| no-mistakes | Validation pipeline; config order `agent: [cursor, codex, claude]`. |
| treehouse | Worktree pool per project. |
| Herdr | Terminal multiplexer and command deck (see `docs/HERDR.md`). |
| WezTerm (and Ghostty) | Terminals; Herdr drives WezTerm panes (see `docs/HERDR.md`). |
| gh, gh-axi, chrome-devtools-axi, lavish-axi, quota-axi, tasks-axi | Firstmate's axi tools. |

| Component | Version (29 Sep 2026, after `update-all`) |
|-----------|-------------------------------------------|
| Homebrew | 6.0.1 |
| GitHub CLI (`gh`) | 2.101.0 |
| Claude Code | 2.1.285 |
| Codex CLI | 0.158.0 |
| OpenCode | 1.18.33 |
| Pi | 0.87.1 |
| Grok | 1.0.41 |
| cursor-agent | 2026.09.28 |
| Herdr | 0.9.3 |
| no-mistakes | 1.84.0 |
| treehouse | 3.1.0 |
| prime-agent | 0.9.7 |
| gnhf | 0.1.50 |
| acpx | 0.19.3 |
| gh-axi | 0.1.35 |
| chrome-devtools-axi | 0.1.35 |
| lavish-axi | 0.1.79 |
| quota-axi | 0.1.55 |
| tasks-axi | 0.2.6 |
| gitnexus | 1.6.12 |
| agent-browser | 0.38.1 |
| skills (`npx skills`) | 1.7.0 |
| vite-plus (`vp`) | 1.0.0 |
| Node (via vp) | v26.8.1 |
| pnpm (via vp) | 12.6.0 |
| Bun (via vp) | 1.4.2 |
| Xcode CLT | `/Applications/Xcode.app/Contents/Developer` |

## 8. What still needs to be executed

### 8.1 First, on the Mac Studio (in order)

1. Migration Assistant from the MacBook (Thunderbolt), then `install.sh` and `verify.sh` from this repo.
2. Re-register the three self-hosted runners on the Studio (`scripts/install-runners.sh`) and remove the MacBook runners from GitHub.
3. Start firstmate, confirm the fleet digest shows no work under way and the backlog intact.
4. One small test task end to end to prove workers spawn in Herdr.
5. Rotate tokens that lived only on the MacBook and update `data/keys.env`.

### 8.2 Engineering follow-ups (ready to dispatch on the captain's word)

| Backlog id | What |
|------------|------|
| `pubmax-ci-orphan-servers` | Add an `always()` clean-up step so a cancelled browser job kills its server on port 3670. Today the next Browser law pins job fails with "localhost:3670 is already used". Workaround: kill the process whose parent is PID 1 and re-run. |
| `pubmax-map-escape-planner-flake` | Last flaky law-pins test: "Escape restores populated planner". |
| `pubmax-nm-ci-step-data-churn` | The no-mistakes CI-step auto-fix still commits regenerated `public/data` and edits flaky tests owned by other lanes. |
| `pubmax-social-crews-test-deadlock` | Postgres test harness deadlocked for 2 h; add `lock_timeout`. |
| `pubmax-pal-plan-and-cards` | Pal says it cannot plan a Shoreditch crawl although `propose_plan` returns 200; chat replies show empty `toolsUsed` and cards. |
| `pubmax-map-ui-sweep` | Paused with draft PR 1861: headless QA at 390 and 1280, up to 10 defect fixes. |
| `pubmax-api-middleware-composition` | Security follow-up: all `/api` through `securityProxy` on the canonical host, or keep `clerkMiddleware`. Needs a captain call first. |
| Two stubborn unit tests | `__tests__/noMistakesTestCommand.test.ts` (revision `local`) and `__tests__/pintDrops.test.ts` missing-rpc 429, seen during the security lane; confirm on main. |
| Dependabot PR 1860 | Review and merge on the captain's word. |

### 8.3 Captain calls still open

- Map tiles: own CDN or keep OpenFreeMap (`perf-review-tile-cdn`).
- Landing primary: keep "Still £6.50" or point at an answer (`perf-review-landing-primary`).
- 285 unnamed OSM pubs on the map (`pubmax-unnamed-pubs-on-map`).
- UK pub seed refresh from OSM (`pubmax-uk-seed-refresh`).
- Phone map camera reset control (`pubmax-phone-compass`).
- Move vendored skill trees out of the product repo (`vendored-skills-in-repo`).
- Jev supervision absorb (`fleet-jev-supervision-absorb`).
- Older review follow-ups: merged-code, thermonuclear and codebase-design calls.
- PostHog write scopes for alerts.
- Herdr sidebar colours (`herdr-sidebar-colours`).

### 8.4 Features not started (need scoping and the captain's go)

- Ratings and diary phase 1 (`pubmax-diary-phase1`).
- London depth first ship (`pubmax-london-depth-ship`).
- Onboarding redesign on the Ideal Flow reference (`pubmax-onboarding-ideal-flow`).
- Pint-filling loader (`pubmax-pint-loader`).
- Pal streaming text, early voice, memories (rescope for ElevenLabs).
- ComfyUI Pal variant sheet (`comfyui-pal-variants`).
- Project-scope agent skills (`pubmax-project-skills`).
- Fleet inference fallbacks: Nebius Token Factory (`fleet-nebius-inference`), Kaggle TPU lab (`kaggle-tpu-lab-setup`).

## 9. Where things live

| Thing | Location |
|-------|----------|
| Firstmate home | `~/karan-agent-workspace` (repo `karanmrn/firstmate`; private `data/`, `state/`, `config/`, `projects/` are gitignored) |
| Backlog | `~/karan-agent-workspace/data/backlog.md` (tasks-axi) |
| Captain laws | `~/karan-agent-workspace/data/captain.md` |
| Learnings | `~/karan-agent-workspace/data/learnings.md` |
| Handover | `~/karan-agent-workspace/data/checkpoints/2026-09-28-codex-app-handover.md` |
| Keys | `~/karan-agent-workspace/data/keys.env` (mode 600, never in git) |
| pubmax clone | `~/Documents/projects/pubmaxx`, symlinked as `projects/pubmax` |
| Setup repo | `karanmrn/mac-studio-setup` (this repo) |
| Migration checklist doc | https://claude.ai/artifact/UmyEm4Lem8qAFjjSUdgycr |
| Production | https://pubmaxxing.com (Vercel project `chengdu`, team `pubmax69`) |
| Supabase | project `iankajxliutqogqkmvdg` |

## 10. Lessons from 28 Sep

1. Running four full local test suites at once drove load above 170 and made each run 45 to 60 minutes; the fleet should run at most two validation lanes at a time on one machine.
2. The no-mistakes test agent has a 2-hour budget and hit it repeatedly under load; a stuck fix round cannot be skipped until it reaches a gate, but `no-mistakes axi abort` plus fetching the pipeline head from its run worktree recovers the fixes.
3. The pipeline's CI auto-fix will edit tests owned by other lanes; check every PR diff for files outside its scope before merge.
4. A cancelled Browser law pins job leaves `npm run start --port 3670` orphaned and breaks the next job on that runner.
5. Firstmate must not answer idle monitoring pings with repeated status replies; stop idle workers as soon as their work is merged or waiting only on the captain.
