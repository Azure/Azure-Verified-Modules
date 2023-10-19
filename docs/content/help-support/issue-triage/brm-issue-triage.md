---
title: BRM Issue Triage
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

## Module triage

This section provides guidance for **Bicep module owners** on how to **triage AVM module issues** and **generic AVM feedback/question items** filed in the [BRM repository](https://aka.ms/BRM), as well as how to manage these GitHub issues throughout their lifecycle.

During the module owner triage, the following will be checked, completed and actioned by the AVM module owner.

{{< hint type=note >}}
Every module needs a module proposal to be created in the AVM repository This applies to both net new modules, as well as modules that are to be migrated from CARML/TFVM!
{{< /hint >}}

{{< hint type=tip >}}
To look for items that need triaging, click on the following link to use this saved query ➡️ <a href="https://aka.ms/AVM/NeedsTriage"><mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark></a> ⬅️.
{{< /hint >}}

<br>

## Module Proposal triage

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

## General feedback/question and other standard issues
