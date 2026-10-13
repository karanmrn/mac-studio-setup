# Portable validation and readback

Validation uses this task's isolated worktree and temporary homes.
It does not establish a physical MacBook Air install or an authenticated new-machine model session.

## Before and after

Source validation reproduced the original installer with `INSTALL_DRY_RUN=1` in an isolated home.
Its dry run created home directories and runtime files during command discovery.
It also selected unrelated provider installs, project clones, and the full skills catalog.
The new default selects the portable Codex and Herdr core.
Its dry run performs no package install, config copy, bootstrap clone, or persistent workflow mutation.

The first test mistakenly passed `--dry-run` to the historical installer, which ignored that flag.
The test stopped during Homebrew metadata download. The output showed no completed package installation.
The new entrypoint handles the flag explicitly.
The historical Studio profile remains a separate opt-in with its documented legacy limits.

The corrected fixtures warm macOS's Python launcher before capturing the runtime-created baseline.
The tests compare every subsequent home path, file, symlink, and directory against that baseline.
An injected installer-created directory still fails the same assertion.
This baseline does not permit installer writes or ignore unexpected home changes.

## Installer and bootstrap checks

Run these checks from the source checkout:

```bash
python3 tests/portable-install.test.py
bash tests/portable-install.test.sh
```

The Python suite contains 13 passing tests.
It covers these public behaviors:

- Dry run preserves the home baseline and never calls package or network installers.
- An injected installer write fails the strict dry-run assertion.
- First installation and repeat installation preserve the expected files.
- Conflicting configs remain intact until explicit replacement creates a backup.
- Symlink replacement preserves its original target and backs up the link node.
- Linked config parents cause a refusal.
- Corrupted downloads fail before binary installation.
- Failed authentication precedes package changes.
- An existing Firstmate revision remains intact.
- Native pipeline installation requires its explicit option and starts no daemon.
- Binary upgrades preserve the conflicting binary in a backup.
- The authenticated bootstrap verifies its revision, repeats safely, and refuses dirty cached source.
- The bootstrap refuses non-commit refs and performs an empty dry run.

Package managers, authentication, Git clone boundaries, and downloads use isolated fixtures.
The tests execute the actual entrypoints and file operations.
A full-bootstrap test found and corrected the macOS Bash 3.2 empty-array error before publication.

Shell syntax checks passed for the installer, bootstrap, verification, update, and test scripts.
ShellCheck passed for the changed scripts, including the preserved Studio entrypoints.
The portable environment passed `zsh -n`.
`git diff --check` passed.

## Release integrity checks

Source validation downloaded the versioned Herdr, Treehouse, and optional no-mistakes assets into the task worktree.
All three SHA-256 values matched the published release digests and the portable pin file.
The tar archives contained the expected single binary members.
The checks did not install these downloads into the host or run a package upgrade.

## Herdr and Codex proof

The test uses only the named-session helper specified by the task.
It provisions a non-default lab, starts its owned foreground viewer, and obtains pane IDs from API responses.
One combined EXIT cleanup calls the helper teardown and checks the unchanged default-session tripwire.

Run this test only with the reviewed helper from the Firstmate clone:

```bash
HERDR_LAB_HELPER="$FM_HOME/bin/fm-herdr-lab.sh" bash tests/herdr-workflow.test.sh
```

Herdr 0.9.3 reported a compatible 0.9.3 server with protocol 22 in the lab.
The command probe uses a temporary home and Codex home. It copies no authentication or trust state.
It executes the installed Codex CLI version and help with the selected model and reasoning flags inside a Herdr pane.
It checks independent file receipts, exact generated terminal output, pane close, and helper teardown.
It does not start an authenticated model turn or a Firstmate supervisor.

The earlier anchored-output test exposed a test-command quoting error.
Herdr 0.9.3 joins `pane run` arguments into shell text.
Passing a printf format as a separate argv value removed the shell quotes and printed an extra literal `n`.
The corrected test passes one quoted shell command string.
Its negative check proves the old form fails the exact-line contract.
Its output marker is absent from the injected command text, so command echo cannot satisfy the proof.
This correction preserves the exact-output assertion rather than accepting different terminal formatting.

## Remaining operator prerequisites

Install Homebrew and authenticate GitHub with access to both private repositories.
Configure Git's supported credential helper with `gh auth setup-git`.
Authenticate Codex locally and check GPT-6.1 Sol plus high reasoning in the account's model picker.
Review Firstmate repository trust and hooks through Codex's supported prompt.
Register projects and enforce one worker and one build until MacBook Air memory measurements justify more.

The checks do not establish a physical MacBook Air install or new-account login.
They do not establish terminal visual review, production deployment, or native device proof.
The source PR remains the publication boundary. Firstmate owns merge and the final stable install command.
