---
title: Terraform Issue Triage
linktitle: Terraform Repositories
description: Issue Triage description for all the Terraform repositories of the Azure Verified Modules (AVM) program
---

## Overview

This page provides guidance for **Terraform Module owners** on how to triage **AVM module issues** and **AVM question/feedback** items filed in their Terraform Module Repo(s), as well as how to manage these GitHub issues throughout their lifecycle.

**The following issues can be filed in a Terraform repository**:

- **AVM Module Issue**: Issues specifically related to an existing AVM module, such as feature requests, bug and security bug reports.
- **AVM Question/Feedback**: Generic feedback and questions, related to existing AVM module, the overall framework, or its automation (CI environment).

Do **NOT** file the following types of issues in a **Terraform repository**, as they **MUST** be tracked in the **AVM repo**:

- **\[[Module Proposal](https://aka.ms/AVM/ModuleProposal)]**: Proposals for new AVM modules.
- **\[[Orphaned Module](https://aka.ms/AVM/OrphanedModule)]**: Indicate that a module is orphaned (has no owner).
- **\[[Question/Feedback](https://aka.ms/AVM/QuestionFeedback)]**: Generic questions/requests related to the AVM site or documentation.

{{% notice style="note" %}}
Every module needs a module proposal to be created in the AVM repository.
{{% /notice %}}

## Module Owner Responsibilities

During the triage process, module owners are expected to check, complete and follow up on the items described in the sections below.

Module owners **MUST** meet the SLAs defined on the [Module Support]({{% siteparam base %}}/help-support/module-support/) page! While there's automation in place to support meeting these SLAs, module owners **MUST** check for new issues on a regular basis.

{{% notice style="tip" %}}

- To look for items that **need triaging**, look for issue labled with ➡️ &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp;⬅️.
- To look for items that **need attention**, look for issue labled with ➡️ &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#E99695;color:white;">Needs: Attention 👋</mark>&nbsp; ⬅️.

{{% /notice %}}

## Module Issue

An issue is considered to be an "AVM module issue" if

- it was opened through the **AVM Module Issue** template in the Terraform repository,
- it has the label of &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; applied to it, and
- it is assigned to the "[AVM - Module Issues](https://github.com/orgs/Azure/projects/566)" GitHub project.

{{% notice style="note" %}}
Module issues can only be opened for existing AVM modules. Module issues **MUST NOT** be used to file a module proposal.

If the issue was opened as a misplaced module proposal, mention the `@Azure/azure-verified-modules-engineering-owners` team in the comment section and ask them to move the issue to the AVM repository.
{{% /notice %}}

### Triaging a Module Issue

1. Check the Module issue:
    - Use the AVM module indexes to identify the module owner(s) and make sure they are assigned/mentioned/informed.
    - If the module is orphaned (has no owner), make sure there's an orphaned module issue in the AVM repository.
    - Make sure the module's details are captured correctly in the description - i.e., name, classification (resource/pattern), language (Bicep/Terraform), etc.
    - Make sure the issue is categorized using one of the following type labels:
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#A2EEEF;">Type: Feature Request ➕</mark>&nbsp;
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>&nbsp;
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FFFF00;">Type: Security Bug 🔒</mark>&nbsp;
2. Apply relevant labels for module classification (resource/pattern): &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#D3D3D3;">Class: Resource Module 📦</mark>&nbsp; or &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#A9A9A9;">Class: Pattern Module 📦</mark>&nbsp;
3. Communicate next steps to the requestor (issue author).
4. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; label.
5. When more detailed plans are available, communicate expected timeline for the update/fix to the requestor (issue author).
6. Only close the issue, once the next version of the module was fully developed, tested and published.

### Triaging a Module PR

PR approvals are **enforced** on all AVM Terraform module repositories. The following rules apply to who must approve:

1. If the **PR is submitted by the module owner** and the **module is owned by a single person**, **another Terraform module owner must review and approve the PR** (the module owner cannot approve their own PR).
    - **First port of call:** find a friendly module owner from the [`AVM Terraform Module Owners`](https://aka.ms/avm/id/groups/module-contributors) Entra group and request a review.
    - **If no owner is available**, assign the `@Azure/azure-verified-modules-engineering-owners` GitHub team as a reviewer and apply the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>&nbsp; label so the AVM core team picks it up during triage.
2. If the **PR is submitted by a contributor** (other than the module owner), or the **module is owned by at least 2 people**, **one of the module owners should review and approve the PR**.
3. Apply relevant labels
    - Categorize the PR using applicable labels, such as:
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#A2EEEF;">Type: Feature Request ➕</mark>&nbsp;
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>&nbsp;
      - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FFFF00;">Type: Security Bug 🔒</mark>&nbsp;
    - For module classification (resource/pattern): &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#D3D3D3;">Class: Resource Module 📦</mark>&nbsp; or &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#A9A9A9;">Class: Pattern Module 📦</mark>&nbsp;
4. If the module is orphaned (has no owner), make sure the related Orphaned module issue (in the AVM repository) is associated to the PR in a comment, so the new owner can easily identify all related issues and PRs when taking ownership.
5. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; label.

{{% notice style="important" title="Give your PR a meaningful title" %}}

- **Prefix**: Start with one of the allowed keywords - `fix:` or `feat:` is the most common for module related changes.
- **Description**: Add a few words, describing the nature of the change.

{{% /notice %}}

## General Question/Feedback and other standard issues

An issue is considered to be an "AVM Question/Feedback" if

- it was opened through the **AVM Question/Feedback** template in your Terraform repository,
- it has the labels of &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; and &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#CB6BA2;">Type: Question/Feedback 🙋‍♀️</mark>&nbsp; applied to it, and
- it is assigned to the "[AVM - Issue Triage](https://github.com/orgs/Azure/projects/538)" GitHub project.

### Triaging a General Question/Feedback and other standard issues

1. When triaging the issue, consider adding one of the following labels as fits:

    - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#0075CA;color:white;">Type: Documentation 📄</mark>&nbsp;
    - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#A2EEEF;">Type: Feature Request ➕</mark>&nbsp;
    - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>&nbsp;
    - &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FFFF00;">Type: Security Bug 🔒</mark>&nbsp;

> To see the full list of available labels, please refer to the [GitHub Repo Labels]({{% siteparam base %}}/spec/SNFR23) section.

2. Add any (additional) labels that apply.
3. Communicate next steps to the requestor (issue author).
4. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; label.
5. When more detailed plans are available, communicate expected timeline for the update/fix to the requestor (issue author).
6. Once the question/feedback/topic is fully addressed, close the issue.

{{% notice style="note" %}}

If an intended module proposal was mistakenly opened as a "AVM Question/Feedback ❔" or other standard issue, a new issue **MUST** be created in the [AVM repo](https://aka.ms/AVM/repo) using the "New AVM Module Proposal 📝" [issue template](https://aka.ms/avm/moduleproposal). The mistakenly created "AVM Question/Feedback ❔" or other standard issue **MUST** be closed.

{{% /notice %}}
