---
title: AVM Issue Triage
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

## "AVM Core Team Triage" Explained

This section provides guidance for members of the AVM Core Team on how to triage module proposals and generic issues as well as how to manage issues throughout their lifecycle.

During the AVM Core Team Triage step, the following will be checked, completed and actioned by the AVM Core Team during their triage calls (which are currently twice per week).

{{< hint type=note >}}
Every module needs a module proposal to be created in the AVM repository This applies to both net new modules, as well as modules that are to be migrated from CARML/TFVM!
{{< /hint >}}

{{< hint type=tip >}}
To look for items that need triaging, click on the following link to use this saved query ➡️ <a href="https://aka.ms/AVM/NeedsTriage"><mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark></a> ⬅️.
{{< /hint >}}

<br>

## Module Proposal triage

An issue is considered to be a module proposal if it was opened through the [module proposal template](https://aka.ms/avm/moduleproposal), and has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>" applied to them.

Follow these steps to triage a module proposal:
1. Add the "<mark style="background-color:#E4E669;">Status: In Triage 🔍</mark>" label to indicate you're in the process of triaging the issue.
2. Check module proposal issue/form:
    - Check the [Bicep](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/) or [Terraform](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/) module indexes for the proposed module to make sure it is not already available or being worked on.
    - Ensure the module's details are correct as per specifications - [naming](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming), [classification](/Azure-Verified-Modules/specs/shared/module-classifications/) (resource/pattern) etc.
    - Check if the module is added to the "`Proposed`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub project board.
    - Check if the requestor is a Microsoft FTE
    - If there's any additional clarification needed, contact the requestor through comments (using their GH handle) or internal channels - for Microsoft FTEs only! You can look them up by their name or using the Microsoft internal "[1ES Open Source Assistant Browser Extension](https://docs.opensource.microsoft.com/tools/browser/)". Make sure you capture any decisions regarding the module in the comments section.
    - Make adjustments to the module's name/classification as needed.
    - Change the name of the issue so that reflect the module's classification and language, e.g.,
      - if it's a Bicep resource module, add "(res) (bcp)" to the end of the issue's name;
      - if it's a Terraform pattern module, add "(ptn) (tf)" to the end of the issue's name.
3. Apply relevant labels
    - Module language: "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" or "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>"
    - Module classification (resource/pattern): "<mark style="background-color:#D3D3D3;">Class: Resource Module 📦</mark>" or "<mark style="background-color:#A9A9A9;">Class: Pattern Module 📦</mark>"
    - If it's a module that will be migrated from CARML/TFVM, add the related "<mark style="background-color:#00796F;color:white;">Status: Migrate from CARML 🚛</mark>" or the "<mark style="background-color:#00796F;color:white;">Status: Migrate from TFVM 🚛</mark>" label.

### Scenario 1: Requestor doesn't want to / can't be module owner

{{< hint type=note >}}
If requestor is interested in becoming a module owner, but is not a Microsoft FTE, the AVM core team will try to find a Microsoft FTE to be the module owner whom the requestor can collaborate with.
{{< /hint >}}

1. If the requestor didn't indicate they want to or can't become a module owner (or is not a Microsoft FTE), assign the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label to the issue.
2. Move the issue to the "`Looking for owners`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub project board.
3. Find module owners - if the requestor didn't volunteer in the module proposal OR the requestor does not want or cannot be owner of the module:
    - Try to find an owner from the AVM communities or await a module owner to comment and propose themselves on the proposal issue.
4. When a new potential owner is identified, continue with the steps described [as follows](#scenario-2-requestor-wants-to-and-can-become-module-owner).

### Scenario 2: Requestor wants to and can become module owner

If the requestor indicated they want to become an owner (and is a Microsoft FTE), do **not** assign the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label yet, as first you need to confirm that they understand the implications of becoming the owner.

1. Clarify the roles and responsibilities of the module owner:
    - Clarify they understand and accept what "module ownership" means by replying in a comment to the requestor/proposed owner:

{{< expand "➕ Standard AVM Core Team Reply to Proposed Module Owners" "expand/collapse" >}}

{{< include file="static/includes/msg-std-reply-new-prop-mod-owners.md" >}}

{{< /expand >}}

2. Once module owner identified has confirmed they understand and accept their roles and responsibilities as an AVM module owner
    - Assign the issue to the confirmed module owner.
    - Move the issue into the "`In development`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project board.
    - Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label to the issue.
      - If applied, remove the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label from the issue.
    - Remove the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#E4E669;">Status: In Triage 🔍</mark>" to indicate you're done with triaging the issue.
3. Update the AVM Module Indexes, following the [process documented internally](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/286/Module-index-file-update-process).
4. Use the following text to approve module development

{{< expand "➕ Final Confirmation for Proposed Module Owners" "expand/collapse" >}}

{{< include file="static/includes/msg-final-conf-new-prop-mod-owners.md" >}}

{{< /expand >}}

{{< hint type=tip >}}

Although, it's not directly part of the module proposal triage process, to begin development, module owners and contributors might need additional help from the AVM core team, such as:

1. Update any Azure RBAC permissions for test tenants/subscription, if required
2. Bicep Only:
    - Update `Azure/bicep-registry-modules` [CODEOWNERS file](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS)

{{< /hint >}}

<br>

## Post-Development issue management

Once module is developed and `v0.1.0` has been published to the relevant registry

1. Assign the "<mark style="background-color:#C8E6C9;">Status: Module Available 🟢</mark>" label to the issue.
2. Move the issue into "`Done`" column in [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project.
3. Update the AVM Module Indexes, following the [process documented internally](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/286/Module-index-file-update-process).
4. Close the issue.

{{< hint type=important >}}

- The Module Proposal issue **MUST remain open** until the module is fully developed, tested and published to the relevant registry.
- Do NOT close the issue before the successful publication is confirmed!
- Once the module is fully developed, tested and published to the relevant registry, and the Module Proposal issue was closed, it **MUST remain closed**.

{{< /hint >}}

<br>

## Orphaned modules

### When a module becomes orphaned

If a module meets the criteria described in the "[Orphaned AVM Modules](/Azure-Verified-Modules/specs/shared/module-lifecycle/#orphaned-avm-modules)" chapter, the modules is considered to be orphaned and the below steps must be performed.

{{< hint type=note >}}
The original **Module Proposal issue** related to the module in question **MUST remain closed and intact**.

Instead, a **new Orphaned Module issue** must be opened that **MUST remain open** until the ownership is fully confirmed!

Once the **Orphaned Module issue** was closed, it **MUST remain closed**. If the module will subsequently become orphaned again, a new Orphaned Module issue must be opened.
{{< /hint >}}

1. Create a new issue using the "[Orphaned Module](https://aka.ms/AVM/OrphanedModule)" issue template.
2. Make sure the "<mark style="background-color:#F4A460;">Status: Module Orphaned 👀</mark>", "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" and the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" labels are assigned to the issue.
3. Move the issue into the "`Orphaned`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project board.
4. Place an information notice on the module's root README.md that states the following:

{{< expand "➕ Orphaned module notice for module README file" "expand/collapse" open >}}

```text
⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️

- Only security and bug fixes are being handled by the AVM core team at present.
- If interested in becoming a module owner (must be Microsoft FTE) for this orphaned module,
please comment on the issue [here](<ADD LINK TO AVM REPO ISSUE>)!
```

{{< /expand >}}

5. Try to find a new owner using the AVM communities or await a new module owner to comment and propose themselves on the issue.

### When a new owner is identified

{{< hint type=tip >}}
To look for Orphaned Modules:
- Click on the following link to use this saved query ➡️ <a href="https://aka.ms/avm/OrphanedModules"><mark style="background-color:#F4A460;">Status: Module Orphaned 👀</mark></a> ⬅️.
- Check the `Orphaned` swim lane on the [Module Triage board](https://aka.ms/avm/moduletriage).
{{< /hint >}}

1. When a new potential owner is identified, clarify the roles and responsibilities of the module owner:
    - Clarify they understand and accept what "module ownership" means by replying in a comment to the requestor/proposed owner:

{{< expand "➕ Standard AVM Core Team Reply to New Owners of an Orphaned Module" "expand/collapse" >}}

{{< include file="static/includes/msg-std-reply-new-orph-mod-owners.md" >}}

{{< /expand >}}

2. Once module owner identified has confirmed they understand and accept their roles and responsibilities as an AVM module owner
    - Assign the issue to the confirmed module owner.
    - Remove the "<mark style="background-color:#F4A460;">Status: Module Orphaned 👀</mark>" and the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" labels from the issue.
    - Add the "<mark style="background-color:#C8E6C9;">Status: Module Available 🟢</mark>" and <mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" labels to the issue.
    - Move the issue into the "`Done`" column on the [AVM - Modules Triage](https://aka.ms/avm/moduletriage) GitHub Project board.
3. Update the AVM Module Indexes, following the [process documented internally](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/286/Module-index-file-update-process).
4. Remove the information notice from the module's root README.md that states that `⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️, etc.`
5. Use the following text to confirm the new ownership of an orphaned module:

{{< expand "➕ Final Confirmation for New Owners of an Orphaned Module" "expand/collapse" >}}

{{< include file="static/includes/msg-std-reply-new-orph-mod-owners.md" >}}

{{< /expand >}}

6. Close the Orphaned Module issue.

<br>

## General feedback/question and other standard issues

An issue is a general question/feedback if it was opened through the ["General Question/Feedback ❔"](https://github.com/Azure/Azure-Verified-Modules/issues/new?assignees=&labels=Type%3A+Question%2FFeedback+%3Araising_hand%3A&projects=&template=question_feedback.yml&title=%5BQuestion%2FFeedback%5D%3A+) issue template, and has the labels of "<mark style="background-color:#CB6BA2;color:white;">Type: Question/Feedback 🙋‍♀️</mark>" and "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" applied to them.

An issue is considered to be a "standard issue" or "blank issue" if it was opened without using an issue template, and hence it does **NOT** have any labels assigned, OR only has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label assigned.

When triaging the issue, consider adding one of the following labels as fits:

- <mark style="background-color:#0075CA;color:white;">Type: Documentation 📄</mark>
- <mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>
- <mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>
- <mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>

To see the full list of available labels, please refer to the [GitHub Repo Labels](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) section.

{{< hint type=note >}}

If an intended module proposal was mistakenly opened as a "General Question/Feedback ❔" or other standard issue, and hence, it doesn't have the "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>" label associated to it, a new issue **MUST** be created using the "New AVM Module Proposal 📝" [issue template](https://aka.ms/avm/moduleproposal). The mistakenly created "General Question/Feedback ❔" or other standard issue **MUST** be closed.

{{< /hint >}}
