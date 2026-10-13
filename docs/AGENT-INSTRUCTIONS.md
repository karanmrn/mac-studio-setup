# Agent instruction files

Read the [agent handover](AGENT-HANDOVER.md) for the reading order and accepted bootstrap.
The [complete global template](../config/agents/global-AGENTS.md) owns engineering standards and skill routing.
The [pinned Firstmate charter](https://github.com/karanmrn/firstmate/blob/ab8d03ad1360baf4edeed3a1c57867d2e8237092/AGENTS.md) owns supervisor behavior.
Each project's own `AGENTS.md` owns its project rules.

## Keep the instruction layers separate

| Layer | Source and scope |
| --- | --- |
| Global | The reference source is `~/.dotfiles-karan/home/.config/agents/AGENTS.md`. Codex, Grok, and opencode share it through symlinks. |
| Claude global | `~/.claude/CLAUDE.md` is a separate file with Claude-only skill routing and mirrored engineering standards. |
| Firstmate home | `$FM_HOME/AGENTS.md` is the fleet charter. `$FM_HOME/CLAUDE.md` imports that charter with `@AGENTS.md`. |
| Project | Read the root `AGENTS.md` and each nearer applicable `AGENTS.md` before editing that directory. |
| Worker task | The generated launch brief sets the worker role, exact worktree, steering inbox, validation, and delivery contract. |

Claude's global file and Firstmate's local import have different roles.
Do not replace Claude's separate global file with a symlink to the shared global instructions.
The [Firstmate import template](../config/agents/firstmate-CLAUDE.md) contains the local import pattern.
A worker in a Firstmate worktree follows its launch brief's worker identity rather than becoming a supervisor.

## Use the current writing standard

Simplified Technical English replaces the previous caveman style.
Read `~/.codex/skills/asd-ste100/SKILL.md` before applying the skill to plans, updates, instructions, or reports.
The global template gives the complete plain-writing rules and missing-skill procedure.
The portable installer does not install that optional custom skill or a global skill collection.
The [portable skills guide](PORTABLE-SKILLS.md) explains reviewed migration and preservation.
Do not infer skill availability from a template reference.

## Apply the templates deliberately

The portable installer copies neither instruction template automatically.
It does not run the reference dotfiles installer or create global instruction symlinks.
Review the complete global template against the new machine's actual instruction files before an operator-approved application.
Preserve Claude-only routing in Claude's separate file.
Firstmate's pinned clone supplies its tracked charter and project skills.
Use the actual local contracts after an approved source update.
The [provenance guide](PORTABLE-PROVENANCE.md) records template sources and portable substitutions.

## Read project rules at the edit location

This setup repository's [AGENTS.md](../AGENTS.md) is project memory for bootstrap and migration.
It is not the global standards file or the Firstmate charter.
Another registered project supplies its own root and nested instruction files.
Do not copy another project's instructions into this repository or assume a particular nested layout.
Read that project's actual `CLAUDE.md` imports when using Claude Code.
