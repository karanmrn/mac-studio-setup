# Portable orchestration owners

The setup uses the existing Firstmate implementation at the revision in `config/portable-versions.sh`.
It does not create another workflow controller.

| Mechanic | Tracked Firstmate owner |
| --- | --- |
| Startup lock, diagnostics, recovery | `bin/fm-session-start.sh` |
| Task brief and delivery contract | `bin/fm-brief.sh`, `bin/fm-dod-lib.sh` |
| Isolated worker launch | `bin/fm-spawn.sh`, `bin/fm-harness.sh` |
| Codex model and effort conventions | `.agents/skills/harness-adapters/references/harness/codex.md` |
| Herdr runtime and explicit session routing | `bin/backends/herdr.sh`, `docs/herdr-backend.md` |
| Inbox, steering, task status | `bin/fm-inbox.sh`, `bin/fm-send.sh`, generated task brief |
| Native pipeline custody | `bin/fm-nm-run-lib.sh`, project delivery instructions |
| PR checks and guarded merge | `bin/fm-pr-check.sh`, `bin/fm-pr-merge.sh` |
| Codex foreground supervision | `docs/supervision-protocols/codex.md`, `bin/fm-watch-checkpoint.sh` |
| Named Herdr laboratory | `bin/fm-herdr-lab.sh` |

The [workflow guide](HOW-WE-WORK.md) explains their sequence and authority boundaries.
Optional secondmates, remote relay, runners, and paid providers require separate operator setup.
