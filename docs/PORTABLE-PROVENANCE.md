# Portable source provenance

The capture date is 13 October 2026.
Source inspection used only workflow contracts, tool versions, model fields, terminal presentation, and selected skill-source metadata.
Live task state and private preferences did not enter the portable templates.

| Source | Revision or verified result | Portable use |
| --- | --- | --- |
| `karanmrn/mac-studio-setup` main | `2a2a0ac0ba708240a82da54fc571995b00868dfb` | Existing installer, verification, migration, and documentation structure |
| `karanmrn/firstmate` active tracked source | `ab8d03ad1360baf4edeed3a1c57867d2e8237092` | Reviewed clone pin and workflow owners |
| `karanmrn/karan-herdr-shortcut-setup` | `5ef6580d4b2f470ac1a34a8fa65d71526882de5b` | Resolved terminal owners and portable backend environment |
| Installed Codex | `0.162.1` | Supported CLI model, effort, approval, and hook flags |
| Codex config, allowlisted fields | `gpt-6.1-sol`, high reasoning | Portable model template |
| Codex account catalog, selected entry | GPT-6.1 Sol, high supported, 500,000 context | Account-scoped discovery. No capacity override in the template |
| Installed Herdr and isolated server | `0.9.3`, protocol 22 | Supported lifecycle and compatibility probe |
| Installed Treehouse | `3.1.1` | Reviewed worktree tool pin |
| Installed AXI package metadata | `gh-axi 0.1.38`, `tasks-axi 0.2.6`, `quota-axi 0.1.61`, `chrome-devtools-axi 0.1.40` | Explicit npm versions |

GitHub readback checked both pinned private source commits exist on their configured remotes.
The inspected Firstmate contract files had no tracked diff against the captured source commit.

## Source owners and substitutions

The Firstmate clone supplies these authoritative contracts:

- `AGENTS.md` and `docs/configuration.md` define roles and supported config files.
- `bin/fm-brief.sh`, `bin/fm-dod-lib.sh`, and `bin/fm-spawn.sh` define worker isolation and delivery.
- The Codex harness adapter documents model flags, effort overrides, skill syntax, and hook trust.
- `docs/supervision-protocols/codex.md` defines foreground checkpoints and durable wake acknowledgement.
- `bin/fm-pr-merge.sh` defines exact-head guarded merge and current check requirements.
- `docs/herdr-backend.md` and `bin/backends/herdr.sh` define supported session routing and client selection.

Source inspection resolved the live terminal symlinks before comparison.
The portable Herdr template preserves presentation fields and removes the project-specific workspace color rule.
The WezTerm template retains the inspected font, theme, padding, local keys, and opacity.
The backend environment preserves `FM_BACKEND=herdr` and resolves the workspace from the target user's home.
The model template omits the Studio's approval policy, sandbox policy, context overrides, and all trust state.
The optional pipeline example selects Codex and retains its existing validation and intent settings.
The global instruction template replaces its obsolete caveman section with the current plain-writing rules.
The portable installer copies neither template automatically.

| Machine-specific source | Portable substitution |
| --- | --- |
| Absolute Studio home | Target `$HOME` |
| Active Firstmate checkout | `$FM_HOME`, defaulting to `$HOME/karan-agent-workspace` |
| Dotfiles-owned shell file | `~/.config/mac-studio-setup/fleet-env.zsh`, sourced explicitly |
| Project labels, checkout paths, pane IDs | New Firstmate project registration and runtime discovery |
| Fleet concurrency | One supervisor, one worker, one build as an operator policy |
| Provider credentials and auth caches | New machine's supported interactive login |

## Download integrity

`config/portable-versions.sh` owns release URLs, versions, and SHA-256 pins.
GitHub release readback supplied the published digest for each binary asset.
The pinned sources are the official Herdr, Treehouse, and no-mistakes release repositories.
Git source clones check their checked-out commit before use.
Npm installs explicit versions from `registry.npmjs.org` with registry tarball integrity checks.
Homebrew resolves formula revisions through its signed API metadata and package checksums.
Homebrew prerequisites remain package-managed rather than byte-for-byte copies of the Studio.

No credential, auth store, environment secret, private task state, session ID, passcode, log, database, evidence file, or project data is a template input.
