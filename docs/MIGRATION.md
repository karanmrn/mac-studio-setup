# Install on a MacBook Air

This checklist applies to Apple Silicon MacBook Air models.
The source install and its validation do not prove a physical MacBook Air installation.

1. Install Homebrew through its official instructions.
2. Authenticate GitHub with `gh auth login` and `gh auth setup-git`.
3. Confirm access to both private source repositories named in the README.
4. Run the reviewed bootstrap from the [README](../README.md).
5. Authenticate Codex locally with `codex login`.
6. Load `~/.config/mac-studio-setup/fleet-env.zsh` in the terminal shell.
7. Open Herdr and launch `fm` in its pane.
8. Review repository trust and the Firstmate hooks through Codex's supported prompt.
9. Confirm the model and reasoning level in `/model`.
10. Register project clones with Firstmate on this machine.
11. Use one worker and one build at a time until memory measurements justify more.
12. Run the portable `verify.sh` from the installed setup revision.

Credentials stay in the new machine's supported login stores.
Do not copy old authentication stores, hook-trust records, sessions, application databases, logs, or project data.
The core has no requirement for Cursor, Claude, Grok, research subscriptions, runners, or a device rig.
Review and install those separately only when required.

The installer preserves existing configs. Explicit replacement creates a timestamped backup.
If a config parent is a symlink, resolve ownership before retrying.
Identify the contents and intended owner before removing a migrated Nix link.

For reconnect procedures, read [Herdr](HERDR.md).
The historical Studio scripts remain available with `--studio` and retain their separate requirements.
