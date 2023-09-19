---
title: Process Overview
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

This page will provide an overview of the contribution process for AVM modules.

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
    A[[<a href='https://aka.ms/avm/moduleproposal'>Create Module Proposal</a>]] -->|GitHub Issue/Form Submitted| B{AVM Core Team Triage}
    B -->|Module Approved for Creation| C[["Module Owner(s) Identified  & <br> assigned to GitHub issue/proposal" ]]
    B -->|Module Rejected| D(Issue closed with reasoning)
    C -->E[[Module index CSV files <br> updated by AVM Core Team]]
    E -->E1[[Repo/Directory Created <br> Following Contribution Guide]]
    E1 -->F("Module Developed by <br> Owner(s) & their Contributors")
    F -->G[[Self & AVM Module Tests]]
    G -->|Tests Fail|I(Modules/Tests Fixed <br> To Make Them Pass)
    I -->F
    G -->|Tests Pass|J[[Pre-Release v0.1.0 created]]
    J -->K[[Publish to IaC Registry]]
    K -->L(Take Feedback from v0.1.0 Consumers)
    L -->M{Anything to be resolved <br> before v1.0.0 release?}
    M -->|Yes|FixPreV1("Module Feedback Incorporated by <br> Owner(s) & their Contributors")
    FixPreV1 -->PreV1Tests[[Self & AVM Module Tests]]
    PreV1Tests -->|Tests Fail|PreV1TestsFix(Modules/Tests Fixed <br> To Make Them Pass)
    PreV1TestsFix -->N
    M -->|No|N[[Publish v1.0.0 Release]]
    N -->O[[Publish to IaC Registry]]
    O -->P[[Module BAU Starts]]
{{< /mermaid >}}

### "AVM Core Team Triage" Explained

During the AVM Core Team Triage step, the following will be checked, completed and actioned by the AVM Core Team during their triage calls (which are currently twice per week):

1. Check module proposal issue/form has been filled out correctly
   - If not, they will comment back on the issue to the requestor to clarify
2. Apply relevant additional labels
3. Check module is correct as per specifications - [naming](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming), [classification](/Azure-Verified-Modules/specs/shared/module-classifications/) (resource/pattern) etc.
4. Check module isn't to be [migrated from an existing initiative](/Azure-Verified-Modules/faq/#what-is-happening-to-existing-initiatives-like-carml-and-tfvm)
5. Check module isn't a duplicate in development already
6. Add the relevant "Language ..." label to the issue
7. Clarify module owners roles and responsibilities - if proposed in module proposal:
   - Check they are a Microsoft FTE
   - Clarify they understand and accept what "module ownership" means by replying in a comment to the requestor/proposed owner:

{{< expand "Standard AVM Core Team Reply to Proposed Module Owners" "expand/collapse" >}}
```text
Hi @{requestor/proposed owner's GitHub alias},

Thanks for requesting/proposing to be an AVM module owner.

We just want to confirm you agree to the below pages that define what module ownership means:

- https://azure.github.io/Azure-Verified-Modules/specs/shared/team-definitions
- https://azure.github.io/Azure-Verified-Modules/specs/shared
- https://azure.github.io/Azure-Verified-Modules/help-support/module-support

Any questions or clarifications needed let us know.

If you agree please just reply to this issue with the exact sentence below (as this helps with our automation 👍):

"I CONFIRM I WISH TO OWN THIS AVM MODULE AND UNDERSTAND THE REQUIREMENTS AND DEFINITION OF A MODULE OWNER"

Thanks

The AVM Core Team
```
{{< /expand >}}

8. Find module owners - if not proposed in module proposal OR original person/s proposed to be module owners, do not wan't or cannot be owners of the module:
   - Move the issue into "Looking for owners" column in [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project
   - Add the "Needs: Module Owner 📣" label to the issue
   - Try to find owner from AVM communities or await a module owner to comment and propose themselves on the proposal issue
     - When a new owner is potentially identified, go back to step 6
9. Once module owner identified and has confirmed they understand and accept their roles and responsibilities as an AVM module owner
   - Assign the issue to the confirmed module owner
   - Move the issue into "In development" column in [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project
   - Add the "Status: Owners Identified 🤘" label to the issue
     - Remove the "Needs: Module Owner 📣" label from the issue, if applied
10. Update the AVM Module Indexes CSV files
11. Use the following values from the module index CSV file(s) explicitly:
    - `ModuleName`
    - `TelemetryIdPrefix`
    - `ModuleOwnersGHTeam` and `ModuleContributorsGHTeam`
    - Repository name and folder path defined in `RepoURL`
12. Update any Azure RBAC permissions for test tenants/subscription, if required
13. Bicep Only:
    - Update `Azure/bicep-registry-modules` [CODEOWNERS file](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS)
14. Once module is developed and `v0.1.0` has been published to the relevant registry, move the issue into "Done" column in [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project

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
