---
title: Bicep Modules
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
---

<!-- This section lists all Azure Verified Modules that are available in or planned for the **Bicep language**.

- [Resource Modules](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules)
- [Pattern Modules](/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules)
- [Utility Modules](/Azure-Verified-Modules/indexes/bicep/bicep-utility-modules)

---

<br> -->

The following table shows the number of all available, orphaned and planned **Bicep Modules**.

{{< moduleStats language="Bicep" moduleType="All" showLanguage=true showClassification=true >}}

<br>

{{< hint type=tip title="Want to contribute to AVM Bicep modules?" >}}

| #  | Labels | Link and description |
| -------- | -------- | -------- |
| 1.   | <mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark> <mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark> <br> <mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>  | To become the **owner of a new Bicep module**, see [all new Bicep modules looking for owners](https://aka.ms/AVM/Bicep/NeedsModuleOwner) or check out the "*Looking for owners*" swimlane [here](https://aka.ms/AVM/Bicep/NeedsModuleOwner/Project). |
| 2.   | <mark style="background-color:#F4A460;">Status: Module Orphaned 👀</mark> <mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>   | To become the **owner of an orphaned Bicep module**, see [all orphaned Bicep modules](https://aka.ms/AVM/Bicep/OrphanedModules) or check out the "*Orphaned*" swimlane [here](https://aka.ms/AVM/Bicep/OrphanedModules/Project).   |
| 3.   | <mark style="background-color:#C95474;color:white;">Needs: Module Contributor 📣</mark> <mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark> | To become a **co-owner or contribute to a Bicep module**, see [all Bicep modules looking for contributors](https://aka.ms/AVM/Bicep/NeedsModuleContributor). |

For more details on "**What are the different ways to contribute to AVM?**", see [here](/Azure-Verified-Modules/faq/#are-there-different-ways-to-contribute-to-avm).

{{< /hint >}}

<br>

---

## Status Badges

This section gives you an overview of a the latest workflow status of each AVM module in the [Public Bicep Registry repository](https://github.com/Azure/bicep-registry-modules).

{{< hint type="note" >}}
While some pipelines can momentarily show as red, a new module version cannot be published without a successful test run. Failing test may indicate a recent change to the platform that is causing a break in the module or any intermittent errors, such as a periodic test deployment attempting to create a resource with a name already taken in another Azure region.
{{< /hint >}}

{{< include file="static/includes/module-features/bicepBadges.md" >}}
