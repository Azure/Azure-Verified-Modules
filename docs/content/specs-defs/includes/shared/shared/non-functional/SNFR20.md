---
title: SNFR20 - GitHub Teams Only
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SNFR20
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Contribution/Support, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1110
---

## ID: SNFR20 - Category: Contribution/Support - GitHub Teams Only

All GitHub repositories that AVM modules are published from and hosted within **MUST** only assign GitHub repository permissions to GitHub teams.

Module ownership **MUST** be recorded separately from access permissions. Maintain owners in the root `metadata.json` through the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/). Owner access is managed through the access package described below.

There **MUST NOT** be any GitHub repository permissions assigned to individual users.

{{% notice style="info" %}}
Non-FTE / external contributors (subject matter experts that aren't Microsoft employees) can't be members of the teams described in this chapter, hence, they won't gain any extra permissions on AVM repositories, therefore, they need to work in forks.
{{% /notice %}}

### Bicep

{{% notice style="note" %}}
Access management for Bicep module owners is governed centrally through Microsoft Entra. Per-module GitHub teams and parent-team assignments are no longer required.
{{% /notice %}}

All Bicep module owners, including primary and secondary owners, **MUST** request and obtain approval through the **[Azure Verified Modules (AVM) Module Contributors access package](https://aka.ms/avm/id/access-package/module-contributor)**.

Your GitHub account **MUST** be [linked](https://repos.opensource.microsoft.com/link) to your corporate identity and be a member of the [Azure organization](https://repos.opensource.microsoft.com/orgs/Azure).

Once approved, access is granted through the [`azure-verified-modules-module-contributors`](https://aka.ms/avm/id/groups/module-contributors) Entra group and the corresponding [`@Azure/azure-verified-modules-module-contributors`](https://github.com/orgs/Azure/teams/azure-verified-modules-module-contributors) GitHub team. This shared access does not replace individual module ownership and review responsibilities. Adding a handle to metadata does not grant this access.

Bicep module owners **MUST** continue to work in forks of the [BRM repository](https://aka.ms/BRM).

#### CODEOWNERS file

The BRM [`CODEOWNERS` file](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS) retains the repository-wide `@Azure/azure-verified-modules-tooling-contributors` default and its `*avm.core.team.tests.ps1` and `*.e2eignore` overrides. Its `/avm/` entry intentionally has no owners, and it has no per-module entries. Change module ownership in the root `metadata.json`, not by adding `CODEOWNERS` entries.

The last rule in `CODEOWNERS` assigns `metadata.json` changes to `@Azure/azure-verified-modules-engineering-owners` and `@Azure/azure-verified-modules-module-owners`. An eligible member of **either** team can approve a metadata change; both teams are not required. This special rule still applies to module metadata despite the ownerless `/avm/` entry.

The [Bicep reviewer-routing workflow](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-pr-reviewer-routing.yml) uses each root module's `owners` array to request reviewers for code changes; children inherit those owners. When a module has no owners, it requests `@Azure/azure-verified-modules-module-owners` and applies an orphaned-module triage label. These are notifications, not code-owner approvals: ordinary Bicep module code changes may be approved and merged by any eligible repository team member under repository rules. Authors cannot approve their own changes. Being listed in metadata does not grant review permission.

For Bicep and Terraform, both metadata code-owner teams must be visible and have repository write access. Access administration and environment approvals remain separate responsibilities.

{{% notice style="tip" %}}
For the full onboarding process and ownership handover steps, see the [Bicep Owner Contribution Flow]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/owner-contribution-flow/).
{{% /notice %}}

### Terraform

{{% notice style="note" %}}
Access management for Terraform repositories is governed centrally through Microsoft Entra. Module owner access is granted via an Entra **access package** — it is no longer managed through a per-module GitHub team or the legacy Core Identity entitlement.
{{% /notice %}}

All module owners **MUST** request access via the **Azure Verified Modules (AVM) Module Contributors** Entra access package:

- [Azure Verified Modules (AVM) Module Contributors — Access Package](https://aka.ms/avm/id/access-package/module-contributor)

Once approved, you are added to the [`azure-verified-modules-module-contributors`](https://aka.ms/avm/id/groups/module-contributors) Entra group, which is the source of truth for who is authorized to own and approve changes on AVM Terraform module repositories. Day-to-day repository access is then granted through this group together with just-in-time (JIT) elevation.

{{% notice style="tip" %}}
For the full onboarding process, see the Terraform [Prerequisites]({{% siteparam base %}}/contributing/terraform/prerequisites/) and [Repository Setup]({{% siteparam base %}}/contributing/terraform/repository-setup/) pages.
{{% /notice %}}
