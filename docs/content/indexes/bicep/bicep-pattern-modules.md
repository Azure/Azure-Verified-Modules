---
draft: false
title: Bicep Pattern Modules
linktitle: Pattern Modules
weight: 2
description: Bicep Pattern Module Index showing all available, orphaned and planned modules
---



## Module catalog

{{% moduleStats language="Bicep" moduleType="Pattern" showLanguage=true showClassification=true %}}

{{% expand title="➕ Additional information" %}}

{{% notice style="grey" title="Legend" %}}
{{% include file="/static/includes/module-status-legend.md" %}}
{{% /notice %}}

{{% notice style="info" %}}

This page contains various views of the module index (catalog) for **Bicep Pattern Modules**. To see these views, **click on the expandable sections** with the "➕" sign below.

- {{% icon icon="fa-brands fa-github" %}} To see the **full, unfiltered, unformatted module index** on GitHub, click [here](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/BicepPatternModules.csv).

- {{% icon icon="download" %}} To download the source CSV file, click [here]({{% siteparam base %}}/module-indexes/BicepPatternModules.csv).

{{% /notice %}}

{{% notice style="note" %}}

Modules listed below that aren't shown with the status of **`Module Available 🟢`**, are currently in development and are not yet available for use. For proposed modules, see the [Proposed modules]({{% siteparam base %}}/indexes/bicep/bicep-pattern-modules/#proposed-modules---) section below.

{{% /notice %}}

{{% /expand %}}

### Published modules - 🟢 & 🟡

{{% expand title="➕ Published Modules - Module names, status and owners" expanded="true" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" include="Available,Orphaned" %}}

{{% /expand %}}

### Proposed modules - ⚪

{{% expand title="➕ Proposed Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" include="Proposed" %}}

{{% /expand %}}

### Deprecated modules - 🔴

{{% expand title="➕ Deprecated Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" include="Deprecated" %}}

{{% /expand %}}

### All modules - 📇

{{% expand title="➕ All Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" include="Available,Orphaned,Proposed,Deprecated" %}}

{{% /expand %}}

### Module Publication History - 📅

{{% expand title="➕ Module Publication History - Module names, status and owners" expanded="false" %}}

{{% moduleHistory header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" exclude="Proposed" monthsToShow=9999 %}}

{{% /expand %}}

## For Module Owners & Contributors

{{% notice style="note" %}}

This section is mainly intended **for module owners and contributors** as it contains the **module names and telemetry ID prefixes** needed for module development.

Module owners obtain access through the [AVM Module Contributors access package]({{% siteparam base %}}/spec/SNFR20#bicep), not per-module GitHub teams. Any `ModuleOwnersGHTeam` values in the source CSV are legacy metadata, not teams to create.

{{% /notice %}}

<a id="module-name-telemetry-id-prefix-github-teams-for-owners"></a>

### Module name and Telemetry ID prefix

{{% expand title="➕ All Modules - Module name and Telemetry ID prefix" expanded="false" %}}

{{% moduleNameTelemetryGHTeams header=true csv="/static/module-indexes/BicepPatternModules.csv" language="Bicep" moduleType="pattern" %}}

{{% /expand %}}
