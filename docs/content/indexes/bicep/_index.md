---
title: Bicep Modules
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
---

This section lists all Azure Verified Modules that are available in or planned for the **Bicep language**.

- [Resource Modules](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules)
- [Pattern Modules](/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules)

---

<br>

The following table shows the number of all available, orphaned and planned **Bicep Modules**.

{{< moduleStats language="Bicep" moduleType="All" showLanguage=true showClassification=true >}}

<br>

---

## Status Badges

This section gives you an overview of a the latest workflow status of each AVM module in the [Public Bicep Registry repository](https://github.com/Azure/bicep-registry-modules).

{{< hint type="note" >}}
While some pipelines can momentarily show as red, a new module version cannot be published without a successful test run. Failing test may indicate a recent change to the platform that is causing a break in the module or any intermittent errors, such as a periodic test deployment attempting to create a resource with a name already taken in another Azure region.
{{< /hint >}}

{{< include file="static/includes/module-features/bicepBadges.md" >}}
