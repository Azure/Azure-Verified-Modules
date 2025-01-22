---
draft: false
title: Bicep Resource Modules
linktitle: Resource Modules
weight: 1
---

{{% notice style="info" %}}

This page contains various views of the module index (catalog) for **Bicep Resource Modules**. To see these views, **click on the expandable sections** with the "➕" sign below.

- {{% icon icon="fa-brands fa-github" %}} To see the **full, unfiltered, unformatted module index** on GitHub, click [here](https://github.com/Azure/{{% siteparam base %}}/blob/main/docs/static/module-indexes/BicepResourceModules.csv).

- {{% icon icon="download" %}} To download the source CSV file, click [here]({{% siteparam base %}}/module-indexes/BicepResourceModules.csv).

{{% /notice %}}

## Module catalog

{{% notice style="note" %}}

Modules listed below that aren't shown with the status of **`Module Available 🟢`**, are currently in development and are not yet available for use. For proposed modules, see the [Proposed modules]({{% siteparam base %}}/indexes/bicep/bicep-resource-modules/#proposed-modules---) section below.

{{% /notice %}}

The following table shows the number of all available, orphaned and proposed **Bicep Resource Modules**.

{{% moduleStats language="Bicep" moduleType="Resource" showLanguage=true showClassification=true %}}

### Module Publication History - 📅

{{% expand title="➕ Module Publication History - Module names, status and owners" expanded="false" %}}

{{% moduleHistory header=true csv="/static/module-indexes/BicepResourceModules.csv" language="Bicep" moduleType="resource" exclude="Proposed :new:" monthsToShow=9999 %}}

{{% /expand %}}

---

### Published modules - 🟢 & 👀

{{% expand title="➕ Published Modules - Module names, status and owners" expanded="true" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepResourceModules.csv" language="Bicep" moduleType="resource" exclude="Proposed :new:" %}}

{{% /expand %}}

---

### Proposed modules - 🆕

{{% expand title="➕ Proposed Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepResourceModules.csv" language="Bicep" moduleType="resource" exclude="Available :green_circle:,Orphaned :eyes:" %}}

{{% /expand %}}

---

### All modules - 📇

{{% expand title="➕ All Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/BicepResourceModules.csv" language="Bicep" moduleType="resource" %}}

{{% /expand %}}

---

## For Module Owners & Contributors

{{% notice style="note" %}}

This section is mainly intended **for module owners and contributors** as it contains information important for module development, such as **telemetry ID prefix, and GitHub Teams for Owners & Contributors**.

{{% /notice %}}

### Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors

{{% expand title="➕ All Modules - Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors" expanded="false" %}}

{{% moduleNameTelemetryGHTeams header=true csv="/static/module-indexes/BicepResourceModules.csv" language="Bicep" moduleType="resource" %}}

{{% /expand %}}
