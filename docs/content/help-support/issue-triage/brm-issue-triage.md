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

- **\[[Module Proposal](https://aka.ms/AVM/ModuleProposal)]**: Proposals for new AVM modules, or for migrating existing CARML/TFVM modules to AVM.
- **\[[Orphaned Module](https://aka.ms/AVM/OrphanedModule)]**: Indicate that a module is orphaned (has no owner).
- **\[[Question/Feedback](https://aka.ms/AVM/QuestionFeedback)]**: Generic questions/requests related to the AVM site or documentation.

{{< hint type=note >}}
Every module needs a module proposal to be created in the AVM repository. This applies to both net new modules, as well as modules that are to be migrated from CARML/TFVM!
{{< /hint >}}

## Module Owner Responsibilities

During the triage process, module owners are expected to check, complete and follow up on the items described in the sections below.

Module owners **MUST** meet the SLAs defined on the [Module Support](/Azure-Verified-Modules/help-support/module-support/) page! Whilst there's automation in place to support meeting these SLAs, module owners **MUST** check for new issues on a regular basis.

{{< hint type=important >}}
The [BRM repository](https://aka.ms/BRM) includes other, non-AVM modules and related GitHub issues. As a module owner, make sure you're only triaging, managing or otherwise working on issues that are related to AVM modules!
{{< /hint >}}

{{< hint type=tip >}}

- To look for items that **need triaging**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsTriage"><mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark></a> ⬅️.
- To look for items that **need attention**, click on the following link to use this saved query ➡️ <a href="https://aka.ms/BRM/AVMNeedsAttention"><mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark></a> ⬅️.

{{< /hint >}}

<br>

## Module Issue

An issue is considered to be an AVM module issue if it was opened through the **\[[AVM Module Issue](https://aka.ms/BRM/AVMModuleIssue)]** template in the BRM repository, and has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it.

{{< hint type=note >}}
Module issues can only be opened for existing AVM modules. Module issues **MUST NOT** be used to file a module proposal.

If the issue was opened as a misplaced module proposal, mention the `@Azure/AVM-core-team` in the comment section to have the issue moved to the AVM repository.
{{< /hint >}}

1. Add the "<mark style="background-color:#E4E669;">Status: In Triage 🔍</mark>" label to indicate you're in the process of triaging the issue.
- make sure the issue has the "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it

- make sure the issue is categorized using one of the following type labels:
  - "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>"
  - "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>"
  - "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>"

- the module to which the issue applies must be identified
  - if the issue applies to a specific version of the module, make sure to include the version number in the issue title
  - if the issue applies to all versions of the module, make sure to include the module name in the issue title
  - if the issue applies to multiple modules, make sure to include the module names in the issue title
- use the AVM module indexes to identify the module owner(s)
- assign the issue to the module owner(s)
- if the module is orphaned (has no owner), make sure there's an orphaned module issue in the AVM repository
- Apply relevant labels
    - Module language: "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" or "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>"
    - Module classification (resource/pattern): "<mark style="background-color:#D3D3D3;">Class: Resource Module 📦</mark>" or "<mark style="background-color:#A9A9A9;">Class: Pattern Module 📦</mark>"

if the module w

## General Question/Feedback

An issue is considered to be an AVM Question/Feedback if it was opened through the **\[[AVM Question/Feedback](https://aka.ms/BRM/AVMQuestionFeedback)]** template in the BRM repository, and has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#CB6BA2;">Type: Question/Feedback 🙋‍♀️</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" applied to it.
