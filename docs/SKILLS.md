# Skills inventory (generated from this Mac)

Source of truth on disk: `~/.agents/.skill-lock.json` (skills.sh global installs).
Reinstall everything: `~/mac-studio-setup/scripts/reinstall-skills.sh`.
Daily refresh: `~/mac-studio-setup/scripts/update-all.sh` (also runs `skills update` and gstack).

**Cap (captain, Sep 2026):** at most ~300 global skills; project-only skills live in each repo's tracked `.agents/skills/`.

## Harness discovery roots

| Path | Role |
|------|------|
| `~/.agents/skills/` | Primary global catalog (skills.sh) |
| `~/.claude/skills/` | Claude Code + plugin symlinks |
| `~/.cursor/skills/` | Cursor (often symlinked from `~/.agents/skills`) |
| `~/.codex/skills/` | Codex CLI |
| `~/.claude/plugins/` | Plugin-bundled skills (caveman, typesafe, codex, mattpocock when enabled) |
| `~/karan-agent-workspace/.agents/skills/` | Firstmate-internal playbooks (not in skill-lock) |
| `~/.agents/skills/gstack/` | Garry Tan gstack clone (`./setup` expands ~55 skills) |

## Claude Code plugins (user scope)

Installed via `claude plugin install` (see `install.sh`):

- **caveman@caveman** — caveman response style and related tooling
- **codex@openai-codex** — Codex integration inside Claude Code
- **typesafe@typesafe-ai** — Jev / TypeSafe review adviser
- **compact-adviser@compact-adviser** — optional compaction hints (often disabled)
- **compound-engineering@compound-engineering-plugin** — ECC hooks (enable only when needed)
- **mattpocock-skills@mattpocock** — bundled Matt Pocock skills (optional)
- **ecc@ecc** — GateGuard and ECC tooling (optional)

## By upstream source

### Kunchen Guid (axi fleet tooling)

#### `kunchenguid/axi`

- **axi** — >

#### `kunchenguid/chrome-devtools-axi`

- **chrome-devtools-axi** — "Control a Chrome browser session through the chrome-devtools-axi CLI - navigate, snapshot, click, fill forms, run JavaS

#### `kunchenguid/firstmate`

- **stow** — Sweep the current conversation for durable knowledge - user preferences, project facts, operational gotchas, standing de

#### `kunchenguid/gh-axi`

- **gh-axi** — "Operate GitHub through the gh-axi CLI - issues, pull requests, stacked PRs, workflow runs, workflows, releases, reposit

#### `kunchenguid/gnhf`

- **gnhf** — Use when the user asks to run GNHF, says they are going to sleep or leaving and wants an agent-managed coding run, asks 

#### `kunchenguid/grok-ship`

- **Adversarial review** — Playbook in installed skill catalog.
- **Ahoy** — Use when the captain explicitly says ahoy or /ahoy, or asks for a session recap of what happened since they last spoke, 
- **Project management** — Playbook in installed skill catalog.

#### `kunchenguid/kun`

- **kun** — >

#### `kunchenguid/lavish-axi`

- **lavish** — Turn complex or visual agent responses into rich, reviewable HTML artifacts (HTML files) the user can annotate and send 

#### `kunchenguid/no-mistakes`

- **no-mistakes** — Validate your code changes through the no-mistakes pipeline - automated code review, tests, lint, docs, push, PR, and CI

#### `kunchenguid/quota-axi`

- **quota-axi** — "Report local Claude, Codex, Cursor, GitHub Copilot, Grok, Kimi, Z.AI, Alibaba, OpenCode Go, Antigravity, Command Code, 

#### `kunchenguid/tasks-axi`

- **tasks-axi** — "Manage a task backlog through the tasks-axi CLI - add, list, show, start, and complete tasks; track blocked-by dependen

#### `kunchenguid/vision`

- **vision** — >

#### `kunchenguid/whathappened`

- **whathappened** — >

### Matt Pocock

#### `mattpocock/skills`

- **ask-matt** — Ask which skill or flow fits your situation. A router over the skills in this repo.
- **claude-handoff** — Hand the current conversation off to a fresh background agent that picks up the work immediately.
- **code-review** — "Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code fo
- **codebase-design** — Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find de
- **diagnosing-bugs** — Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports som
- **domain-modeling** — Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing a CONTEXT.md, o
- **git-guardrails-claude-code** — Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execut
- **grill-me** — A relentless interview to sharpen a plan or design.
- **grill-with-docs** — A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
- **grilling** — Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or u
- **handoff** — Compact the current conversation into a handoff document for another agent to pick up.
- **implement** — "Implement a piece of work based on a spec or set of tickets."
- **implement-spec** — "Implement a specification in code."
- **improve-codebase-architecture** — Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you 
- **loop-me** — Grill me about specs for the workflows I want to build, within this workspace.
- **migrate-to-shoehorn** — Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to re
- **pr** — "Use when writing a PR body."
- **prototype** — Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model o
- **research** — Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use w
- **resolving-merge-conflicts** — "Use when you need to resolve an in-progress git merge/rebase conflict."
- **retro** — "Conduct a retrospective on a coding session."
- **scaffold-exercises** — Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user
- **setup-matt-pocock-skills** — "Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layou
- **setup-pre-commit** — Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user w
- **setup-ts-deep-modules** — Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolder
- **to-questionnaire** — Turn a decision you can't fully answer into a questionnaire for someone else to fill in.
- **to-spec** — "Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of 
- **to-tickets** — Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, 
- **triage** — Move issues and external PRs through a state machine of triage roles, categorise, verify, grill if needed, and write age
- **wait-what** — "Stop. That last message did not land: re-pitch it."
- **wayfinder** — Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue track
- **wizard** — Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infras
- **writing-beats** — Writing, exploit; assemble raw material into a journey of beats, grounding each term before a beat leans on it.
- **writing-for-agents** — Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
- **writing-fragments** — "Writing, explore: mine raw fragments, no structure yet."
- **writing-shape** — "Writing, exploit: shape raw material into an article, paragraph by paragraph."

### pstack (panels, TDD, principles)

#### `backnotprop/pstack`

- **Make Bot UI** — Playbook in installed skill catalog.
- **Poteto Mode** — Playbook in installed skill catalog.
- **architect** — "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use fo
- **arena** — "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use for /ar
- **automate-me** — "Use for \"automate me\", \"create/update/refresh my -mode skill\", \"turn/capture my preferences or working style into 
- **blast-radius** — "Find what a change could break somewhere else before it ships, beyond the diff, and prove the one fact it's safe becaus
- **bro** — Restate the last message in plain human language, with no jargon.
- **create-verification-skill** — "Generate a project-local verification skill that drives your app the way a user does — any language, framework, or plat
- **figure-it-out** — "Design an auditable playbook when no narrower one fits: a large migration, an ambitious multi-part change, or work a hu
- **how** — "Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering question
- **interrogate** — "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\",
- **maintain-verification-skill** — "Periodic pass that keeps a project's verification skill and feature map honest: parallel source readers per feature, on
- **no-comments** — "Spawn Comment Sicko, fix accepted findings, and offer encodings for claimed constraints."
- **principle-attack-the-premise** — "Apply when two or more fixes that share one premise have failed the same gate. Take a census of which actors hold the i
- **principle-boundary-discipline** — "Apply when wiring validation, error handling, or framework adapters. Concentrate guards at system boundaries (CLI, conf
- **principle-build-the-lever** — "Apply to any non-trivial work, not just bulk work: edits, migrations, analyses, checks. Build the tool that does it or 
- **principle-encode-lessons-in-structure** — "Apply when you catch yourself writing the same instruction a second time, or notice a recurring correction. Encode the 
- **principle-exhaust-the-design-space** — "Apply when facing a novel UI interaction or architectural decision with no precedent in the codebase. Build 2-3 competi
- **principle-experience-first** — "Apply when product, UX, or feature-scope tradeoffs come up. Choose user delight over implementation convenience; ship f
- **principle-fix-root-causes** — "Apply when debugging. Trace each symptom to its root cause and fix it there; reproduce first, ask why until you reach i
- **principle-foundational-thinking** — "Apply before writing logic: choosing core types and data structures, sequencing scaffold-vs-feature work, asking what c
- **principle-guard-the-context-window** — "Apply when context is filling up: large outputs, long files, repeated reads, fan-out planning. Route bulk to subagents;
- **principle-laziness-protocol** — "Apply when refactoring, evaluating diff size, or tempted to add abstractions, layers, or signal threading. Bias toward 
- **principle-make-operations-idempotent** — "Apply when designing commands, lifecycle steps, or processing loops that run amid crashes, restarts, and retries. Conve
- **principle-migrate-callers-then-delete-legacy-apis** — "Apply when introducing a new internal API while old callers still exist. Migrate callers and delete the old API in the 
- **principle-minimize-reader-load** — "Apply when reviewing or shaping code that's hard to trace. Count layers between question and answer, and hidden state i
- **principle-model-the-domain** — "Apply when writing stateful logic, or when code branches a lot or repeats a shape assumption across files. Encode the d
- **principle-never-block-on-the-human** — "Apply when tempted to ask 'should I do X?' on reversible work. Proceed, present the result, let the human course-correc
- **principle-outcome-oriented-execution** — "Apply during planned rewrites and migrations with explicit phase boundaries. Converge on the target architecture; don't
- **principle-prove-it-works** — "Apply after completing a task, before declaring done. Verify against the real artifact (run the feature, read the actua
- **principle-redesign-from-first-principles** — "Apply when integrating a new requirement into an existing design. Redesign as if the requirement had been a foundationa
- **principle-separate-before-serializing-shared-state** — "Apply when concurrent actors might write to the same file, branch, key, or state object. Eliminate the sharing first; s
- **principle-sequence-verifiable-units** — "Apply to multi-step work (sweeps, migrations, runs of similar edits) and to how you stack commits and PRs. Break work i
- **principle-subtract-before-you-add** — "Apply when sequencing an addition, refactor, or rewrite. Remove dead code, redundant validators, and stub references fi
- **principle-test-behavior-not-implementation** — "Apply when you write, change, or keep a test. Call the code the way its users do and assert the result they observe aga
- **principle-type-system-discipline** — "Apply when designing types, reviewing a function signature, or writing code in any statically-typed language. Make ille
- **recall** — "Reconstruct your recent working context from your own chat history, live state, and the shared record (user reports, pr
- **reflect** — Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit o
- **setup-pstack** — Configure which models pstack uses per role and at what reasoning budget. Detects your available models and writes an al
- **show-me-your-work** — "Keep a reviewable decision trail for long-running or unattended work: a TSV log with one row per decision (what, why, e
- **swarm** — "Fan out N parallel workers, drain them, and return one report. Use for /swarm, 'swarm this', or parallel coverage, race
- **tdd** — "Use only when the user explicitly asks for TDD, a failing test, or a regression test, OR when the bug has an obvious ch
- **teach** — "Explain a body of work plainly so a person actually understands it. Runs the `how` and `why` skills and weaves what the
- **technical-writing** — "Layered technical-writing standard: Diátaxis structure, Google developer style sentences, STE instruction rules, Global
- **typescript-best-practices** — TypeScript best practices. Use when reading or editing any .ts or .tsx file.
- **unslop** — Cut AI tells from any writing. Must always apply.
- **why** — "Use for 'why does X work this way', 'why we picked Y', design rationale, regressions, postmortems, or data-backed thres

### Vercel Labs

#### `vercel-labs/agent-browser`

- **agent-browser** — Browser automation CLI for AI agents. Use when the user needs to interact with websites, including navigating pages, fil

#### `vercel-labs/agent-skills`

- **deploy-to-vercel** — Deploy applications and websites to Vercel. Use when the user requests deployment actions like "deploy my app", "deploy 
- **vercel-cli-with-tokens** — Deploy and manage projects on Vercel using token-based authentication. Use when working with Vercel CLI using access tok
- **vercel-composition-patterns** — React composition patterns that scale. Use when refactoring components with
- **vercel-optimize** — "Use for Vercel cost and performance optimization on deployed projects, especially Next.js, SvelteKit, Nuxt, and limited
- **vercel-react-best-practices** — React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, r
- **vercel-react-native-skills** — React Native and Expo best practices for building performant mobile apps. Use
- **vercel-react-view-transitions** — Guide for implementing smooth, native-feeling animations using React's View Transition API (`<ViewTransition>` component
- **web-design-guidelines** — Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit 
- **writing-guidelines** — Review docs/prose for Writing Guidelines compliance. Use when asked to "review my docs", "check writing style", "audit p

#### `vercel-labs/skills`

- **find-skills** — Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is th

### Vercel AI SDK

#### `vercel/ai`

- **ai-sdk** — 'Answer questions about the AI SDK and help build AI-powered features. Use when developers: (1) Ask about AI SDK functio

### Supabase

#### `supabase/agent-skills`

- **supabase** — "Use when doing ANY task involving Supabase. Triggers: Supabase products (Database, Auth, Edge Functions, Realtime, Stor
- **supabase-postgres-best-practices** — "Postgres best practices maintained by Supabase, for Postgres running anywhere. Load this skill BEFORE writing or changi

### PostHog

#### `PostHog/skills`

- **analyzing-expensive-users** — >
- **analyzing-experiment-session-replays** — 'Analyze session replay patterns across experiment variants to understand user behavior differences. Use when the user w
- **assessing-heatmaps** — "Assesses what a page's heatmap is telling you and recommends concrete changes. Pulls click / rageclick / scroll-depth d
- **auditing-experiments-flags** — 'Audit PostHog experiments and feature flags for configuration issues, staleness, and best-practice violations. Read whe
- **authoring-error-tracking-alerts** — >
- **authoring-log-alerts** — >
- **building-a-dashboard** — >
- **building-workflows** — 'Build, edit, test, enable, and monitor PostHog workflows over MCP. Author the action/edge graph so it runs and opens cl
- **checking-member-access** — >
- **choosing-trend-or-slope-view** — >
- **cleaning-up-stale-feature-flags** — 'Identify stale feature flags in a PostHog project and clean up the code that checks them. Use when the user wants to fi
- **configuring-experiment-analytics** — Configures the analytics side of a PostHog experiment — exposure criteria (server-resolved default exposure event vs cus
- **configuring-experiment-rollout** — Configures the rollout shape of a PostHog experiment — the variant split (50/50, 80/20, A/B/C ratios), the overall rollo
- **creating-ai-subscription** — >
- **creating-box-plot-insights** — >-
- **creating-experiments** — "Guides agents through experiment creation: reading the project's setup with experiment-setup-context, defining the hypo
- **creating-online-evaluations** — >
- **creating-surveys** — >
- **debugging-experiments** — >-
- **debugging-surveys** — >-
- **designing-email-templates** — 'Author, save, and edit email templates in the PostHog workflows library — compose email design JSON with Liquid persona
- **diagnosing-experiment-results** — "Diagnoses bias, anomalies, and strange results on a PostHog experiment. Covers 0-exposure experiments, sample ratio mis
- **diagnosing-missing-recordings** — >
- **diagnosing-sdk-health** — >
- **diagnosing-stacktrace-symbolication** — >
- **experiment-audit** — "Audit a PostHog A/B experiment for a customer — verify config, exposure, attribution, and metrics. Trigger phrases incl
- **exploring-ai-failures** — >
- **exploring-apm-traces** — >
- **exploring-autocapture-events** — >
- **exploring-live-traffic** — 'Inspects PostHog Web analytics Live tab data — current users online, last-30-minutes pageviews, top pages, referrers, d
- **exploring-llm-clusters** — 'Investigate AI observability clusters — understand usage patterns in AI/LLM traffic, compare cluster behavior, compute 
- **exploring-llm-costs** — >
- **exploring-llm-evaluations** — >
- **exploring-llm-traces** — >
- **filtering-bot-traffic** — 'Identify, measure, and exclude bot / crawler / AI-agent traffic in PostHog web and product analytics using the traffic 
- **finding-experiments** — Resolves a PostHog experiment reference from natural language to a concrete experiment ID by browsing `experiment-list` 
- **finding-replay-for-issue** — >
- **finding-sessions-to-watch** — >
- **formatting-insight-axes** — >
- **grouping-noisy-errors** — >
- **instrument-error-tracking** — >-
- **instrument-feature-flags** — >-
- **instrument-integration** — >-
- **instrument-llm-analytics** — >-
- **instrument-logs** — >-
- **instrument-metrics** — >-
- **instrument-product-analytics** — >-
- **investigate-metric** — >
- **investigating-error-issue** — >
- **investigating-logs** — >
- **investigating-metric-anomalies** — Investigates server/infrastructure metric anomalies in PostHog Metrics — from "this metric is rising/dropping/spiking" o
- **investigating-replay** — >
- **managing-experiment-lifecycle** — "Guides experiment state transitions: launching, pausing, resuming, freezing/unfreezing exposure, ending, shipping varia
- **managing-path-cleaning-rules** — 'Inspects URL paths and proposes, tests, orders, and applies project-level path cleaning rules so dynamic segments (nume
- **managing-reminders** — 'Create and manage PostHog reminders — private, human-paced nudges that fire as in-app notifications on a schedule, opti
- **managing-subscriptions** — >
- **posthog-debugger** — Debug and inspect PostHog implementations on any website. Use this skill when a user wants to understand how PostHog is 
- **posthog-survey-creator** — Create and configure surveys in PostHog through guided conversation. Use this skill when a user wants to create a survey
- **querying-posthog-data** — >
- **resolving-ingestion-warnings** — >
- **suggesting-path-cleaning-rules** — 'Runs and reasons about the automated AI health check that suggests path-cleaning rules for web-analytics teams. Use whe
- **suppressing-noisy-errors** — >
- **triaging-error-issues** — >
- **understanding-billing-usage** — >
- **writing-simplified-technical-english** — 'Write English that a reader cannot misread: one meaning per word, active voice, simple tenses, one idea per sentence, s

### ElevenLabs

#### `elevenlabs/skills`

- **agents** — Build voice AI agents with ElevenLabs. Use when creating voice assistants, customer service bots, interactive voice char
- **setup-api-key** — Guides users through setting up an ElevenLabs API key for REST API and SDK workflows. Use when the user needs to configu
- **speech-engine** — Add real-time voice conversations to a custom agent runtime with ElevenLabs Speech Engine. Use when building Speech Engi
- **speech-to-text** — Transcribe audio to text using ElevenLabs Scribe v2. Use when converting audio/video to text, generating subtitles, tran
- **text-to-speech** — Convert text to speech using ElevenLabs voice AI. Use when generating audio from text, creating voiceovers, building voi

### Anthropic example/document skills

#### `anthropics/skills`

- **canvas-design** — Create beautiful visual art in .png and .pdf documents using design philosophy. You should use this skill when the user 
- **claude-api** — |-
- **doc-coauthoring** — Guide users through a structured workflow for co-authoring documentation. Use when user wants to write documentation, pr
- **docx** — "Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files) or Word templa
- **frontend-design** — Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthe
- **mcp-builder** — Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services
- **pdf** — Use this skill whenever the user wants to do anything with PDF files. This includes reading or extracting text/tables fr
- **pptx** — "Use this skill any time a .pptx or .potx file is involved in any way — as input, output, or both. This includes: creati
- **skill-creator** — Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a sk
- **web-artifacts-builder** — Suite of tools for creating elaborate, multi-component claude.ai HTML artifacts using modern frontend web technologies (
- **xlsx** — "Use this skill any time a spreadsheet file is the primary input or output. This means any task where the user wants to:

### obra / superpowers

#### `obra/superpowers`

- **verification-before-completion** — Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verifi

### TypeSafe / Jev

#### `dbreunig/building-with-jev-skill`

- **jev** — Write and improve programs that call Jev, TypeSafe's System One model. Use when designing TypeSafe questions (Choice, Sc

### Other packs

#### `backnotprop/emil-skill`

- **emil-design-eng** — This skill encodes Emil Kowalski's philosophy on UI polish, component design, animation decisions, and the invisible det

#### `backnotprop/react-doctor`

- **animation-best-practices** — CSS and UI animation patterns for responsive, polished interfaces. Use when implementing hover effects, tooltips, button
- **react-doctor** — Use when finishing a feature, fixing a bug, before committing React code, or when the user wants to improve code quality

#### `michaelshimeles/skills`

- **new-feature** — Start a new task in an isolated Git worktree branched from origin/main so multiple agents can work on the same repo in p

#### `mvanhorn/last30days-skill`

- **last30days** — "Research what people actually say about any topic in the last 30 days. Pulls posts and engagement from Reddit, X, YouTu

## gstack (git clone, not skills.sh)

Clone `https://github.com/garrytan/gstack` to `~/.agents/skills/gstack`, run `./setup` (needs **bun**).
Produces design-review, ship, qa, browse, and related skills symlinked into harness dirs.

## Firstmate-internal skills (sample)

- `afk`
- `ahoy`
- `api-security-testing`
- `application-security-testing`
- `architect`
- `arena`
- `ask-matt`
- `ask-user-authority`
- `automate-me`
- `bearings`
- `before-and-after`
- `blast-radius`
- `bootstrap-diagnostics`
- `bro`
- `captain-hold-lifecycle`
- `ci-security-scanning-with-strix`
- `claude-handoff`
- `code-review`
- `code-structure`
- `codebase-design`
- `create-verification-skill`
- `decision-hold-lifecycle`
- `diagnosing-bugs`
- `diagnostic-reasoning`
- `domain-modeling`
- `evidence-driven-testing`
- `figure-it-out`
- `find-security-vulnerabilities-in-code`
- `firstmate-codexapp`
- `firstmate-coding-guidelines`
- `firstmate-orca`
- `fix-security-vulnerabilities-with-strix`
- `fmx-respond`
- `git-guardrails-claude-code`
- `greploop`
- `greploop-apps`
- `grill-me`
- `grill-with-docs`
- `grilling`
- `handoff`
- … and 82 more under `~/karan-agent-workspace/.agents/skills/`

## Kept but lightly used (captain audit Sep 2026)

- Large **PostHog** pack — many analytics playbooks; use the one that matches the task.
- **pstack** principle skills — reference library; load via `setup-pstack` routing, not all at once.
- **anthropics** document skills (docx, pptx, pdf) — occasional exports only.
- Disabled plugins (**ecc**, **compound-engineering**, **mattpocock-skills**) — enable for a session, disable after.

