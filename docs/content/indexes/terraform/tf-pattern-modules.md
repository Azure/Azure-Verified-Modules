---
draft: false
title: Terraform Pattern Modules
linktitle: Pattern Modules
weight: 2
description: Terraform Pattern Module Index showing all available, orphaned and planned modules
---

## Module catalog

{{% moduleStats language="Terraform" moduleType="Pattern" showLanguage=true showClassification=true %}}

{{% expand title="➕ Additional information" %}}

{{% notice style="grey" title="Legend" %}}
{{% include file="/static/includes/module-status-legend.md" %}}
{{% /notice %}}

{{% notice style="info" %}}

This page contains various views of the module index (catalog) for **Terraform Pattern Modules**. To see these views, **click on the expandable sections** with the "➕" sign below.

- {{% icon icon="fa-brands fa-github" %}} To see the **full, unfiltered, unformatted module catalog** on GitHub, click [here](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/v1/modules.json).

- {{% icon icon="download" %}} To download the source catalog JSON file, click [here]({{% siteparam base %}}/module-indexes/v1/modules.json).

{{% /notice %}}

{{% notice style="note" %}}

Modules listed below that aren't shown with the status of **`Module Available 🟢`**, are currently in development and are not yet available for use. For proposed modules, see the [Proposed modules]({{% siteparam base %}}/indexes/terraform/tf-pattern-modules/#proposed-modules---) section below.

{{% /notice %}}

{{% /expand %}}

### Published modules - 🟢 & 🟡

{{% expand title="➕ Published Modules - Module names, status and owners" expanded="true" %}}

{{% moduleNameStatusOwners header=true language="Terraform" moduleType="pattern" include="Available,Orphaned" %}}

{{% /expand %}}

### Proposed modules - ⚪

{{% expand title="➕ Proposed Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true language="Terraform" moduleType="pattern" include="Proposed" %}}

{{% /expand %}}

### Deprecated modules - 🔴

{{% expand title="➕ Deprecated Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true language="Terraform" moduleType="pattern" include="Deprecated" %}}

{{% /expand %}}

### All modules - 📇

{{% expand title="➕ All Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true language="Terraform" moduleType="pattern" include="Available,Orphaned,Proposed,Deprecated" %}}

{{% /expand %}}

### Module Publication History - 📅

{{% expand title="➕ Module Publication History - Module names, status and owners" expanded="false" %}}

{{% moduleHistory header=true language="Terraform" moduleType="pattern" exclude="Proposed" monthsToShow=9999 %}}

{{% /expand %}}
