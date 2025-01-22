---
title: Process Overview
---

This page provides an overview of the contribution process for AVM modules.

## New Module Proposal & Creation

{{% notice style="important" %}}
Each AVM module **MUST** have a [Module Proposal](https://aka.ms/AVM/ModuleProposal) issue created and approved by the AVM core team before it can be created/migrated!
{{% /notice %}}

<!-- markdownlint-disable -->
<div style="width: 60%; height: 800px; overflow: hidden; position: relative; margin: 0 auto;margin-bottom: 2px;">
<!-- <div style="margin-left: 0 !important; text-align: center; resize:both; overflow:auto; margin-bottom: 2px; position:relative; max-height: 600px; max-width: 100%;">  -->

{{< mermaid zoom="true">}}
---
config:
  nodeSpacing: 20
  rankSpacing: 20
  diagramPadding: 5
  padding: 5
  useWidth: 100
  flowchart:
    wrappingWidth: 400
    padding: 5
---
flowchart TD
    ModuleIdea[Consumer has an idea for a new AVM Module] -->CheckIndex(Check AVM Module Indexes)
        click CheckIndex "{{% siteparam base %}}/indexes/"
    CheckIndex -->IndexExistenceCheck{Is the module<br>in the index?}
    IndexExistenceCheck -->|No|A
    IndexExistenceCheck -->|Yes|EndExistenceCheck(Review existing/proposed AVM module)
    EndExistenceCheck -->OrphanedCheck{ Is the module<br>orphaned? }
        click OrphanedCheck "{{% siteparam base %}}/specs/shared/module-lifecycle/#orphaned-avm-modules"
    OrphanedCheck -->|No|ContactOwner[Contact module owner,<br> via GitHub issues on the related <br>repo, to discuss enhancements/<br>bugs/opportunities to contribute etc.]
    OrphanedCheck -->|Yes|OrphanOwnerYes(Locate the related issue <br> and comment on:<br> - A feature/enhancement suggestion <br> - Indicating you wish to become the owner)
        click OrphanOwnerYes "{{% siteparam base %}}/specs/shared/module-lifecycle/#orphaned-avm-modules"
    OrphanOwnerYes -->B
    A[[ Create Module Proposal ]] -->|GitHub Issue/Form Submitted| B{ AVM Core Team<br>Triage }
        click A "https://aka.ms/avm/moduleproposal"
        click B "{{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#avm-core-team-triage-explained"
    B -->|Module Approved for Creation| C[["Module Owner(s) Identified  & assigned to GitHub issue/proposal" ]]
    B -->|Module Rejected| D(Issue closed with reasoning)
    C -->E[[ Module index CSV files updated by AVM Core Team]]
        click E "{{% siteparam base %}}/indexes/"
    E -->E1[[Repo/Directory Created following the <br> Contribution Guide ]]
        click E1 "{{% siteparam base %}}/contributing/"
    E1 -->F("Module Developed by Owner(s) & their Contributors")
    F -->G[[ Module & AVM Compliance Tests ]]
        click G "https://aka.ms/avm/snfr3"
    G -->|Tests Fail|I(Modules/Tests Fixed <br> To Make Them Pass)
    I -->F
    G -->|Tests Pass|J[[Pre-Release v0.1.0 created]]
    J -->K[[Publish to Bicep/Terraform Registry]]
    K -->L(Take Feedback from v0.1.0 Consumers)
    L -->M{Anything<br>to be resolved <br> before 1.0.0<br>release? }
        click M "{{% siteparam base %}}/contributing/process/#avm-preview-notice"
    M -->|Yes|FixPreV1("Module feedback incorporated by Owner(s) & their Contributors")
    FixPreV1 -->PreV1Tests[[Self & AVM Module Tests]]
    PreV1Tests -->|Tests Fail|PreV1TestsFix(Modules/Tests Fixed To Make Them Pass)
    PreV1TestsFix -->N
    M -->|No|N[[Publish 1.0.0 Release]]
    N -->O[[Publish to IaC Registry]]
    O -->P[[ Module BAU Starts ]]
        click P "{{% siteparam base %}}/help-support/module-support/"
{{< /mermaid >}}
</div><!-- markdownlint-enable -->

### Provide details for module proposals

When proposing a module, please include the information in the description that is mentioned for the triage process here:

- [Module Proposals]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#module-proposal-triage)
- [Pattern modules]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#triaging-pattern-modules)

## AVM Preview Notice

{{% notice style="important" %}}

As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.

All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.

However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

{{% /notice %}}

## Module Owner Has Issue/Is Blocked/Has A Request

In the event that a module owner has an issue or is blocked due to specific AVM missing guidance, test environments, permission requirements, etc. they should follow the below steps:

{{% notice style="tip" %}}

Common issues/blockers/asks/request are:

- Subscription level features
- Resource Provider Registration
- Preview Services Enablement
- Entra ID (formerly Azure Active Directory) configuration (SPN creation, etc.)

{{% /notice %}}

1. Create a [GitHub Issue](https://github.com/Azure{{% siteparam base %}}/issues/new/choose)
2. Discuss the issue/blocker with the AVM core team
3. Agree upon action/resolution/closure
4. Implement agreed upon action/resolution/closure

{{% notice style="note" %}}

Please note for module specific issues, these should be logged in the module's source repository, not the AVM repository.

{{% /notice %}}
