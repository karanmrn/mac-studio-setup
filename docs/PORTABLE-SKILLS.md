# Preserve portable skills

The portable installer leaves existing skill directories and source locks intact.
It does not run `reinstall-skills.sh` or a whole catalog installation.
Firstmate's project skills arrive through its pinned source clone.

`config/skill-sources.txt` preserves the existing upstream source list.
`config/portable-skill-sources.json` records selected current source metadata without copying skill contents.
Folder hashes are provenance identifiers. They are not Git commit pins or download checksums.
Herdr and ASD-STE100 had no matching entry in the inspected source lock.
Their local skill copies are custom-source inputs that require a separate reviewed migration.
The portable guide includes the essential Herdr safety and plain-writing rules without installing those copies.

For a custom skill migration:

1. Identify its canonical source and resolve its symlinks.
2. Review its `SKILL.md` and helper files for credentials and machine paths.
3. Record the source repository and reviewed revision when they exist.
4. Compare the target skill before copying anything.
5. Back up a conflicting target and retain a restore manifest.
6. Copy only the selected reviewed skill and its required source files.
7. Preserve its source metadata without replacing the whole machine lock.

Do not copy generated discovery caches, plugin runtime files, duplicate catalogs, authentication files, or session evidence.
The older full-catalog script remains a separate Studio opt-in. It is not a custom-skill migration tool.
