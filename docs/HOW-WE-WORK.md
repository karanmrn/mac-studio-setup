# Current Codex and Herdr workflow

This guide records the portable workflow verified on 13 October 2026.
The selected model is `gpt-6.1-sol` with `model_reasoning_effort="high"`.
The primary runs Codex inside Herdr, with the Firstmate checkout as its working directory.
Workers use the same selected model through Firstmate's supported dispatch configuration.

## Start the supervisor

1. Load the portable shell environment.

   ```bash
   source ~/.config/mac-studio-setup/fleet-env.zsh
   ```

2. Authenticate Codex on this machine.

   ```bash
   codex login
   ```

3. Open Herdr from WezTerm.

   ```bash
   herdr
   ```

4. Run `fm` inside the Herdr pane.
5. Review the repository trust prompt and each project hook before accepting the supported trust step.
6. Check `/model` for GPT-6.1 Sol and high reasoning.
7. Tell Firstmate to keep one worker and one build active on this MacBook Air.

The shell function selects the model explicitly. It does not bypass approvals, sandboxing, or hook trust.
The template does not copy the Studio's approval policy or its trust stores.
Firstmate's tracked `.codex/hooks.json` supplies the primary's startup, turn-end, and command checks after operator review.
Never use `--dangerously-bypass-hook-trust` to remove that review.

The observed account catalog reports a 500,000-token context window for this model.
The portable config leaves context capacity to the runtime catalog.
This guide does not establish that another account supports that model or capacity.
Existing 258K sessions do not acquire a larger context window from an installer or a changed config.
Use a fresh session after selecting a supported model. Check its runtime limit locally.

## Keep the supervisor and workers separate

Firstmate owns intake, project registration, dispatch, supervision, and merge authority.
Each worker owns only its task source, branch, validation, and permitted delivery.
A worker never adopts the supervisor role or administers shared daemons and worktree pools.

Firstmate's tracked `AGENTS.md` and `.agents/skills/` remain the instruction owners.
This setup clones their reviewed source. It does not vendor a second copy of the orchestration scripts.
The installer does not copy private preferences, project registries, backlogs, task inboxes, or runtime state.
Register projects through Firstmate on the new machine before dispatching work.

## Dispatch one task

Firstmate performs this procedure after project registration.
The project contract determines the delivery mode.

1. Scaffold the task with `bin/fm-brief.sh <task-id> <repo-name> --mode <delivery-mode>`.
2. Fill the captain intent and Firstmate spec in the generated brief.
3. Preserve the isolation, validation, status, delivery, and cleanup requirements in that brief.
4. Start the task with `bin/fm-spawn.sh` using its explicit mode and merge posture.

Example for an authorized direct-PR task:

```bash
bin/fm-spawn.sh <task-id> <repo-name> --mode direct-PR --yolo on \
  --harness codex --model gpt-6.1-sol --effort high
```

`--yolo on` records Firstmate's merge posture for that task. It does not give the worker merge authority.
It differs from Codex's approval and sandbox flags.
The current worker adapter starts with its tracked unrestricted permissions, disables lifecycle hooks, and supplies a turn-end notification.
This adapter choice prevents a worker hook-review prompt from blocking an unattended launch.
It does not trust unknown hooks or edit the operator's hook-trust store.
Keep that behavior in `bin/fm-spawn.sh`. Do not recreate the launch command in this setup repository.

## Use durable steering and status

Each brief supplies exact task inbox and status paths.
Workers read numbered inbox messages in order and acknowledge handled messages by moving them into `handled/`.
Workers append status lines with a plain Unix timestamp.
They report phase changes and actionable waits, blockers, decisions, and completion.
A declared wait names the job and the condition that permits work to resume.
An open decision or blocker requires its matching `resolved` record.

Firstmate uses `bin/fm-inbox.sh`, `bin/fm-send.sh`, and the registered task state owners.
Do not send input to a pane selected only by its current focus or label.
The full PR URL and exact source commit are part of delivery readback.
Herdr's idle or done badge proves that the pane accepts input. It does not prove task completion.

## Check and deliver

The brief defines the required proof and delivery path.
Workers reproduce defects through the real public entrypoint before changing source.
They preserve tests, trust checks, and source ownership when portability exposes a problem.
They distinguish local tests, browser proof, native devices, CI, merge, deployment, and production.

| Mode | Worker delivery |
| --- | --- |
| `direct-PR` | Commit, push the task branch, open a ready PR, and check its current head and draft state |
| `no-mistakes` | Use the project's native pipeline and its typed gates through the required CI-ready outcome |
| `local-only` | Follow the brief's local commit and report contract |

A direct-PR task does not add a manual reviewer or a no-mistakes run.
A pipeline-owned branch remains under pipeline custody until the owning process releases it.
Workers never restart, replace, or cancel shared pipeline infrastructure.
Install the optional pipeline binary only when the project needs it.
Initialize and operate it through the current project's supported instructions.

Firstmate's `bin/fm-pr-check.sh` and `bin/fm-pr-merge.sh` own guarded merge readback.
The guard reads current checks and required contexts and binds the merge to the verified PR head.
A worker completion report does not waive those checks.
This setup does not merge, publish a release, or deploy a project.

## Supervise in Codex

The tracked owner is `docs/supervision-protocols/codex.md` in the Firstmate clone.
Codex uses foreground checkpoints. It does not run Firstmate's watcher through shell background jobs.

1. Run `bin/fm-wake-drain.sh`.
2. Handle the emitted wakes and unresolved decisions.
3. Execute the exact `--ack-through` command printed by the drain.
4. Run `bin/fm-watch-checkpoint.sh --seconds 180` in the foreground.
5. Drain again when the checkpoint returns, including timeout or no-wake returns.
6. Process queued user messages before the next checkpoint.

`bin/fm-session-start.sh` owns startup lock acquisition, diagnostics, and recovery.
A second live primary must respect the existing home lock.
Away mode, relay services, secondmates, and extra providers remain separate operator opt-ins.

## Limit MacBook Air concurrency

Start with one supervisor, one worker, and one build at a time.
This limit applies even when there are several task worktrees.
An 8 GB Air should avoid browser farms, local databases, and native builds running together.
More memory does not establish that a particular project can support more workers.
Measure memory pressure, swap, and project build usage before increasing concurrency.
This is an operator dispatch policy, not an invented Firstmate concurrency flag.
The installer does not create an away-mode spend contract.
