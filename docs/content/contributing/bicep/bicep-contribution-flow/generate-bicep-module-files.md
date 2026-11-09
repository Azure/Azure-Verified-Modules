---
title: Initialize and Update Bicep Module Files
linktitle: Update Module Files
description: Initialize and update Bicep module files with Avm.Authoring
---

Use [`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring) for local Bicep authoring. Install and import it as described in the [Bicep prerequisites]({{% siteparam base %}}/contributing/bicep/prerequisites/). Run the commands below from the root of your [Bicep registry](https://github.com/Azure/bicep-registry-modules) checkout, replacing paths and metadata values with approved ones.

## Initialize a new module once

For an approved resource module, set its target directory and run:

```powershell
$modulePath = 'avm/res/<approved group>/<approved module>'
avm init -Ecosystem bicep -ModuleType resource -Path $modulePath
```

In an interactive terminal, `avm init` prompts for missing approved display name, description, resource type, and owners. For unattended use, supply the required values with `-InputObject`; it will not guess missing values. It creates the module and provider directories if necessary, generates and validates `metadata.json` with a unique telemetry prefix for this resource module, and scaffolds `main.bicep`, `version.json`, `CHANGELOG.md`, and root `tests/e2e` Bicep files. It does not create a repository workflow or overwrite existing files. Use `-ModuleType pattern` or `utility` for an approved module of that kind; a utility that deploys no resources does not need telemetry.

To add a child module, run `avm init` with `-ChildModule` and the approved child path. Children inherit root ownership, so their metadata omits `owners`. Full initialization also creates any missing ancestors; see the [metadata rules]({{% siteparam base %}}/contributing/module-metadata/) for child modules.

If you only need to record an approved proposal **before** authoring `main.bicep`, use [`avm init -Proposed`]({{% siteparam base %}}/contributing/module-metadata/#create-only-metadata-for-an-approved-bicep-proposal) instead. Later, run full `avm init` on the same path to scaffold the remaining files; it preserves the existing metadata.

## Update generated files after editing

After implementing `main.bicep` and the end-to-end tests, run the repeatable local workflow:

```powershell
avm pre-commit -Ecosystem bicep -Path $modulePath
```

`avm pre-commit` validates metadata, formats and lints Bicep, checks that it builds, compiles each `main.bicep` into `main.json`, and generates `README.md`. It processes the root and its child modules without a `-Recurse` switch. Review and commit the generated changes. Run it again after later source or test changes; unlike `avm init`, it is intended to be repeatable. Do not run it on a metadata-only proposed module before its source exists.

To regenerate only the README from Bicep source and end-to-end examples, run:

```powershell
avm docs -Ecosystem bicep -Path $modulePath
```

This checkout's `bicepconfig.json` references its tracked, versioned README template. `avm docs` does not scaffold source files or compile `main.json`; use `avm pre-commit` for those tasks. For a module with an existing hand-written `## Notes` section in `README.md` but no `README.notes.md`, first extract the Notes once:

```powershell
avm docs export-notes -Path $modulePath
avm pre-commit -Ecosystem bicep -Path $modulePath
```

Run `avm docs export-notes` separately for each existing child README with authored Notes, using that child's path, before running `avm pre-commit` on the root. Commit the resulting `README.notes.md` files alongside regenerated READMEs. Keep authored Notes in the sidecar thereafter; the generator **does not** copy them from an existing README. Existing images referenced by Notes belong in the module's `src` directory. Source descriptions and parameter decorators supply the other generated README text; edit those rather than hand-editing generated sections.
