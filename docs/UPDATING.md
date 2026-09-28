# Updating the fleet

Captain routine (from `data/learnings.md` and `data/deck/update-all.sh`): **daily ~06:30** via launchd on the MacBook, or manual on the studio:

```bash
~/mac-studio-setup/scripts/update-all.sh
```

Log: `~/karan-agent-workspace/data/deck/update-all.log` (created on first run).

## What update-all.sh does

| Step | Command | Notes |
|------|---------|-------|
| Homebrew | `brew update && brew upgrade` | Claude cask, herdr, gh, bun, uv, fonts, Ghostty, etc. |
| npm globals | `npm update -g` | codex, pi, *-axi, gnhf, prime-agent, gitnexus, skills CLI |
| Self-updaters | `grok update`, `cursor-agent update`, `no-mistakes update`, `vp upgrade` | See defer rules below |
| skills.sh | `npx -y skills@latest update -g -y` | All packs in `~/.agents/.skill-lock.json` |
| gstack | Compare `VERSION` to GitHub; re-clone + `./setup` if behind | Needs **bun** |
| Claude plugins | `claude plugin update` per installed plugin | caveman, codex, typesafe, … |
| firstmate | `~/karan-agent-workspace/bin/fm-update.sh` | Fast-forward only |
| versions | Prints CLI versions | For morning report |

**PATH:** script prepends vite-plus node, `~/.local/bin`, `~/.no-mistakes/bin`, Homebrew, Grok.

## Safe while workers are running

- `brew upgrade` for non-herdr formulae/casks
- `npm update -g` **except** `prime-agent` if GNHF/Prime lanes active
- `cursor-agent update`, `grok update`, `vp upgrade`
- `treehouse update` (if installed)
- `npx skills update -g`
- `claude plugin update` (does not kill workers)
- `bin/fm-update.sh` (firstmate scripts only)

## Defer until fleet idle

| Tool | Why |
|------|-----|
| `no-mistakes update` | Rewrites launchd plist; restart kills in-flight pipelines |
| `no-mistakes daemon restart` | Same; captain/firstmate only |
| `brew upgrade herdr` | Live panes tied to running binary |
| `npm i -g prime-agent@latest` | Running Prime workers |
| Full `brew upgrade` touching **claude** cask | Can quarantine/hang new CLI (see learnings 15 Sep) |

## Manual pieces not in update-all

| Item | Command |
|------|---------|
| Full skill reinstall | `~/mac-studio-setup/scripts/reinstall-skills.sh` |
| Dotfiles | `cd ~/.dotfiles-karan && git pull && ./install.sh` |
| Nix (optional) | `cd ~/.dotfiles && ./rebuild.sh` per [KUNCHEN-STACK.md](KUNCHEN-STACK.md) |
| Playwright browsers | `npx playwright install chromium` in pubmax when cache missing |
| Runner binaries | Re-run `scripts/install-runners.sh` after runner package bump |

## npm note

npm 12 may skip install scripts; if a global package fails postinstall, rerun with `--allow-scripts=` for that package.

## After ECC / gstack plugin updates

- Re-apply minimal ECC `setup.json` if GateGuard profile was customised (see learnings 16 Sep).
- Re-run gstack `./setup` after re-clone to refresh symlinks into `~/.claude/skills`.

## Reporting

Firstmate summarises `update-all.log` in the morning message: what version changed, any failed step, whether gstack or skills bumped.

## Mac Studio

Same script; ensure `FM_HOME` points at `~/karan-agent-workspace` and launchd job is re-created if you want 06:30 automatic runs (job lives in captain dotfiles, not this repo).
