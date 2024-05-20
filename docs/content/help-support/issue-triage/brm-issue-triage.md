---
title: BRM Issue Triage
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

## Overview

This page provides guidance for **Bicep module owners** on how to triage **AVM module issues** and **AVM question/feedback** items filed in the [BRM repository](https://aka.ms/BRM) (Bicep Registry Modules repository - where all Bicep AVM modules are published), as well as how to manage these GitHub issues throughout their lifecycle.

As such, **the following issues are to be filed in the BRM repository**:

- **\[[AVM Module Issue](https://aka.ms/BRM/AVMModuleIssue)]**: Issues specifically related to an existing AVM module, such as feature requests, bug and security bug reports.
- **\[[AVM Question/Feedback](https://aka.ms/BRM/AVMQuestionFeedback)]**:Generic feedback and questions, related to existing AVM module, the overall framework, or its automation (CI environment).

Do **NOT** file the following types of issues in the **BRM repository**, as they **MUST** be tracked in the **AVM repo**:

- **\[[Module Proposal](https://aka.ms/AVM/ModuleProposal)]**: Proposals for new AVM modules.
- **\[[Orphaned Module](https://aka.ms/AVM/OrphanedModule)]**: Indicate that a module is orphaned (has no owner).
- **\[[Question/Feedback](https://aka.ms/AVM/QuestionFeedback)]**: Generic questions/requests related to the AVM site or documentation.

{{< hint type=note >}}
Every module needs a module proposal to be created in the AVM repository.
{{< /hint >}}

<br>

## Module Owner Responsibilities

During the triage process, module owners are expected to check, complete and follow up on the items described in the sections below.

Module owners **MUST** meet the SLAs defined on the [Module Support](/Azure-Verified-Modules/help-support/module-support/) page! While there's automation in place to support meeting these SLAs, module owners **MUST** check for new issues on a regular basis.

{{< hint type=important >}}
The [BRM repository](https://aka.ms/BRM) includes other, non-AVM modules and related GitHub issues. As a module owner, make sure you're only triaging, managing or otherwise working on issues that are related to AVM modules!
{{< /hint >}}

{{< hint type=tip >}}

- To look for items that **need triaging**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsTriage"><mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark></a> ⬅️.
- To look for items that **need attention**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsAttention"><mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark></a> ⬅️.

{{< /hint >}}

<br>

## Module Issue

An issue is considered to be an "AVM module issue" if

- it was opened through the **\[[AVM Module Issue](https://aka.ms/BRM/AVMModuleIssue)]** template in the [BRM repository](https://aka.ms/BRM),
- it has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it, and
- it is assigned to the "[AVM - Module Issues](https://github.com/orgs/Azure/projects/566)" GitHub project.

{{< hint type=note >}}
Module issues can only be opened for existing AVM modules. Module issues **MUST NOT** be used to file a module proposal.

If the issue was opened as a misplaced module proposal, mention the `@Azure/AVM-core-team-technical-bicep` team in the comment section and ask them to move the issue to the AVM repository.
{{< /hint >}}

### Triaging a Module Issue

1. Check the Module issue:
    - Make sure the issue has the "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it.
    - Use the AVM module indexes to identify the module owner(s) and make sure they are assigned/mentioned/informed.
    - If the module is orphaned (has no owner), make sure there's an orphaned module issue in the AVM repository.
    - Make sure the module's details are captured correctly in the description - i.e., name, classification (resource/pattern), language (Bicep/Terraform), etc.
    - Make sure the issue is categorized using one of the following type labels:
      - "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>"
      - "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>"
      - "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>"
2. Apply relevant labels for module classification (resource/pattern): "<mark style="background-color:#D3D3D3;">Class: Resource Module 📦</mark>" or "<mark style="background-color:#A9A9A9;">Class: Pattern Module 📦</mark>"
3. Communicate next steps to the requestor (issue author).
4. Remove the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.
5. When more detailed plans are available, communicate expected timeline for the update/fix to the requestor (issue author).
6. Only close the issue, once the next version of the module was fully developed, tested and published.

<br>

## General Question/Feedback and other standard issues

An issue is considered to be an "AVM Question/Feedback" if

- it was opened through the **\[[AVM Question/Feedback](https://aka.ms/BRM/AVMQuestionFeedback)]** template in the [BRM repository](https://aka.ms/BRM),
- it has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#CB6BA2;">Type: Question/Feedback 🙋‍♀️</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it, and
- it is assigned to the "[AVM - Issue Triage](https://github.com/orgs/Azure/projects/538)" GitHub project.

An issue is considered to be a "standard issue" or "blank issue" if it was opened without using an issue template, and hence it does **NOT** have any labels assigned, OR only has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label assigned.

### Triaging a General Question/Feedback and other standard issues

1. When triaging the issue, consider adding one of the following labels as fits:

    - <mark style="background-color:#0075CA;color:white;">Type: Documentation 📄</mark>
    - <mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>
    - <mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>
    - <mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>

> To see the full list of available labels, please refer to the [GitHub Repo Labels](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) section.

2. Add any (additional) labels that apply.
3. Communicate next steps to the requestor (issue author).
4. Remove the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.
5. When more detailed plans are available, communicate expected timeline for the update/fix to the requestor (issue author).
6. Once the question/feedback/topic is fully addressed, close the issue.

{{< hint type=note >}}

If an intended module proposal was mistakenly opened as a "AVM Question/Feedback ❔" or other standard issue, a new issue **MUST** be created in the [AVM repo](https://aka.ms/AVM/repo) using the "New AVM Module Proposal 📝" [issue template](https://aka.ms/avm/moduleproposal). The mistakenly created "AVM Question/Feedback ❔" or other standard issue **MUST** be closed.

{{< /hint >}}
