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

{{% notice style="info" %}}

This page contains various views of the module index (catalog) for **Terraform Pattern Modules**. To see these views, **click on the expandable sections** with the "➕" sign below.

- {{% icon icon="fa-brands fa-github" %}} To see the **full, unfiltered, unformatted module index** on GitHub, click [here]({{% siteparam baseURL %}}blob/main/docs/static/module-indexes/TerraformPatternModules.csv).

- {{% icon icon="download" %}} To download the source CSV file, click [here]({{% siteparam base %}}/module-indexes/TerraformPatternModules.csv).

{{% /notice %}}

{{% notice style="note" %}}

Modules listed below that aren't shown with the status of **`Module Available 🟢`**, are currently in development and are not yet available for use. For proposed modules, see the [Proposed modules]({{% siteparam base %}}/indexes/terraform/tf-pattern-modules/#proposed-modules---) section below.

{{% /notice %}}

{{% /expand %}}

### Published modules - 🟢 & 👀

{{% expand title="➕ Published Modules - Module names, status and owners" expanded="true" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Proposed :new:" %}}

{{% /expand %}}

### Proposed modules - 🆕

{{% expand title="➕ Proposed Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Available :green_circle:,Orphaned :eyes:" %}}

{{% /expand %}}

### All modules - 📇

{{% expand title="➕ All Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" %}}

{{% /expand %}}

### Module Publication History - 📅

{{% expand title="➕ Module Publication History - Module names, status and owners" expanded="false" %}}

{{% moduleHistory header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Proposed :new:" monthsToShow=9999 %}}

{{% /expand %}}

## For Module Owners & Contributors

{{% notice style="note" %}}

This section is mainly intended **for module owners and contributors** as it contains information important for module development, such as **telemetry ID prefix, and GitHub Teams for Owners & Contributors**.

{{% /notice %}}

### Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors

{{% expand title="➕ All Modules - Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors" expanded="false" %}}

{{% moduleNameTelemetryGHTeams header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern"%}}

{{% /expand %}}
