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

## Fields you can maintain

The versioned schema referenced by the required `$schema` URI defines the supported fields.

| Field | Guidance |
| --- | --- |
| `$schema` | Keep the required versioned schema URI. It identifies the module metadata schema. |
| `moduleDisplayName`, `moduleDescription` | Maintain the module's display name and description. For Bicep, they must match the corresponding literals in `main.bicep`. |
| `canonicalType` | The real ARM resource type, or the approved pattern/utility taxonomy. [Helper submodules](#helper-submodules) use `helper`. |
| `owners` | Root only: a flat array of strings containing every approved owner. Use bare GitHub handles for individuals and qualified handles such as `@Azure/team-name` for approved existing teams. |
| `telemetryIdPrefix` | Preserve the assigned identifier where required. Do not generate a replacement identifier as part of an ownership or descriptive edit. |
| `alternativeNames`, `comments` | Optional root-module aliases and notes. These are public metadata. |

Pattern and utility `canonicalType` values can have one or more segments, such as `naming` for `avm-utl-naming`. Preserve the module's approved mapping. Resource modules and non-helper resource children use their actual ARM resource type.

Module identity and parent relationships come from the repository layout. Changing `moduleDisplayName` does not rename a module or move its repository.

### Helper submodules

Helper submodules use the exact `"canonicalType": "helper"` marker with the required `$schema`, `moduleDisplayName`, and `moduleDescription`. Ownership is inherited from the root. Use this marker only for helper children, not root modules or resource children.

Helper telemetry is optional; any supplied `telemetryIdPrefix` must pass validation. Helpers appear in the JSON catalog, not in CSV outputs.

## Submit and review a change

1. Agree the change with the current owners and the AVM core team. For ownership changes, retain the eligibility checks, incoming owners' written consent, and handover requirements in the [owner-change process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#changing-module-owners).
1. Edit the relevant `metadata.json` on a branch or in your fork of the module repository. Preserve all owners and other values that are not part of the agreed change.
1. Submit a pull request to that repository, linking the proposal or ownership-tracking issue when the process requires one. Describe the intended changes and request review from either [`@Azure/azure-verified-modules-engineering-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-engineering-owners) or [`@Azure/azure-verified-modules-module-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-module-owners).
1. Validate metadata using the repository's approved tooling and satisfy its required reviews before merging. Approval from an eligible member of **either** team satisfies metadata code-owner review; approval from both teams is **not** required. Being listed in the module's `owners` array does not by itself authorize someone to approve. Any code changes in the same pull request still need their normal code review and tests.
1. Follow the change through catalog generation and reviewed publication. Do not edit the generated CSV or JSON output to duplicate the metadata change.

**Metadata-only changes must not trigger a module release.** Do not change version files or create a release just to update owners or other metadata. A Bicep name or description correction may also require changing `main.bicep` to keep its literals consistent; that is a source change and must follow normal validation and release rules, not be treated as metadata-only.

Editing metadata does not grant or revoke repository permissions, create teams, change identities, or provision Azure access. Every incoming owner still needs the separate access approval described in [SNFR20]({{% siteparam base %}}/spec/SNFR20). Do not remove shared access solely because someone stops owning one module.

## Ownership changes

### Add, remove, or transfer owners

Update the `owners` array in the root metadata file. Add the approved incoming handles and remove only the departing handles. Keep every continuing individual or team owner.

For a direct transfer, follow [hot swapping module owners]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#hot-swapping-module-owners) and make the outgoing and incoming owner changes together, so the module does not pass through an unowned state. Do not reopen a closed module proposal.

### Orphan a module

Follow [when a module becomes orphaned]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned), including its tracking issue and required notices.

In the root metadata file, set `"owners": []`, removing all individual and team handles from the array. Keep the remaining metadata intact. The catalog calculates `Orphaned` when no owner exists, while preserving an existing `Deprecated` status.

### Adopt an orphaned module

Follow [when a new owner is identified]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified). After eligibility and consent are confirmed, add the approved incoming handles to the root metadata's `owners` array and obtain approval from either metadata code-owner team.

Complete the separate access approval and notice-removal steps before closing the ownership issue. Adding owners does not revive a deprecated module.

## Catalog updates

Catalog generation and reviewed publication carry metadata changes to the [module indexes and CSV downloads]({{% siteparam base %}}/indexes/). Merging metadata does not immediately update those outputs. The AVM core team manages publication using the [catalog tooling](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/module-catalog).

CSV owner columns show the first two individuals. Root metadata and the JSON catalog contain the full owner list. Propose corrections in the module's metadata rather than editing generated outputs.

## Related processes

**New proposals:** Follow the [module proposal and approval process]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation). Keep approved details in the proposal issue until the repository and module source exist; do not create placeholder metadata.

**Publication:** Registry publication is required before a module is available. A metadata change does not publish a module.

**Deprecation:** Follow the [deprecation process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-deprecated), including approval, notices, and language-specific retirement steps. The catalog derives deprecation from Bicep's `DEPRECATED.md` or the Terraform repository's `archived` flag, not an authored metadata status.

A Bicep marker applies to its module and descendants, not its parent or siblings. Terraform archival applies to every module entry in that repository. Changing owners does not deprecate or reactivate a module.

**Bicep child publishing:** [Telemetry assignment and Microsoft Artifact Registry (MAR) approval]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing/#prerequisites) remain required. Recording metadata does not grant permission to publish a child module.
