---
title: Module Metadata
description: Maintaining module metadata and ownership for the Azure Verified Modules (AVM) program
---

Maintain a module's details and ownership in `metadata.json` in its source repository. Submit changes through the [review process](#submit-and-review-a-change) below.

## Find the correct file

| Language | Root module metadata |
| --- | --- |
| Bicep | `avm/{res,ptn,utl}/{group}/{module}/metadata.json` in [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules). Use the existing module's actual path. |
| Terraform | `metadata.json` at the root of the module's own repository. Find that repository through the [module indexes]({{% siteparam base %}}/indexes/). |

Child modules have reduced `metadata.json` files in their own folders. They inherit ownership from the root module, including when nested more than one level deep. **Change owners only in the root file**; child files must not contain `owners`.

Use the existing file as your starting point and preserve unrelated values. If metadata or an assigned value is missing, ask the AVM core team to confirm the required values.

## Create metadata.json when scaffolding a new module

Every new Bicep or Terraform root module, and every new child module or submodule, **MUST** have a valid `metadata.json` created as part of scaffolding, not added later.

- **Root modules** get the full metadata shape, including the `owners` array.
- **Child modules and submodules** get the reduced, inherited-owner shape described above; they must not contain `owners`.

Use `Initialize-AvmModuleMetadata` from the [`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring) PowerShell module to scaffold the file for either ecosystem. It validates the supplied values against the versioned schema and writes `metadata.json` without overwriting an existing file. You must supply the approved values yourself; the command never infers or backfills them.

```pwsh
$metadata = @{
    moduleDisplayName = '<approved display name>'
    moduleDescription = '<approved description>'
    canonicalType     = '<approved ARM resource type or taxonomy>'
    owners            = @('<approved handle>')
}

Initialize-AvmModuleMetadata -Path . -InputObject $metadata -Ecosystem terraform -ModuleType resource -WhatIf
```

`-Ecosystem` (`bicep` or `terraform`) and `-ModuleType` (`resource`, `pattern`, or `utility`) are required. Add `-ChildModule` to scaffold the reduced, owner-less shape for a child module or submodule, omitting `owners` from the input. `-UpdateSource` applies matching Bicep source literals and is not valid for Terraform. Run with `-WhatIf` first to review the plan, then re-run without it to write the file.

Validate an existing file with `avm metadata validate`, or inspect one with `avm metadata show`.

Approved modules may carry `metadata.json` before their source exists. The catalog treats a metadata-only module as `Proposed` until it is published.

## Fields you can maintain

The versioned schema referenced by the required `$schema` URI defines the supported fields.

| Field | Guidance |
| --- | --- |
| `$schema` | Keep the required versioned schema URI. It identifies the module metadata schema. |
| `moduleDisplayName`, `moduleDescription` | Maintain the module's curated display name and description. For Bicep, `moduleDescription` must match the `metadata description` literal in `main.bicep`. `moduleDisplayName` is independent of the `metadata name` literal and does not have to match it. |
| `canonicalType` | The real ARM resource type, or the approved pattern/utility taxonomy. [Helper submodules](#helper-submodules) use `helper`. |
| `owners` | Root only: a flat array of strings containing every approved owner. Use bare GitHub handles for individuals and qualified handles such as `@Azure/team-name` for approved existing teams. |
| `telemetryIdPrefix` | Preserve the assigned identifier where required. New Bicep prefixes use `46d3xbcp.<kind>.<seven lowercase hexadecimal characters>` (20 characters), where `<kind>` is `res`, `ptn`, or `utl`; existing assigned Bicep identifiers remain valid until an approved replacement. Do not generate a replacement as part of an ownership or descriptive edit. |
| `alternativeTelemetryIdPrefixes` | For Bicep, retain all previously assigned prefixes here if the current prefix changes, in the same root or child `metadata.json`. These historical identifiers are not used in deployment names. |
| `alternativeNames`, `comments` | Optional root-module aliases and notes. These are public metadata. |

Pattern and utility `canonicalType` values can have one or more segments, such as `naming` for `avm-utl-naming`. Preserve the module's approved mapping. Resource modules and non-helper resource children use their actual ARM resource type.

Module identity and parent relationships come from the repository layout. Changing `moduleDisplayName` does not rename a module or move its repository.

### Helper submodules

Helper submodules use the exact `"canonicalType": "helper"` marker with the required `$schema`, `moduleDisplayName`, and `moduleDescription`. Ownership is inherited from the root. Use this marker only for helper children, not root modules or resource children.

Helper telemetry is optional; any supplied `telemetryIdPrefix` must pass validation. Helpers appear in the JSON catalog, not in the CSV indexes.

Terraform submodules are excluded from the CSV indexes entirely, not only helpers. Bicep child modules still have their own CSV rows, and the `ParentModule` column names the family root rather than the immediate parent.

## Submit and review a change

1. Agree the change with the current owners and the AVM core team. For ownership changes, retain the eligibility checks, incoming owners' written consent, and handover requirements in the [owner-change process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#changing-module-owners).
1. Edit the relevant `metadata.json` on a branch or in your fork of the module repository. Preserve all owners and other values that are not part of the agreed change.
1. Submit a pull request to that repository, linking the proposal or ownership-tracking issue when the process requires one. Describe the intended changes and request review from either [`@Azure/azure-verified-modules-engineering-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-engineering-owners) or [`@Azure/azure-verified-modules-module-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-module-owners).
1. Validate metadata using the repository's approved tooling and satisfy its required reviews before merging. Approval from an eligible member of **either** team satisfies metadata code-owner review; approval from both teams is **not** required. Being listed in the module's `owners` array does not by itself authorize someone to approve. Any code changes in the same pull request still need their normal code review and tests.
1. The next [scheduled catalog sync](#catalog-updates) publishes the merged metadata change. Do not edit the generated CSV or JSON output or request a separate index update.

**Metadata-only changes must not trigger a module release.** Do not change version files or create a release just to update owners or other metadata. A Bicep description correction may also require updating the `metadata description` literal in `main.bicep`; that is a source change and must follow normal validation and release rules, not be treated as metadata-only. Display names are independent of source literals and need no source change.

In [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules), the root `owners` array controls [reviewer notifications](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-pr-reviewer-routing.yml), including for child modules. It does not generate per-module [`CODEOWNERS` entries](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS) or require a module owner's approval for ordinary code changes. An ownerless module is routed to `@Azure/azure-verified-modules-module-owners` for review. The final `metadata.json` rule in `CODEOWNERS` still protects metadata changes with the two metadata code-owner teams; an eligible member of either team can approve.

Editing metadata does not grant or revoke repository permissions, create teams, change identities, or provision Azure access. Every incoming owner still needs the separate access approval described in [SNFR20]({{% siteparam base %}}/spec/SNFR20). Do not remove shared access solely because someone stops owning one module.

## Ownership changes

### Add, remove, or transfer owners

Update the `owners` array in the root metadata file. Add the approved incoming handles and remove only the departing handles. Keep every continuing individual or team owner.

For a direct transfer, follow [hot swapping module owners]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#hot-swapping-module-owners) and make the outgoing and incoming owner changes together, so the module does not pass through an unowned state. Do not reopen a closed module proposal.

### Orphan a module

Follow [when a module becomes orphaned]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned), including its tracking issue and triage steps.

In the root metadata file, set `"owners": []`, removing all individual and team handles from the array. Keep the remaining metadata intact. A published, non-deprecated module with no owners is shown as `Orphaned`. See [how module status is calculated](#module-status).

No `ORPHANED.md` file, manual `README.md` notice, or README regeneration is required for orphaning or adoption in either language. These are metadata-only ownership changes, not module releases.

### Adopt an orphaned module

Follow [when a new owner is identified]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified). After eligibility and consent are confirmed, add the approved incoming handles to the root metadata's `owners` array and obtain approval from either metadata code-owner team.

Complete the separate access approval before closing the ownership issue. Adding owners does not revive a deprecated module.

## Catalog updates

The catalog sync runs on a four-hourly schedule (01:33, 05:33, 09:33, 13:33, 17:33, and 21:33 UTC). Each scheduled run collects metadata from the module repositories, regenerates the six CSV indexes and `v1/modules.json`, and publishes them to the [module indexes and CSV downloads]({{% siteparam base %}}/indexes/) automatically. A merged metadata change therefore appears in the published index within about four hours, without a separate request to the AVM core team.

The generated outputs are not the source of truth. Propose corrections in the module's `metadata.json` rather than editing generated CSV or JSON files; the next scheduled run overwrites them. The AVM core team owns the [catalog tooling](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/module-catalog) and handles any run that is held back by a safeguard.

CSV owner columns show the first two individuals. Root metadata and the JSON catalog contain the full owner list.

### Module status

The catalog calculates `ModuleStatus` from evidence, not from an authored field. The first matching condition wins:

| Condition | Status |
| --- | --- |
| Deprecation evidence, or an existing `Deprecated` status in the CSV | `Deprecated` |
| Not published in the registry | `Proposed` |
| Published with no owners | `Orphaned` |
| Published with at least one owner | `Available` |

A module that is both deprecated and unpublished is omitted from the CSV indexes and `v1/modules.json` altogether, and the run warns that its unused source or repository can be deleted.

## Related processes

**New proposals:** Follow the [module proposal and approval process]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation). The approved name, description, and owners are agreed in the proposal issue. Once approved, `metadata.json` may be created before the module source exists; the module stays `Proposed` until it is published. Do not create metadata for a module that has not been approved.

**Publication:** Registry publication is required before a module is available. A metadata change does not publish a module.

**Deprecation:** Follow the [deprecation process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-deprecated), including approval, notices, and language-specific retirement steps. The catalog derives deprecation from Bicep's `DEPRECATED.md` or the Terraform repository's `archived` flag, not an authored metadata status.

A Bicep marker applies to its module and descendants, not its parent or siblings. Terraform archival applies to every module entry in that repository. Changing owners does not deprecate or reactivate a module. A module that is deprecated before it was ever published is removed from the indexes rather than listed as `Deprecated`.

**Bicep child publishing:** [Telemetry assignment and Microsoft Artifact Registry (MAR) approval]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing/#prerequisites) remain required. Recording metadata does not grant permission to publish a child module.
