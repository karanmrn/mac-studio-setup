# Update the portable setup

Portable updates repeat reviewed pins. They do not restart Herdr or a shared pipeline daemon.

1. Fetch the new reviewed setup commit from Firstmate.
2. Fetch its bootstrap with the authenticated command in the README.
3. Run that bootstrap with `--ref <commit> --dry-run --upgrade`.
4. Stop local workers and builds before installing changed tools.
5. Run the bootstrap with `--ref <commit> --upgrade`.
6. Run `verify.sh` from that setup revision.
7. Review any new or changed hooks through Codex before starting supervision.

Existing configs remain intact unless you pass `--replace-config`.
Review the diff before requesting replacement.
The installer preserves Firstmate clones at another revision and refuses to update them implicitly.
Use the clone's owned `bin/fm-update.sh` procedure when its current contract permits the update.

Existing custom skills remain intact. The portable installer does not run the full catalog updater.
See [skill preservation](PORTABLE-SKILLS.md) for source metadata.

`scripts/update-all.sh` repeats the portable upgrade procedure.
`scripts/update-all.sh --studio` selects the historical broad updater.
That updater is separate from the portable guarantees. Never run it while shared work is active.
