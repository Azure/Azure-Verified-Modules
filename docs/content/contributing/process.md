---
title: Process Overview
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

This page provides an overview of the contribution process for AVM modules.

## New Module Proposal & Creation

{{< mermaid class="text-center" >}}
flowchart TD
    ModuleIdea[Consumer has an idea for a new AVM Module] -->CheckIndex(Check <a href='/Azure-Verified-Modules/indexes/'>AVM Module Indexes</a>)
    CheckIndex -->IndexExistenceCheck{Does the module already <br> exist in an active/orphaned <br> state in respective index?}
    IndexExistenceCheck -->|No|A
    IndexExistenceCheck -->|Yes|EndExistenceCheck(Review existing/proposed AVM module)
    EndExistenceCheck -->OrphanedCheck{Is the module <a href='/Azure-Verified-Modules/specs/shared/module-lifecycle/#orphaned-avm-modules'>orphaned</a>?}
    OrphanedCheck -->|No|ContactOwner[Contact module owner,<br> via GitHub issues on the related <br>repo, to discuss enhancements/<br>bugs/opportunities to contribute etc.]
    OrphanedCheck -->|Yes|OrphanOwnerYes(Locate the <a href='https://aka.ms/avm/orphanedmodules'>related issue</a> <br> and comment on:<br> - A feature/enhancement suggestion <br> - Indicating you wish to become the owner)
    OrphanOwnerYes -->B
    A[[<a href='https://aka.ms/avm/moduleproposal'>Create Module Proposal</a>]] -->|GitHub Issue/Form Submitted| B{<a href='/Azure-Verified-Modules/contributing/process/#avm-core-team-triage-explained'>AVM Core Team Triage</a>}
    B -->|Module Approved for Creation| C[["Module Owner(s) Identified  & <br> assigned to GitHub issue/proposal" ]]
    B -->|Module Rejected| D(Issue closed with reasoning)
    C -->E[[<a href='/Azure-Verified-Modules/indexes/'>Module index</a> CSV files <br> updated by AVM Core Team]]
    E -->E1[[Repo/Directory Created <br> Following <a href='/Azure-Verified-Modules/contributing/'>Contribution Guide</a>]]
    E1 -->F("Module Developed by <br> Owner(s) & their Contributors")
    F -->G[[Module & <a href='https://aka.ms/avm/snfr3'>AVM Compliance Tests</a>]]
    G -->|Tests Fail|I(Modules/Tests Fixed <br> To Make Them Pass)
    I -->F
    G -->|Tests Pass|J[[Pre-Release v0.1.0 created]]
    J -->K[[Publish to Bicep/Terraform Registry]]
    K -->L(Take Feedback from v0.1.0 Consumers)
    L -->M{Anything to be resolved <br> before 1.0.0 release?}
    M -->|Yes|FixPreV1("Module Feedback Incorporated by <br> Owner(s) & their Contributors")
    FixPreV1 -->PreV1Tests[[Self & AVM Module Tests]]
    PreV1Tests -->|Tests Fail|PreV1TestsFix(Modules/Tests Fixed <br> To Make Them Pass)
    PreV1TestsFix -->N
    M -->|No|N[[Publish 1.0.0 Release]]
    N -->O[[Publish to IaC Registry]]
    O -->P[[<a href='/Azure-Verified-Modules/help-support/module-support/'>Module BAU Starts</a>]]
{{< /mermaid >}}

## "AVM Core Team Triage" Explained

During the AVM Core Team Triage step, the following will be checked, completed and actioned by the AVM Core Team during their triage calls (which are currently twice per week).

This section provides guidance for members of the AVM Core Team on how to triage module proposals and generic issues as well as how to manage issues throughout their lifecycle.

{{< hint type=note >}}
Every module needs a module proposal to be created in the AVM repository This applies to both net new modules, as well as modules that are to be migrated from CARML/TFVM!
{{< /hint >}}

### Module Proposal triage

An issue is considered to be a module proposal if it was opened through the [module proposal template](https://aka.ms/avm/moduleproposal), and has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>" applied to them.

Follow these steps to triage a module proposal:
1. Add label of "<mark style="background-color:#E4E669;">Status: In Triage 🔍</mark>" to indicate you're in the process of triaging the issue.
2. Check module proposal issue/form:
   - Check the [Bicep](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/) or [Terraform](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/) module indexes for the proposed module to make sure it is not already available or being worked on.
   - Ensure the module's details are correct as per specifications - [naming](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming), [classification](/Azure-Verified-Modules/specs/shared/module-classifications/) (resource/pattern) etc.
   - Check if the module is added to the "`Proposed`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub project board.
   - Check if the requestor is a Microsoft FTE
   - If there's any additional clarification needed, contact the requestor through comments (using their GH handle) or internal channels - for Microsoft FTEs only! - (looking them up by their name). Make sure you capture any decisions regarding the module in the comments section.
   - Make adjustments to the module's name/classification as needed.
   - Change the name of the issue so that reflect the module's classification and language, e.g.,
     - if it's a Bicep resource module, add "(res) (bcp)" to the end of the issue's name;
     - if it's a Terraform pattern module, add "(ptn) (tf)" to the end of the issue's name.
3. Apply relevant labels
    - Module language: "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" or "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>"
    - Module classification (resource/pattern): "<mark style="background-color:#D3D3D3;">Class: Resource Module 📦</mark>" or "<mark style="background-color:#A9A9A9;">Class: Pattern Module 📦</mark>"
    - If it's a module that will be migrated from CARML/TFVM, add the related "<mark style="background-color:#00796F;color:white;">Status: Migrate from CARML 🚛</mark>" or the "<mark style="background-color:#00796F;color:white;">Status: Migrate from TFVM 🚛</mark>" label.

#### Scenario 1: Requestor doesn't want to / can't be module owner

{{< hint type=note >}}
If requestor is interested in becoming a module owner, but is not a Microsoft FTE, the AVM core team will try to find a Microsoft FTE to be the module owner whom the requester can collaborate with.
{{< /hint >}}

1. If the requester didn't indicate they want to or can't become a module owner (or is not a Microsoft FTE), assign the label of "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" to the issue.
2. Move the issue to the "`Looking for owners`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub project board.
3. Find module owners - if not proposed in module proposal OR original person/s proposed to be module owners, do not want or cannot be owners of the module:
4. Try to find owner from AVM communities or await a module owner to comment and propose themselves on the proposal issue
5. When a new owner is potentially identified, continue with the steps described [below](#scenario-2-requestor-wants-to-become-module-owner)

#### Scenario 2: Requestor wants to become module owner

If the requestor indicated they want to become an owner (and is a Microsoft FTE), do **not** assign the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label yet, as first you need to confirm that they understand the implications of becoming the owner.

1. Clarify the roles and responsibilities of the module owner:
   - Clarify they understand and accept what "module ownership" means by replying in a comment to the requestor/proposed owner:

{{< expand "➕ Standard AVM Core Team Reply to Proposed Module Owners" "expand/collapse" >}}

```text
Hi @{requestor/proposed owner's GitHub alias},

Thanks for requesting/proposing to be an AVM module owner.

We just want to confirm you agree to the below pages that define what module ownership means:

- https://azure.github.io/Azure-Verified-Modules/specs/shared/team-definitions
- https://azure.github.io/Azure-Verified-Modules/specs/shared
- https://azure.github.io/Azure-Verified-Modules/help-support/module-support

Any questions or clarifications needed, let us know.

If you agree please just reply to this issue with the exact sentence below (as this helps with our automation 👍):

"I CONFIRM I WISH TO OWN THIS AVM MODULE AND UNDERSTAND THE REQUIREMENTS AND DEFINITION OF A MODULE OWNER"

Thanks,

The AVM Core Team
```

{{< /expand >}}

2. Once module owner identified and has confirmed they understand and accept their roles and responsibilities as an AVM module owner
   - Assign the issue to the confirmed module owner.
   - Move the issue into the "`In development`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project board.
   - Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label to the issue.
     - Remove the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label from the issue, if applied
   - Remove the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#E4E669;">Status: In Triage 🔍</mark>" to indicate you're done with triaging the issue.
3. Update the AVM Module Indexes, following the [process documented internally](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/286/Module-index-file-update-process).
4. Use the following text to approve module development

{{< expand "➕ Final Confirmation for Proposed Module Owners" "expand/collapse" >}}

```text
Hi @{requestor/proposed owner's GitHub alias},

Thanks for confirming that you wish to own this AVM module and understand the related requirements and responsibilities.

We just want to ask you to double check a few important things before you start the development.

Please visit the [module index](https://azure.github.io/Azure-Verified-Modules/indexes/) page of your module and use the following values explicitly as provided there:

- `ModuleName`
- `TelemetryIdPrefix`
- `ModuleOwnersGHTeam` and `ModuleContributorsGHTeam`
- Repository name and folder path defined in `RepoURL`

You can now start the development of this module! Happy coding! 🎉

Please respond to this comment, once your module is ready to be published!

Any further questions or clarifications needed, let us know.

Thanks,

The AVM Core Team
```

{{< /expand >}}

{{< hint type=tip >}}

Although, it's not directly part of the module proposal triage process, to begin development, module owners and contributors might need additional help from the AVM core team, such as:

1. Update any Azure RBAC permissions for test tenants/subscription, if required
2. Bicep Only:
    - Update `Azure/bicep-registry-modules` [CODEOWNERS file](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS)

{{< /hint >}}

### Post-Development

Once module is developed and `v0.1.0` has been published to the relevant registry

1. Assign the "<mark style="background-color:#C8E6C9;">Status: Module Available 🟢</mark>" label to the issue.
2. Move the issue into "`Done`" column in [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project.
3. Update the AVM Module Indexes, following the [process documented internally](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/286/Module-index-file-update-process).

### Orphaned modules

{{< hint type=important >}}

Content to be added.

{{< /hint >}}

remove the "<mark style="background-color:#C8E6C9;">Status: Module Available 🟢</mark>" label

add the "<mark style="background-color:#F4A460;">Status: Module Orphaned 👀</mark>" label

### Standard Issue triage

{{< hint type=important >}}

Content to be added.

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
