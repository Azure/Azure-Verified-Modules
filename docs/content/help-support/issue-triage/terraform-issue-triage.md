---
title: Terraform Issue Triage
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

## Overview

This page provides guidance for **Terraform Module owners** on how to triage **AVM module issues** and **AVM question/feedback** items filed in their Terraform Module Repo(s), as well as how to manage these GitHub issues throughout their lifecycle.

**The following issues can be filed in a Terraform repository**:

- **AVM Module Issue**: Issues specifically related to an existing AVM module, such as feature requests, bug and security bug reports.
- **AVM Question/Feedback**: Generic feedback and questions, related to existing AVM module, the overall framework, or its automation (CI environment).

Do **NOT** file the following types of issues in a **Terraform repository**, as they **MUST** be tracked in the **AVM repo**:

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

{{< hint type=tip >}}

- To look for items that **need triaging**, look for issue labled with ➡️ <mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>⬅️.
- To look for items that **need attention**, look for issue labled with ➡️ <mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark> ⬅️.

{{< /hint >}}

<br>

## Module Issue

An issue is considered to be an "AVM module issue" if

- it was opened through the **AVM Module Issue** template in the Terraform repository,
- it has the label of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" applied to it, and
- it is assigned to the "[AVM - Module Issues](https://github.com/orgs/Azure/projects/566)" GitHub project.

{{< hint type=note >}}
Module issues can only be opened for existing AVM modules. Module issues **MUST NOT** be used to file a module proposal.

If the issue was opened as a misplaced module proposal, mention the `@Azure/AVM-core-team-technical-terraform` team in the comment section and ask them to move the issue to the AVM repository.
{{< /hint >}}

### Triaging a Module Issue

1. Check the Module issue:
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

- it was opened through the **AVM Question/Feedback** template in your Terraform repository,
- it has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#CB6BA2;">Type: Question/Feedback 🙋‍♀️</mark>" applied to it, and
- it is assigned to the "[AVM - Issue Triage](https://github.com/orgs/Azure/projects/538)" GitHub project.

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
