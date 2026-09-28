# Firstmate orchestration

How `~/karan-agent-workspace` runs the fleet. Commands live in `bin/`; this doc is the map.

## Roles

```
                    ┌──────────────┐
                    │   Captain    │
                    └──────┬───────┘
                           │ goals, merge/deploy, keys
                    ┌──────▼───────┐
                    │  Firstmate   │  Claude Fable 5.1 (default)
                    │  (1 session) │
                    └──────┬───────┘
           briefs/spawn    │    status files + inbox
     ┌─────────────────────┼─────────────────────┐
     ▼                     ▼                     ▼
┌─────────┐          ┌─────────┐          ┌─────────┐
│ Crewmate│          │ Scout   │          │Secondmate│
│ ship    │          │ read-only│         │ charter │
│ worktree│          │ report  │          │ own FM_HOME│
└────┬────┘          └─────────┘          └─────────┘
     │
     ▼
┌─────────┐     ┌──────────────┐
│ Herdr   │────►│ treehouse    │
│ pane    │     │ worktree     │
└─────────┘     └──────────────┘
```

- **Crewmate:** writes code in a pool worktree; reports `working|done|blocked|needs-decision|paused|failed` to `state/<task>.status`.
- **Scout:** investigation only; scratch worktree; no merge without report.
- **Secondmate:** isolated firstmate home with scoped charter; outcomes return to parent channel.

## Brief → spawn → steer

| Step | Command / file | Notes |
|------|----------------|-------|
| 1. Brief | `bin/fm-brief.sh <id> <project>` | Fills `{TASK}` + `{FIRSTMATE_SPEC}`; captain intent separate from spec |
| 2. Spawn | `bin/fm-spawn.sh` | `--harness cursor --model composer-2.5 --effort xhigh` (routing from `config/crew-dispatch.json`) |
| 3. Steer | `bin/fm-send.sh <id> "..."` | Inbox `state/<id>.inbox/*.msg` for durable orders |
| 4. Doorbell | `fm-send.sh <id> --key Enter` | Fixes stuck Codex "Trust hooks" / submit lines |
| 5. Control | `bin/fm-control.sh <id> relaunch\|exit` | Relaunch preserves worktree; exit needs agent confirmation |
| 6. Merge | `bin/fm-pr-merge.sh` | Local bar first; GraphQL merge may fail—REST squash documented in learnings |
| 7. Teardown | `bin/fm-teardown.sh` | After merge verified; never on unlanded work |

**Isolation:** spawn token `projects/pubmax` (not bare `pubmax`). Firstmate must not edit `projects/` except captain-approved exceptions.

## Watcher and wake queue

```
  Herdr pane events / quota / timers
              │
              ▼
      fm-procevent / watcher
              │
              ├── stale pane ──► fm-send (doorbell)
              ├── quota low ──► wake firstmate
              └── task done ──► fm-pr-check / merge poll
```

- **Long-interval watch** (`data/tools/fm-watch-long.sh`): fewer wakes overnight; heartbeat 30m.
- **Grok failover** (`fm-grok-failover.sh`): at ~8% quota, `fm-crew-switch.sh cursor composer-2.5 xhigh`.
- **Paused workers:** status line `paused: reason` — watcher should not treat as wedge (firstmate fix #6).

## Away mode (`/afk`)

Captain sleeps → firstmate finishes active lanes, merges on green, **no deploy** unless already authorised, writes checkpoint, minimises Claude wakes. Away-mode daemon triages routine wakes in bash; batches escalation ~30m.

## no-mistakes gates

```
  PR opened ──► axi run ──► review/fix/test agents ──► gate ref
                    ▲                              │
                    └──────── ask-user ────────────┘
```

- **ask-user** decisions surface to captain via firstmate; crew never asks captain directly.
- **Delivery modes:** `no-mistakes` (pipeline) vs `direct-PR` (crewmate opens PR, no pipeline)—brief declares mode.
- **Daemon:** one instance per machine; crew **never** `no-mistakes daemon restart`.

## Scouts vs ships

| | Scout | Ship |
|---|-------|------|
| Harness | Often Grok/Cursor scout profile | Cursor/Grok/Codex per dispatch |
| Writes | Report only (`data/<id>/report.md`) | Branch + PR |
| Teardown | After report + decisions | After merge + verify |
| Example | `astra-plan`, `harness-inventory` | `wave0-green-bar`, feature lanes |

## GNHF overnight

```
  fm-spawn (bash harness) ──► data/<task>/run.sh
                                    │
                                    ▼
                              gnhf loop + Prime/ACP
                                    │
                                    ▼
                         commits + push + status line
```

Use for long polish loops (e.g. design-review). Pitfalls: flash model context overflow, `extractLastJsonObject` wedge (patched locally), orphan Prime workers after SIGKILL (`prime-agent stop`).

## Command deck

Nine-pane Herdr workspace **COMMAND DECK**:

- Quota: `bash data/deck/quota.sh 60` → also `quota.line` on Claude statusline.
- Context: `bash data/deck/context.sh 30`.
- Rebuild: `~/mac-studio-setup/scripts/build-command-deck.sh`.

## Codex app (next front end)

16 Sep handover: captain moves interactive orchestration to **Codex desktop app** after in-flight lanes; firstmate repo documents Prime/Codex pipeline agents. Claude session remains for firstmate when captain chooses.

## Cursor as crew default (Sep 2026)

Crewmates in Cursor use **Composer 2.5** with rules/skills from `~/.cursor/rules` and global skills. Browser ops: **chrome-devtools-axi**; GitHub: **gh-axi**.

## Status protocol (crewmates)

Append one line to `state/<task>.status`:

- `working:` mid-phase (non-terminal)
- `done: PR <url>` when shipped
- `blocked:` / `needs-decision:` stop and wait
- `paused:` external wait (rate limit, captain sleep)
- `resolved:` closes a prior blocker key

Inbox: handle `state/<task>.inbox/*.msg` in order; `mv` to `handled/` to ack.
