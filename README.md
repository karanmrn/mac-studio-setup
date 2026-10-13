# Mac Studio and MacBook Air setup

This repository installs the portable Codex and Herdr workflow on Apple Silicon macOS.
The default uses GPT-6.1 Sol with high reasoning where the account supports it.
Firstmate remains the supervisor. Each worker uses an isolated worktree and its own delivery contract.

## Install from this private repository

The repository remains private. Authenticate once with an account that can read this repository and `karanmrn/firstmate`.
Install Homebrew through [the official Homebrew instructions](https://brew.sh) first.

1. Install GitHub CLI.

   ```bash
   brew install gh
   ```

2. Authenticate GitHub and configure its credential helper.

   ```bash
   gh auth login
   gh auth setup-git
   ```

3. Fetch the bootstrap at a reviewed commit.
   Replace `SOURCE_SHA` with the full source commit from the PR or the merged source.

   ```bash
   SOURCE_SHA=REVIEWED_40_CHARACTER_COMMIT
   gh api "repos/karanmrn/mac-studio-setup/contents/bootstrap.sh?ref=$SOURCE_SHA" \
     --header 'Accept: application/vnd.github.raw+json' > /tmp/mac-setup-bootstrap.sh
   bash /tmp/mac-setup-bootstrap.sh --ref "$SOURCE_SHA" --dry-run
   bash /tmp/mac-setup-bootstrap.sh --ref "$SOURCE_SHA"
   ```

4. Read the [workflow guide](docs/HOW-WE-WORK.md) for login, hook review, startup, and project registration.

The authenticated GitHub command replaces an anonymous curl command for private source.
The bootstrap verifies the Git checkout against the supplied commit.
No token appears in a clone URL or copied config.
Firstmate owns merge and publication of the stable install command.

You can also clone this repository, check out the reviewed commit, and run `bash install.sh`.
The bootstrap keeps each setup revision under `~/.local/share/mac-studio-setup/<commit>`.

## Repeat and upgrade

```bash
bash install.sh --dry-run
bash install.sh --config-only
bash install.sh --upgrade
bash install.sh --replace-config --dry-run
bash install.sh --replace-config
bash verify.sh
```

`--config-only` installs templates without packages or a Firstmate clone.
It supports isolated fixtures. It does not establish a complete working installation.
Existing configs remain intact unless you request `--replace-config`.
Each replacement has a timestamped backup under `~/.local/state/mac-studio-setup/backups`.
Linked parent directories cause a refusal. The installer never writes through another config owner's symlink.

`--upgrade` repeats the reviewed package pins. It does not run broad package updates or restart services.
Use a newer reviewed setup commit to change those pins.
An existing Firstmate clone at another revision requires its own update procedure.

## Portable core and optional services

The core installs Codex, Herdr, Treehouse, WezTerm, fonts, and the Firstmate command dependencies.
Node, Python, jq, and ripgrep use Homebrew's checked packages.
Codex and AXI packages use explicit npm versions and registry integrity verification.
Herdr and Treehouse use versioned release assets with pinned SHA-256 checksums.

The core requires GitHub access and a supported Codex login.
Other model providers, paid research services, runners, databases, and device rigs are optional.
The core does not install global skills packs, copy credentials, activate hooks, or start a daemon.
Use `--with-pipeline` to install the pinned no-mistakes binary when a project requires native pipeline delivery.
That option does not initialize a project or start the shared daemon.

The historical Studio bundle remains available through `bash install.sh --studio`.
It includes broad tools, project clones, and skill packs. Review it before use.
Its old dry-run and verification behavior do not carry the portable profile's guarantees.

## Documentation

| Guide | Contents |
| --- | --- |
| [Workflow](docs/HOW-WE-WORK.md) | Codex startup, workers, inboxes, validation, delivery, supervision |
| [Herdr](docs/HERDR.md) | Terminal presentation, keys, lifecycle isolation, reconnect |
| [Migration](docs/MIGRATION.md) | MacBook Air login and capacity checklist |
| [Firstmate](docs/FIRSTMATE.md) | Supervisor and worker boundaries |
| [Orchestration](docs/ORCHESTRATION.md) | Brief, spawn, status, guarded merge owners |
| [Provenance](docs/PORTABLE-PROVENANCE.md) | Source revisions, allowlisted fields, portable substitutions |
| [Validation](docs/PORTABLE-VALIDATION.md) | Reproduction, isolated tests, proof limits |
| [Skills](docs/PORTABLE-SKILLS.md) | Source metadata and custom skill preservation |
| [Updating](docs/UPDATING.md) | Portable updates and historical Studio updates |

The older inventory, subscriptions, secrets, panels, and `sol6.md` files are historical Studio references.
They do not define the portable install requirements.
