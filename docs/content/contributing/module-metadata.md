---
title: Module Metadata
description: Maintaining module metadata and ownership for the Azure Verified Modules (AVM) program
---

Module metadata describes a module and records its owners. This page explains how to propose changes in the module's source repository instead of editing a central spreadsheet or module-index CSV.

{{% notice style="important" title="Rollout pending" %}}
This process is being introduced; it is not yet the default maintenance process. Use it only after the AVM core team confirms that metadata files, engineering-owner review protection, and catalog publication are ready for your module. Until then, coordinate changes with the core team through the existing process. See [rollout and publication](#rollout-and-publication) before expecting an index update.
{{% /notice %}}

## Find the correct file

| Language | Root module metadata |
| --- | --- |
| Bicep | `avm/{res,ptn,utl}/{group}/{module}/metadata.json` in [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules). Use the existing module's actual path. |
| Terraform | `metadata.json` at the root of the module's own repository. Find that repository through the [module indexes]({{% siteparam base %}}/indexes/). |

Child modules have reduced `metadata.json` files in their own folders. They inherit ownership from the root module, including when nested more than one level deep. **Change owners only in the root file**; child files must not contain `owners`.

Use the existing file as your starting point and preserve unrelated values. Migration backfill creates missing metadata; it does not overwrite existing files or apply later ownership changes. If metadata is missing, ask the AVM core team to confirm the module's readiness rather than inventing values.

## Fields you can maintain

The versioned schema referenced by the required `$schema` URI defines the supported fields.

| Field | Guidance |
| --- | --- |
| `$schema` | Keep the required versioned schema URI. It identifies the module metadata schema. |
| `moduleDisplayName`, `moduleDescription` | Maintain the module's display name and description. For Bicep, they must match the corresponding literals in `main.bicep`. |
| `canonicalType` | The ARM resource type, or the approved pattern/utility taxonomy. This is not the module's repository path. |
| `owners` | Root only: a flat array of strings. Use bare GitHub handles for individuals and qualified handles such as `@Azure/team-name` for approved existing teams. Record every owner, not just the first two. Do not put display names or nested objects in this array. |
| `telemetryIdPrefix` | Preserve the assigned identifier where required. Do not generate a replacement identifier as part of an ownership or descriptive edit. |
| `alternativeNames`, `comments` | Optional root-module aliases and notes. These are public metadata. |

Module identity, module class, repository paths, and parent relationships are derived from the repository. Do not add fields for them to `metadata.json`. In particular, `moduleDisplayName` is not a way to rename a module or move its repository.

There is **no `moduleStatus` or `status` field** in this schema. Follow the existing [proposal and lifecycle processes](#processes-that-remain-separate) rather than adding an unsupported field.

## Submit and review a change

1. Agree the change with the current owners and the AVM core team. For ownership changes, retain the eligibility checks, incoming owners' written consent, and handover requirements in the [owner-change process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#changing-module-owners).
1. Edit the relevant `metadata.json` on a branch or in your fork of the module repository. Preserve all owners and other values that are not part of the agreed change.
1. Submit a pull request to that repository, linking the proposal or ownership-tracking issue when the process requires one. Describe the intended changes and request review from [`@Azure/azure-verified-modules-engineering-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-engineering-owners).
1. Satisfy the repository's metadata validation and required reviews before merging. Engineering-owner approval is required for metadata changes; another module owner's approval does not replace it. Any code changes in the same pull request still need their normal code review and tests.
1. Follow the change through catalog generation and reviewed publication. Do not edit the generated CSV or JSON output to duplicate the metadata change.

**Metadata-only changes must not trigger a module release.** Do not change version files or create a release just to update owners or other metadata. A Bicep name or description correction may also require changing `main.bicep` to keep its literals consistent; that is a source change and must follow normal validation and release rules, not be treated as metadata-only.

Editing metadata does not grant or revoke repository permissions, create teams, change identities, or provision Azure access. Every incoming owner still needs the separate access approval described in [SNFR20]({{% siteparam base %}}/spec/SNFR20). Do not remove shared access solely because someone stops owning one module.

## Ownership changes

### Add, remove, or transfer owners

Update the `owners` array in the root metadata file. Add the approved incoming handles and remove only the departing handles. Keep every continuing individual or team owner, including owners beyond the first two. Remove a team handle only if that team no longer owns the module. Do not invent a replacement team or recreate a legacy per-module team.

For a direct transfer, follow [hot swapping module owners]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#hot-swapping-module-owners) and make the outgoing and incoming owner changes together, so the module does not pass through an unowned state. Do not reopen a closed module proposal.

### Orphan a module

Follow [when a module becomes orphaned]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned), including its tracking issue and required notices.

In the root metadata file, set `"owners": []`, removing all individual and team handles from the array. Keep the remaining metadata intact. The catalog calculates `Orphaned` when no owner exists, while preserving an existing `Deprecated` status.

### Adopt an orphaned module

Follow [when a new owner is identified]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified). After eligibility and consent are confirmed, add the approved incoming handles to the root metadata's `owners` array and obtain engineering-owner review.

Complete the separate access approval and notice-removal steps before closing the ownership issue. Adding owners does not revive a deprecated module.

## Rollout and publication

Metadata changes reach the public indexes through catalog generation and reviewed publication, not immediately when an owner confirms a change or a metadata pull request is merged.

During preview, catalog generation writes `test-*.csv` files beside the unchanged canonical CSVs and writes the JSON catalog at its normal `v1/modules.json` path. Replacing the canonical CSVs is a **separate future change**. Continue to use the existing [CSV downloads and module indexes]({{% siteparam base %}}/indexes/) until that changeover is approved.

The compatibility CSVs expose only the first two individual owners in their primary and secondary owner columns. The root metadata and richer JSON catalog retain all owners; do not remove owners to fit the CSV columns.

Do not assume that a preview publication updates the live website, issue routing, or `CODEOWNERS`. The AVM core team must confirm the relevant publication and synchronization have completed before relying on those consumers.

## Processes that remain separate

**New proposals:** Keep using the [module proposal and approval process]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation), including repository creation and any required registry approval. Proposals without a repository or module source have no metadata file to edit. Their existing core-team-managed records remain part of the transition until a replacement is agreed; do not create placeholder metadata or discard proposed entries.

**Publication:** Registry publication is still required before a module is available. A metadata change does not publish a module.

**Deprecation:** Follow the [deprecation process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-deprecated), including its approval, notices, and language-specific retirement steps. After adoption, the catalog derives `Deprecated` from the existing `DEPRECATED.md` file for Bicep or the repository's `archived` flag for Terraform. Review the generated catalog update rather than editing an index status.

A Bicep `DEPRECATED.md` marker applies to its module and descendants: a root marker covers all children, while a child marker does not deprecate its parent or siblings. Terraform repository archival applies to every module entry in that repository. Existing `Deprecated` entries remain deprecated during the transition; a missing signal does not reactivate them. The v1 metadata schema has no lifecycle or status field, and clearing owners is not a substitute for deprecation.

**Bicep child publishing:** [Telemetry assignment and Microsoft Artifact Registry (MAR) approval]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing/#prerequisites) remain required. Recording metadata does not grant permission to publish a child module.
