---
title: Process Overview
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

This page provides an overview of the contribution process for AVM modules.

## New Module Proposal & Creation

{{< hint type=important >}}

Each AVM module **MUST** have a [Module Proposal](https://aka.ms/AVM/ModuleProposal) issue created and approved by the AVM core team before it can be created/migrated!

{{< /hint >}}

<!-- markdownlint-disable -->
{{< mermaid class="text-center" >}}
flowchart TD
    ModuleIdea[Consumer has an idea for a new AVM Module] -->CheckIndex(> Check AVM Module Indexes <)
        click CheckIndex "/Azure-Verified-Modules/indexes/"
    CheckIndex -->IndexExistenceCheck{Does the module already <br> exist in an active/orphaned <br> state in respective index?}
    IndexExistenceCheck -->|No|A
    IndexExistenceCheck -->|Yes|EndExistenceCheck(Review existing/proposed AVM module)
    EndExistenceCheck -->OrphanedCheck{> Is the module orphaned? <}
        click OrphanedCheck "/Azure-Verified-Modules/specs/shared/module-lifecycle/#orphaned-avm-modules"
    OrphanedCheck -->|No|ContactOwner[Contact module owner,<br> via GitHub issues on the related <br>repo, to discuss enhancements/<br>bugs/opportunities to contribute etc.]
    OrphanedCheck -->|Yes|OrphanOwnerYes(Locate the related issue <br> and comment on:<br> - A feature/enhancement suggestion <br> - Indicating you wish to become the owner)
        click OrphanOwnerYes "/Azure-Verified-Modules/specs/shared/module-lifecycle/#orphaned-avm-modules"
    OrphanOwnerYes -->B
    A[[> Create Module Proposal <]] -->|GitHub Issue/Form Submitted| B{> AVM Core Team Triage <}
        click A "https://aka.ms/avm/moduleproposal"
        click B "/Azure-Verified-Modules/help-support/issue-triage/avm-issue-triage/#avm-core-team-triage-explained"
    B -->|Module Approved for Creation| C[["Module Owner(s) Identified  & <br> assigned to GitHub issue/proposal" ]]
    B -->|Module Rejected| D(Issue closed with reasoning)
    C -->E[[> Module index < <br> CSV files updated by AVM Core Team]]
        click E "/Azure-Verified-Modules/indexes/"
    E -->E1[[Repo/Directory Created following the <br> > Contribution Guide <]]
        click E1 "/Azure-Verified-Modules/contributing/"
    E1 -->F("Module Developed by <br> Owner(s) & their Contributors")
    F -->G[[> Module & AVM Compliance Tests <]]
        click G "https://aka.ms/avm/snfr3"
    G -->|Tests Fail|I(Modules/Tests Fixed <br> To Make Them Pass)
    I -->F
    G -->|Tests Pass|J[[Pre-Release v0.1.0 created]]
    J -->K[[Publish to Bicep/Terraform Registry]]
    K -->L(Take Feedback from v0.1.0 Consumers)
    L -->M{Anything to be resolved <br> before 1.0.0 release? <br> <br> > ! Read the AVM preview notice ! <}
        click M "/Azure-Verified-Modules/contributing/process/#avm-preview-notice"
    M -->|Yes|FixPreV1("Module Feedback Incorporated by <br> Owner(s) & their Contributors")
    FixPreV1 -->PreV1Tests[[Self & AVM Module Tests]]
    PreV1Tests -->|Tests Fail|PreV1TestsFix(Modules/Tests Fixed <br> To Make Them Pass)
    PreV1TestsFix -->N
    M -->|No|N[[Publish 1.0.0 Release]]
    N -->O[[Publish to IaC Registry]]
    O -->P[[> Module BAU Starts <]]
        click P "/Azure-Verified-Modules/help-support/module-support/"
{{< /mermaid >}}
<!-- markdownlint-enable -->
## AVM Preview Notice

{{< hint type=important >}}

As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.

All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.

However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

{{< /hint >}}

## Module Owner Has Issue/Is Blocked/Has A Request

In the event that a module owner has an issue or is blocked due to specific AVM missing guidance, test environments, permission requirements, etc. they should follow the below steps:

{{< hint type=tip >}}

Common issues/blockers/asks/request are:

- Subscription level features
- Resource Provider Registration
- Preview Services Enablement
- Entra ID (formerly Azure Active Directory) configuration (SPN creation, etc.)

{{< /hint >}}

1. Create a [GitHub Issue](https://github.com/Azure/Azure-Verified-Modules/issues/new/choose)
2. Discuss the issue/blocker with the AVM core team
3. Agree upon action/resolution/closure
4. Implement agreed upon action/resolution/closure

{{< hint type=note >}}

Please note for module specific issues, these should be logged in the module's source repository, not the AVM repository.

{{< /hint >}}
