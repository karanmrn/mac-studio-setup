# Agent handover for a MacBook Air

This entrypoint lets a fresh agent install and operate the portable Codex, Herdr, and Firstmate workflow.
Use the full contracts linked below for exceptions and detailed procedures.
This guide does not replace Firstmate's charter or the current task brief.

## Read the instruction owners in order

1. Read this handover before installation or task intake.
2. Read the [complete global instruction template](../config/agents/global-AGENTS.md).
   Read the machine's actual global instructions when present.
   The template includes engineering rules, skill routing, writing standards, and optional adviser limits.
3. Read [instruction layering](AGENT-INSTRUCTIONS.md) and [portable skill handling](PORTABLE-SKILLS.md).
   Claude keeps a separate global file. Its local Firstmate file imports the fleet charter.
4. Read the [full pinned Firstmate AGENTS.md][charter] and the clone's actual `$FM_HOME/AGENTS.md`.
   Read [configuration][configuration] and the [harness-adapters skill][harness-adapters] before startup, trust handling, or dispatch.
   Read its [Codex adapter][codex-adapter].
5. Read the [workflow guide](HOW-WE-WORK.md), [orchestration owners](ORCHESTRATION.md), and [Herdr guide](HERDR.md).
   Read the [Codex supervision protocol][codex-supervision] and each relevant skill or script owner in the table below.
6. Read the registered project's root `AGENTS.md` and every nearer applicable `AGENTS.md` at the edit location.
   For this setup repository, read [the project AGENTS.md](../AGENTS.md).
   Another project supplies its own rules. Read its actual local contracts rather than assuming this repository's rules apply.
7. If you are a worker, read your full generated launch brief and exact steering inbox before changing source.
   Preserve the worker identity even when the worktree contains Firstmate's supervisor charter.

Load skills only at their contract triggers.
Search the installed catalog once for a missing named skill and report the dependency.
The installer does not install global skill packs or the optional custom `asd-ste100` skill.
Apply the template's plain-writing rules when that optional skill is unavailable.
Do not install unrelated collections or fabricate skill availability.

## Install the accepted source

The accepted installer source is `74928b0b3c37b4a3f9b480372e6a1024550aaeb7`.
Its merged source is `b511a7b4bc90119fc48406f46807c620be698a10`.
The [merged setup PR](https://github.com/karanmrn/mac-studio-setup/pull/6) records the accepted command and source proof.
The installer pins Firstmate to `ab8d03ad1360baf4edeed3a1c57867d2e8237092` in [portable versions](../config/portable-versions.sh).
This handover does not change installer source or package pins.

Use Apple Silicon macOS and install Homebrew through [the official Homebrew instructions](https://brew.sh).
Follow Homebrew's prerequisites and shell setup so `brew` is available.
Use a GitHub account with read access to BOTH private repositories, `karanmrn/mac-studio-setup` and `karanmrn/firstmate`.

1. Install GitHub CLI.

   ```bash
   brew install gh
   ```

2. Authenticate GitHub through its supported login.

   ```bash
   gh auth login
   ```

3. Configure Git's supported credential helper.

   ```bash
   gh auth setup-git
   ```

4. Check private source access before installation.

   ```bash
   gh api repos/karanmrn/mac-studio-setup --jq .full_name
   gh api repos/karanmrn/firstmate --jq .full_name
   ```

5. Run the exact accepted bootstrap command.

   ```bash
   bash -o pipefail -c 'gh api "repos/karanmrn/mac-studio-setup/contents/bootstrap.sh?ref=74928b0b3c37b4a3f9b480372e6a1024550aaeb7" --header "Accept: application/vnd.github.raw+json" | bash -s -- --ref 74928b0b3c37b4a3f9b480372e6a1024550aaeb7'
   ```

The outer Bash enables `pipefail` for the authenticated fetch and execution pipeline.
The [bootstrap source][bootstrap] checks the immutable checkout before running the installer.
Private source requires authentication. Do not substitute an anonymous curl install or an invented Homebrew formula.
The bootstrap stores setup revisions under `~/.local/share/mac-studio-setup/<commit>`.
The default Firstmate home is `~/karan-agent-workspace`. An explicit absolute `FM_HOME` can select another home.
The installer preserves existing configs unless you request a backed-up replacement.
The [README](../README.md) describes dry runs, replacement, upgrades, and optional pipeline installation.

## Prepare the new home

These are operator startup instructions. They do not authorize a worker to drive shared Herdr lifecycle operations.

1. Source the portable environment in the terminal shell.

   ```bash
   source ~/.config/mac-studio-setup/fleet-env.zsh
   ```

2. Authenticate Codex on this machine.

   ```bash
   codex login
   ```

3. Open WezTerm and run `herdr`.
4. Run `fm` inside its Herdr pane, where `HERDR_ENV=1`.
5. Review repository trust and the tracked `.codex/hooks.json` through Codex's supported operator prompts.
6. Check the local `/model` picker for GPT-6.1 Sol and high reasoning.
7. Check the session-start digest before registration or dispatch.
8. Register project clones through Firstmate's [project-management skill][project-management].
9. Use one supervisor, one worker, and one build on the Air.

The [portable environment](../config/terminal/fleet-env.zsh) selects Codex with the model and high reasoning explicitly.
The observed source account advertised 500,000 tokens for GPT-6.1 Sol.
That discovery is account-scoped. Another account may offer different models or context limits.
The [Codex config](../config/codex/config.toml) leaves capacity to the runtime catalog.
Use a fresh session after selecting a supported model and check its limit locally.
Existing 258K sessions do not gain capacity from installation or a config change.
Measure memory pressure, swap, and build usage before increasing Air concurrency.

The operator must review supported hooks. Do not use `--dangerously-bypass-hook-trust` or manufacture trust-store entries.
The worker adapter disables lifecycle hooks and uses its tracked notification path.
The adapter's permissions do not grant supervisor, merge, discard, or deployment authority.
Read the [Codex adapter][codex-adapter] and [worker launch owner][spawn] for that distinction.

The session-start owner is `bin/fm-session-start.sh` in the Firstmate clone.
Check that its full digest ran in this session. Run it once if the harness did not run it.
Do not recreate its composed startup steps.
If lock acquisition or verification fails, report the exact diagnostic and remain read-only.
Do not spawn, steer, drain wakes, repair source or supervision, merge, or otherwise mutate fleet state after a lock refusal.
[Charter section 3][startup] defines startup. [Section 5][recovery] defines recovery.

## Follow the registered task workflow

Firstmate owns intake, registration, dispatch, supervision, and guarded landing.
The worker owns its exact task worktree, branch, source changes, proof, and permitted delivery.
Workers report only to Firstmate and preserve other owners' edits.
Workers do not administer shared daemons, pools, or other homes' endpoints.

Firstmate writes the task brief through `bin/fm-brief.sh`.
The captain intent contains the actual ask, stated boundaries, and referenced context.
The Firstmate spec contains only the implementation instructions that ask requires.
Resolve a concrete delivery mode and `yolo` from the current instruction and registered project posture.
Record any deviation with its reason. A conditional registry policy still needs a concrete task mode.
Consult `config/crew-dispatch.json` at each intake and pass the resolved concrete profile to `bin/fm-spawn.sh`.
The portable [dispatch template](../config/codex/crew-dispatch.json) selects Codex, GPT-6.1 Sol, and high reasoning.
Follow [charter section 4][dispatch], [section 7][delivery], and [configuration][configuration] for profile selection and typed resolution.
`yolo` controls Firstmate's merge authority only. It does not give a worker permission to merge.

The generated brief names the exact isolated worktree.
Before any edit, the worker checks `pwd -P` and `git rev-parse --show-toplevel` against that path.
A primary checkout or a different worktree is a stop condition.
Do not select an apparently unused slot, create another checkout, or reassign a pool slot yourself.
Use the generated scaffold's status and isolation instructions exactly.
Herdr lifecycle experiments require a regenerated `--herdr-lab` brief and the named-lab helper before any lifecycle action.

Firstmate steers ordinary text through `bin/fm-send.sh` to the task's durable inbox.
The worker reads numbered messages in numeric order and moves handled messages into `handled/` as acknowledgement.
The brief supplies the exact inbox and status paths for the new home.
Status events use a plain Unix timestamp from `date +%s`.
Report actionable phase changes and distinguish `paused`, `blocked`, `needs-decision`, and `done`.
A wait names its job and resume condition.
An open blocker or decision needs a `resolved` event with its exact key.
Firstmate uses `--resolve-key` when an answer closes that record.
A later `working` or `done` event never closes the decision by itself.
The [steering script][send] and [brief owner][brief] define full syntax and exceptions.

## Keep one live foreground supervision cycle

The supervising Codex session follows its emitted protocol while work is active.
A worker does not run fleet supervision.
Use exactly one live cycle, without shell background jobs or a second watcher.

1. Drain with `bin/fm-wake-drain.sh` before other wake-handling actions.
2. Handle all emitted wakes and reconcile `OPEN DECISIONS`, `UNREAD STATUS`, and any record divergence.
3. Execute the exact generation-bound `--ack-through` command printed as `WAKE_ACK_REQUIRED` after handling its records.
4. Run `bin/fm-watch-checkpoint.sh --seconds "${FM_CODEX_WATCH_CHECKPOINT:-180}"` in the foreground.
5. Drain again when the checkpoint returns, including timeout or no-wake returns.
6. Process queued user messages before the next checkpoint.

Do not reconstruct acknowledgement arguments or acknowledge already processed sequences again.
A historical status line is an event, not current state.
Use `bin/fm-crew-state.sh` and the recorded task endpoint when current ownership or readiness matters.
Reconcile only this home's direct reports and recorded backend inventory.
A Herdr idle or done badge does not prove task completion.
[Charter section 8][supervision] and the [Codex protocol][codex-supervision] own the complete cycle and recovery exceptions.

## Preserve source custody through delivery and cleanup

The selected path defines required proof. Do not add an independent review gate to a direct-PR task.
A direct-PR worker commits, pushes its latest head, opens a non-draft PR, and reads its head and draft state back.
A no-mistakes worker drives the project's native pipeline and typed gates through its required CI-ready result.
Bind pipeline evidence to the actual task branch, current source head, run identity, and active custody.
Old runs, stale green checks, or generic permissions do not authorize source changes outside pipeline custody.
Do not hand-edit, commit, force-sync, rerun, cancel, or push around an active pipeline-owned branch.
The [validation-supervision skill][validation] owns the narrow supported invalidation and custody-recovery exception.
An implementation worker never answers its own ask-user finding.
Firstmate loads [ask-user-authority][ask-user-authority] and [validation-supervision][validation] before deciding or escalating that finding.

Firstmate uses `bin/fm-pr-check.sh` and `bin/fm-pr-merge.sh` for current-head checks and guarded merge.
The merge owner checks current forge state, required contexts, and the exact head before landing.
A missing required check is not green. `yolo` does not waive failed checks.
Full exceptions and attended waiver requirements remain in [charter section 7][delivery] and the [merge script][merge].
Deployment has separate project authority. A merge, worker completion, or `yolo` posture does not authorize deployment.
Keep local, browser, native-device, CI, merge, deploy, and production claims distinct.

Load [ship-landing][landing] before deciding landing or cleanup.
Check landing before guarded teardown through `bin/fm-teardown.sh`.
Its full landed-work, source containment, pending-decision, endpoint, and slot-ownership checks remain authoritative.
Close only a confirmed-complete task's recorded pane through its guarded owner.
A pane label, old record, pushed branch, or global permission never independently authorizes discarding unlanded work.
Preserve dirty source, unpublished commits, and unique evidence when cleanup refuses.
Never force teardown without explicit authority to discard the specific work.
Workers do not return their own pool slots or close other tasks' panes.

## Locate the detailed owners

These links all use Firstmate pin `ab8d03ad1360baf4edeed3a1c57867d2e8237092`.
Read actual local files after an approved source update.

| Workflow detail | Complete owner |
| --- | --- |
| All role rules, precedence, and exceptions | [Full charter][charter] |
| Startup, recovery, and lock refusal | [Section 3][startup], [section 5][recovery], [session-start script][session-start] |
| Project registration and local registry | [Section 6][projects], [project-management skill][project-management] |
| Dispatch profile, model, backend, mode, and yolo | [Section 4][dispatch], [section 7][delivery], [configuration][configuration], [harness-adapters skill][harness-adapters] |
| Brief, isolation, and definition of done | [Section 11][brief-contract], [brief script][brief], [delivery library][dod], [spawn script][spawn] |
| Steering, timestamps, and keyed resolution | [Section 7][delivery], [steering script][send], [status classification][classify] |
| Wake handling and current-state reconciliation | [Section 8][supervision], [Codex protocol][codex-supervision], [wake drain][wake-drain], [crew state][crew-state] |
| Native pipeline identity and custody | [Validation skill][validation], [run attribution library][nm-run] |
| PR registration, current checks, and guarded merge | [Ship-landing skill][landing], [PR check script][pr-check], [merge script][merge] |
| Landed-only cleanup and exact endpoint ownership | [Ship-landing skill][landing], [teardown script][teardown] |
| Herdr routing and lifecycle isolation | [Backend guide][herdr-backend], [named-lab helper][herdr-lab] |
| Captain decisions and durable holds | [Section 9][escalation], [captain-hold skill][captain-hold] |
| Backlog, self-update, optional modes, and relay | [Full charter sections 8 and 10 through 14][charter] |

## Use the proof at its stated level

[Source provenance](PORTABLE-PROVENANCE.md) and [validation receipts](PORTABLE-VALIDATION.md) describe the accepted installer's source-Mac evidence.
All 13 isolated installer and bootstrap cases passed there.
Release checksum checks and isolated Herdr and Codex execution receipts passed there.
Those receipts exercised CLI commands without a newly authenticated model turn.
They do not prove installation on a physical MacBook Air or a newly authenticated model session.
Terminal visual review, native-device proof, deployment, and production also remain outside those receipts.
This documentation change does not repeat the installer suite or establish additional installation proof.

A new home must register projects and create its own runtime state.
Do not transfer active Studio tasks, private preferences, histories, backlogs, credentials, tokens, databases, or evidence content.
Do not transfer live pane IDs, session IDs, authentication stores, or hook-trust stores.
The portable templates contain workflow configuration, not an active fleet migration.

## Paste this prompt into the fresh agent

```text
Read docs/AGENT-HANDOVER.md from the reviewed mac-studio-setup checkout.
Read the complete global template and the machine's actual global instructions.
Read the actual Firstmate charter, relevant skills, and local project AGENTS.md files in the handover's order.
Determine your role from the current local contract or launch brief.
Inspect current source, registration, ownership, and runtime state before acting.
Follow the registered delivery and supervision path through its required outcome.
Respect lock refusals, exact worktree ownership, and native pipeline custody.
Use local model discovery and a fresh session to check account limits.
Keep one worker and one build on the Air until measured capacity permits more.
Report proof limits and actionable blockers through your role's required channel.
```

[charter]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md
[configuration]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/docs/configuration.md
[codex-adapter]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/harness-adapters/references/harness/codex.md
[codex-supervision]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/docs/supervision-protocols/codex.md
[project-management]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/project-management/SKILL.md
[startup]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#3-session-start-run-once-at-every-session-start
[dispatch]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#4-harness-and-runtime-dispatch
[projects]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#6-project-and-knowledge-management
[brief-contract]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#11-crewmate-briefs
[delivery]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#7-task-lifecycle
[supervision]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#8-supervision-protocol
[escalation]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#9-escalation-and-captain-etiquette
[session-start]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-session-start.sh
[brief]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-brief.sh
[dod]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-dod-lib.sh
[spawn]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-spawn.sh
[send]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-send.sh
[classify]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-classify-lib.sh
[wake-drain]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-wake-drain.sh
[crew-state]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-crew-state.sh
[validation]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/validation-supervision/SKILL.md
[nm-run]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-nm-run-lib.sh
[landing]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/ship-landing/SKILL.md
[pr-check]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-pr-check.sh
[merge]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-pr-merge.sh
[herdr-backend]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/docs/herdr-backend.md
[herdr-lab]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-herdr-lab.sh
[captain-hold]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/captain-hold-lifecycle/SKILL.md
[teardown]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/bin/fm-teardown.sh
[bootstrap]: https://github.com/karanmrn/mac-studio-setup/blob/74928b0b3c37b4a3f9b480372e6a1024550aaeb7/bootstrap.sh
[recovery]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md#5-recovery
[harness-adapters]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/harness-adapters/SKILL.md
[ask-user-authority]: https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/.agents/skills/ask-user-authority/SKILL.md
