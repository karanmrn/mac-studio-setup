# Agent instruction files — layering

How captain's machine wires **global** standards, **fleet** orchestration, and **project** rules. Sanitised copies live under `config/agents/` in this repo; live files stay in dotfiles and each git repo.

## Layer model

```
┌─────────────────────────────────────────────────────────────┐
│  Project (e.g. pubmax) — nested AGENTS.md per directory     │
│  Root index + area files; CLAUDE.md imports root only       │
└───────────────────────────┬─────────────────────────────────┘
                            │ nearest AGENTS.md wins for edits
┌───────────────────────────▼─────────────────────────────────┐
│  Fleet home (firstmate) — AGENTS.md = full job description  │
│  CLAUDE.md → @AGENTS.md import (edit AGENTS.md only)       │
└───────────────────────────┬─────────────────────────────────┘
                            │ crewmates read project + global
┌───────────────────────────▼─────────────────────────────────┐
│  Global — ~/.dotfiles-karan/home/.config/agents/AGENTS.md   │
│  Engineering bar, skill routing table, caveman style          │
└───────────────────────────┬─────────────────────────────────┘
                            │ symlinks (install.sh creates)
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
   ~/.codex/AGENTS.md   ~/.grok/AGENTS.md   ~/.config/opencode/AGENTS.md
   ~/.config/agents/AGENTS.md
        │
        ▼
   ~/.claude/CLAUDE.md  → same global file on this fleet (dotfiles)
```

**Caveman style** lives only in the global file: terse replies for chat, normal prose for code, commits, and PRs. Plugins **caveman@caveman** add harness integration; the policy text is in global `AGENTS.md`.

## Files on the reference Mac (Sep 2026)

| Path | Role |
|------|------|
| `~/.dotfiles-karan/home/.config/agents/AGENTS.md` | **Source of truth** for global standards |
| `~/.config/agents/AGENTS.md` | Symlink → dotfiles global file |
| `~/.codex/AGENTS.md` | Symlink → same |
| `~/.grok/AGENTS.md` | Symlink → same |
| `~/.config/opencode/AGENTS.md` | Symlink → same |
| `~/.claude/CLAUDE.md` | Symlink → same (Claude-only routing can diverge on other machines; here it matches global) |
| `~/karan-agent-workspace/AGENTS.md` | Firstmate orchestrator charter (~600 lines) |
| `~/karan-agent-workspace/CLAUDE.md` | `<!-- @AGENTS.md -->` pointer only |
| `~/Documents/projects/pubmaxx/AGENTS.md` | Pubmax root index (see below) |

Repo copies: `config/agents/global-AGENTS.md`, `config/agents/firstmate-CLAUDE.md`.

## Firstmate pointer pattern

Firstmate keeps **one** editable source:

- Edit `~/karan-agent-workspace/AGENTS.md` for orchestration law (spawn, merge, captain channel, secondmates).
- `CLAUDE.md` is a one-line import so Claude Code loads the same file. Never duplicate rules in `CLAUDE.md`.

This repo uses the same pattern: root `CLAUDE.md` imports `AGENTS.md`.

## Pubmax nested `AGENTS.md` (convention only)

Product rules are **not** copied into mac-studio-setup. Pubmax uses a **tree of area files**:

| File | Owns |
|------|------|
| `AGENTS.md` (repo root) | Index and fleet-wide laws |
| `app/AGENTS.md` | Routes, API, CSP |
| `components/AGENTS.md` | Map UI and chrome |
| `lib/AGENTS.md` | Policy leaves and stores |
| `lib/harvest/AGENTS.md` | Pointer into `scripts/` |
| `__tests__/AGENTS.md` | Unit harness and fences |
| `e2e/AGENTS.md` | Playwright |
| `scripts/AGENTS.md` | CLIs and deploy |
| `supabase/AGENTS.md` | Migrations and RLS |
| `ios/AGENTS.md` / `android/AGENTS.md` | Capacitor shells |
| `docs/AGENTS.md` | Copy and metrics language |
| `data/AGENTS.md` / `public/data/AGENTS.md` | Datasets |
| `perf/AGENTS.md` | Performance ceilings |

`CLAUDE.md` at pubmax root imports **only** root `AGENTS.md`. Tests enforce the tree (`agentsMdTree`, `agentsMdPointers`).

## mac-studio-setup project memory

This repo's `AGENTS.md` is **project memory** for bootstrap and migration (short, durable notes). It is not the global or firstmate charter.

## After clone on Mac Studio

1. Run `install.sh` (dotfiles + symlinks).
2. Confirm: `ls -la ~/.codex/AGENTS.md ~/.grok/AGENTS.md ~/.config/opencode/AGENTS.md`.
3. Open firstmate: `cd ~/karan-agent-workspace` and use Claude Code there.
4. Open pubmax in a worktree; read nearest `AGENTS.md` before editing.

Optional **nix** path: see [docs/KUNCHEN-STACK.md](KUNCHEN-STACK.md). Captain's dotfiles today are **git clone + install.sh** (`karan-herdr-shortcut-setup`), not full nix-darwin; Homebrew remains default.
