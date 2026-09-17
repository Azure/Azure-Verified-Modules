---
title: Module Metadata
description: Maintaining module metadata and ownership for the Azure Verified Modules (AVM) program
---

Module metadata describes a module and records its owners. This page explains how to propose changes in the module's source repository instead of editing a central spreadsheet or module-index CSV.

{{% notice style="important" title="Rollout pending" %}}
This process is being introduced; it is not yet the default maintenance process. Use it only after the AVM core team confirms that metadata files, metadata code-owner review protection, and catalog publication are ready for your module. Until then, coordinate changes with the core team through the existing process. See [rollout and publication](#rollout-and-publication) before expecting an index update.
{{% /notice %}}

## Find the correct file

| Language | Root module metadata |
| --- | --- |
| Bicep | `avm/{res,ptn,utl}/{group}/{module}/metadata.json` in [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules). Use the existing module's actual path. |
| Terraform | `metadata.json` at the root of the module's own repository. Find that repository through the [module indexes]({{% siteparam base %}}/indexes/). |

Child modules have reduced `metadata.json` files in their own folders. They inherit ownership from the root module, including when nested more than one level deep. **Change owners only in the root file**; child files must not contain `owners`.

Use the existing file as your starting point and preserve unrelated values. The backfill step creates missing `metadata.json` files and validates existing metadata without overwriting it or applying later ownership changes. The surrounding repository sync can change other files and state, as described under [operator backfill](#operator-backfill-and-initialization). If metadata is missing, ask the AVM core team to confirm the module's readiness rather than inventing values.

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

Single-segment pattern/utility taxonomy support is pending implementation verification. Once adopted, `canonicalType` can be a single value such as `naming` for `avm-utl-naming`, or `alz` for a pattern. Existing multi-segment values remain valid. Resource modules still require the full ARM resource type, and repository/Bicep folder naming conventions are unchanged.

Module identity, module class, repository paths, and parent relationships are derived from the repository. Do not add fields for them to `metadata.json`. In particular, `moduleDisplayName` is not a way to rename a module or move its repository.

There is **no `moduleStatus` or `status` field** in this schema. Follow the existing [proposal and lifecycle processes](#processes-that-remain-separate) rather than adding an unsupported field.

## Operator backfill and initialization

The operator backfill update is pending implementation and rollout approval. Once adopted, backfill is one optional script call within a **full ordinary Terraform repository sync**, followed by the standard preparation, validation, publication, and merge process. It is not an isolated metadata-only run.

The full run still includes normal repository settings and Azure management, managed-file updates, `pre-commit`, and `CODEOWNERS` handling. Review the complete planned changes and obtain explicit approval before running against production. Standard sync authorization and merge behavior apply, including the existing authorized automation path; backfill does not promise review-only publication, no automatic merge, or no state changes.

The metadata-creation step is intended to use the trusted tools checkout without requiring a new authoring release for that step. Full ordinary sync still needs its normal released authoring module and tools. A metadata failure stops later file publication, but earlier ordinary management actions may already have run and are not automatically rolled back.

The Terraform metadata-creation step creates only `metadata.json`; it does not generate `main.metadata.tf` or delete an existing Terraform reader. Keep existing `.tf` files in place when removing that generation option. The **full sync** can still format, transform, or move other Terraform source files under its existing rules. Terraform source and telemetry integration are separate work, and this update introduces no new transformation rule. This Terraform change does not remove optional Bicep reader support.

This operator process does not change the human ownership-review requirements below or the catalog's separate reviewed publication and source-row removal checks.

## Submit and review a change

These steps apply to human-authored metadata changes. Operator backfill uses the standard authorized sync path described above, rather than a separate metadata publication path.

1. Agree the change with the current owners and the AVM core team. For ownership changes, retain the eligibility checks, incoming owners' written consent, and handover requirements in the [owner-change process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#changing-module-owners).
1. Edit the relevant `metadata.json` on a branch or in your fork of the module repository. Preserve all owners and other values that are not part of the agreed change.
1. Submit a pull request to that repository, linking the proposal or ownership-tracking issue when the process requires one. Describe the intended changes and request review from either [`@Azure/azure-verified-modules-engineering-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-engineering-owners) or [`@Azure/azure-verified-modules-module-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-module-owners).
1. Satisfy the repository's metadata validation and required reviews before merging. Approval from an eligible member of **either** team satisfies metadata code-owner review; approval from both teams is **not** required. Being listed in the module's `owners` array does not by itself authorize someone to approve. Any code changes in the same pull request still need their normal code review and tests.
1. Follow the change through catalog generation and reviewed publication. Do not edit the generated CSV or JSON output to duplicate the metadata change.

After adoption, the metadata rule in `CODEOWNERS` is:

```text
metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners
```

Before adoption, authorized repository administrators must confirm that **both teams are visible and have repository write access**, so an eligible member of either team can provide code-owner approval. Access setup is separate from metadata maintenance and does not change environment approval requirements.

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

Follow [when a new owner is identified]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified). After eligibility and consent are confirmed, add the approved incoming handles to the root metadata's `owners` array and obtain approval from either metadata code-owner team.

Complete the separate access approval and notice-removal steps before closing the ownership issue. Adding owners does not revive a deprecated module.

## Rollout and publication

Catalog rows are generated from valid module metadata. There is no fallback that copies full legacy CSV records when metadata is missing. Source CSVs remain inputs to the row-removal check below, not a substitute for metadata.

Normal authoring checks retain their missing-metadata warnings. A warning does not supply the valid metadata required to generate a catalog row.

Metadata changes reach the public indexes through catalog generation and reviewed publication, not immediately when an owner confirms a change or a metadata pull request is merged.

During preview, catalog generation writes `test-*.csv` files beside the unchanged canonical CSVs and writes the JSON catalog at its normal `v1/modules.json` path. Replacing the canonical CSVs is a **separate future change**. Continue to use the existing [CSV downloads and module indexes]({{% siteparam base %}}/indexes/) until that changeover is approved.

The compatibility CSVs expose only the first two individual owners in their primary and secondary owner columns. The root metadata and richer JSON catalog retain all owners; do not remove owners to fit the CSV columns.

Existing child CSV `AlternativeNames` and `Comments` values, including blank cells, are preserved for matched metadata-backed records. This compatibility does not retain an entire legacy row when metadata is missing.

Do not assume that a preview publication updates the live website, issue routing, or `CODEOWNERS`. The AVM core team must confirm the relevant publication and synchronization have completed before relying on those consumers.

### Source CSV row removals

Generation and publication **fail by default if any row from a source CSV would disappear** from the output. The comparison uses the **source CSV only**, not the existing destination file. Rows found only in an earlier `test-*.csv` preview do not receive this removal protection. The same source-row check applies whether output uses preview filenames or later replaces the canonical CSVs.

Review which source rows would disappear and why. Supply correct metadata where the module should remain; do not invent metadata values or remove source CSV rows just to avoid the check. An explicitly authorized manual force override permits only those row removals. It does **not** permit invalid metadata, bypass other safety checks, or replace normal review and publication approval.

## Processes that remain separate

**New proposals:** Keep using the [module proposal and approval process]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation), including repository creation and any required registry approval. Proposals without a repository or module source have no metadata file to edit. Keep their existing proposal issues and approvals; do not create placeholder metadata. They cannot generate catalog rows without valid metadata. If a corresponding source CSV row would disappear, the removal check blocks generation and publication unless that removal is explicitly authorized through the manual force override. The AVM core team must resolve how to handle proposals before source exists; this process does not assign them a new metadata location.

**Publication:** Registry publication is still required before a module is available. A metadata change does not publish a module.

**Deprecation:** Follow the [deprecation process]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-deprecated), including its approval, notices, and language-specific retirement steps. After adoption, the catalog derives `Deprecated` from the existing `DEPRECATED.md` file for Bicep or the repository's `archived` flag for Terraform. Review the generated catalog update rather than editing an index status.

A Bicep `DEPRECATED.md` marker applies to its module and descendants: a root marker covers all children, while a child marker does not deprecate its parent or siblings. Terraform repository archival applies to every module entry in that repository. Preserve existing `Deprecated` status for metadata-backed entries during the transition; a missing retirement signal must not reactivate them. Status preservation does not allow a full legacy row without valid metadata to be retained. Missing source CSV rows are subject to the same removal check as other rows. The v1 metadata schema has no lifecycle or status field, and clearing owners is not a substitute for deprecation.

**Bicep child publishing:** [Telemetry assignment and Microsoft Artifact Registry (MAR) approval]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing/#prerequisites) remain required. Recording metadata does not grant permission to publish a child module.
