---
title: BRM Issue Triage
description: Issue Triage description for the Bicep Registry Modules (BRM) repository
---


## Overview

This page provides guidance for **Bicep module owners** on how to triage **AVM module issues** and **AVM question/feedback** items filed in the [BRM repository](https://aka.ms/BRM) (Bicep Registry Modules repository - where all Bicep AVM modules are published), as well as how to manage these GitHub issues throughout their lifecycle.

As such, **the following issues are to be filed in the BRM repository**:

- **\[[AVM Module Issue](https://aka.ms/BRM/AVMModuleIssue)]**: Issues specifically related to an existing AVM module, such as feature requests, bug and security bug reports.
- **\[[AVM Question/Feedback](https://aka.ms/BRM/AVMQuestionFeedback)]**:Generic feedback and questions, related to existing AVM module, the overall framework, or its automation (CI environment).

Do **NOT** file the following types of issues in the **BRM repository**, as they **MUST** be tracked in the **AVM repo**:

- **\[[Module Proposal](https://aka.ms/AVM/ModuleProposal)]**: Proposals for new AVM modules.
- **\[[Orphaned Module](https://aka.ms/AVM/OrphanedModule)]**: Indicate that a module is orphaned (has no owner).
- **\[[Question/Feedback](https://aka.ms/AVM/QuestionFeedback)]**: Generic questions/requests related to the AVM site or documentation.

{{% notice style="note" %}}
Every module needs a module proposal to be created in the AVM repository.
{{% /notice %}}

## Module Owner Responsibilities

During the triage process, module owners are expected to check, complete and follow up on the items described in the sections below.

Module owners **MUST** meet the SLAs defined on the [Module Support]({{% siteparam base %}}/help-support/module-support/) page! While there's automation in place to support meeting these SLAs, module owners **MUST** check for new issues on a regular basis.

{{% notice style="important" %}}
The [BRM repository](https://aka.ms/BRM) includes other, non-AVM modules and related GitHub issues. As a module owner, make sure you're only triaging, managing or otherwise working on issues that are related to AVM modules!
{{% /notice %}}

{{% notice style="tip" %}}

- To look for items that **need triaging**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsTriage">&nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp;</a> ⬅️.
- To look for items that **need attention**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsAttention">&nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#E99695;color:white;">Needs: Attention 👋</mark>&nbsp;</a> ⬅️.
- Open items that are <a href="https://aka.ms/BRM/NotInAProject">**not in a project**</a>.

{{% /notice %}}

## Module Issue

An issue is considered to be an "AVM module issue" if

- it was opened through the **\[[AVM Module Issue](https://aka.ms/BRM/AVMModuleIssue)]** template in the [BRM repository](https://aka.ms/BRM),
- it has the labels of &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; and &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>&nbsp; applied to it, and
- it is assigned to the "[AVM - Module Issues](https://github.com/orgs/Azure/projects/566)" GitHub project.

{{% notice style="note" %}}
Module issues can only be opened for existing AVM modules. Module issues **MUST NOT** be used to file a module proposal.

If the issue was opened as a misplaced module proposal, mention the `@Azure/AVM-core-team-technical-bicep` team in the comment section and ask them to move the issue to the AVM repository.
{{% /notice %}}

### Triaging a Module Issue

1. Check the Module issue:
    - Make sure the issue has the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>&nbsp; applied to it.
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

1. If the **PR is submitted by the module owner** and the **module is owned by a single person**, **the AVM core team must review and approve the PR**, (as the module owner can't approve their on PR).
    - To indicate that the PR needs the core team's attention, apply the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>&nbsp; label.
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
- **Module name**: Add the module's full name between backticks ( ` ) to make it pop.

{{% /notice %}}

{{% notice style="info" title="Who needs to approve the PR?" %}}

The PR approval logic for existing modules is the following:

{{% include file="/static/includes/PR-approval-guidance.md" %}}

This behavior is assisted by bots, through automatic assignment of the expected reviewer(s) and supporting labels.

In case of Bicep modules, if the PR includes any changes outside of the "modules/" folder, it first needs the module related code changes need to be reviewed and approved as per the above table, and only then does the PR need to be approved by a member of the core team. This way the core team's approval does not act as a bypass from the actual code review perspective.

{{% /notice %}}

## General Question/Feedback and other standard issues

An issue is considered to be an "AVM Question/Feedback" if

- it was opened through the **\[[AVM Question/Feedback](https://aka.ms/BRM/AVMQuestionFeedback)]** template in the [BRM repository](https://aka.ms/BRM),
- it has the labels of &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp;, &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#CB6BA2;">Type: Question/Feedback 🙋‍♀️</mark>&nbsp; and &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>&nbsp; applied to it, and
- it is assigned to the "[AVM - Issue Triage](https://github.com/orgs/Azure/projects/538)" GitHub project.

An issue is considered to be a "standard issue" or "blank issue" if it was opened without using an issue template, and hence it does **NOT** have any labels assigned, OR only has the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FBCA04;">Needs: Triage 🔍</mark>&nbsp; label assigned.

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
