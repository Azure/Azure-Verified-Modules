---
title: BCPNFR24 - Deterministic Deployment Names
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPNFR24
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-BCP/Manual # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11024
---

## ID: BCPNFR24 - Category: Naming/Composition - Deterministic Deployment Names

When a module references child, utility, or other modules, the deployment name **MUST** be **deterministic**. This means the deployment name must produce the same value for the same set of inputs across repeated deployments.

{{% notice style="note" title="Why deterministic?" %}}

Azure Resource Manager has an [800-deployment limit](https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits) per scope (resource group, subscription, management group). Non-deterministic names (e.g., those incorporating timestamps or `utcNow()`) create a new deployment object on every run, which can lead to this limit being reached over time. While a cleanup process exists today, it does not yet meet the needs of all scenarios, particularly at subscription and management group scopes. We are actively working with the product team to enhance this process. In the meantime, deterministic deployment names provide a reliable way to keep deployment counts stable.

Deterministic deployment names cause Azure to **overwrite** the previous deployment object, keeping the deployment count stable regardless of how many times the module is deployed.

{{% /notice %}}

### Requirement

Module owners **MUST** construct deployment names for referenced modules using `uniqueString()` seeded with the **parent resource's ID** (`<parentResource>.id`) and **`location`**, rather than `deployment().name`, `subscription().id`, `resourceGroup().id`, `utcNow()`, or other non-deterministic or scope-level values.

The deployment name **MUST** follow the pattern:

```text
'${uniqueString(<parentResource>.id, location)}-<ChildModuleDescriptor>-${index}'
```

Where:

| Segment | Description |
|---|---|
| `uniqueString(<parentResource>.id, location)` | A deterministic hash derived from the parent resource's resource ID and deployment location. This is both unique per resource instance and stable across deployments. |
| `<ChildModuleDescriptor>` | A short, human-readable label identifying the child module being deployed (e.g., `DB`, `Subnet`, `FederatedIdentityCred`). |
| `${index}` | The loop index variable, included when deploying in a loop. Omit for single (non-looped) deployments. |

### Why parent resource ID?

Using the parent resource's ID as the `uniqueString` seed provides two critical properties:

1. **Deterministic** — the same parent resource always produces the same hash, so repeated deployments overwrite rather than accumulate.
2. **Collision-free** — different parent resource instances produce different hashes, so deploying multiple instances of the same module type within the same scope does not cause naming collisions.

{{% notice style="tip" title="Why not subscription().id and resourceGroup().id separately?" %}}

The parent resource's ID (e.g., `/subscriptions/.../resourceGroups/.../providers/.../resourceName`) already contains the subscription ID and resource group ID as segments. Using `<parentResource>.id` as a single input to `uniqueString` captures all of this context in one value, keeping the code concise and readable rather than passing multiple scope-level values separately.

{{% /notice %}}

{{% notice style="note" title="Supporting multiple deployments of the same module at the same scope" %}}

A common scenario is deploying the same module type more than once within the same scope — for example, two different SQL servers each with their own set of databases, or two user-assigned identities each with their own federated credentials. Because the parent resource ID is unique per resource instance, the resulting deployment names will differ even when the child module type and index are identical. This ensures that parallel deployments of the same module at the same scope do not collide.

{{% /notice %}}

{{% notice style="important" title="location parameter" %}}

If `location` is not available, for example when deploying a global resource that does not have a location property, it is acceptable to omit it. However, the `<parentResource>.id` **MUST** always be included as the primary seed for `uniqueString`.

{{% /notice %}}

Other approaches fail on one or both of these properties:

| Approach | Deterministic? | Collision-free? | Issue |
|---|---|---|---|
| `deployment().name` | ❌ | ✅ | Changes every deployment; hits 800-limit |
| `utcNow()` / timestamps | ❌ | ✅ | Changes every deployment; hits 800-limit |
| `subscription().id` + `resourceGroup().id` | ✅ | ❌ | Same hash for all resources in the same RG; collisions when deploying multiple instances |
| **`<parentResource>.id, location`** | **✅** | **✅** | **Recommended — stable and unique per instance** |

### Examples

Example 1: Single child module deployment

```bicep
resource server 'Microsoft.Sql/servers@2023-05-01-preview' = { ... }

module server_database 'database/main.bicep' = {
  name: '${uniqueString(server.id, location)}-Sql-DB'
  params: {
    serverName: server.name
    (...)
  }
}
```

Example 2: Child module deployment in a loop

```bicep
resource server 'Microsoft.Sql/servers@2023-05-01-preview' = { ... }

module server_databases 'database/main.bicep' = [for (database, index) in (databases ?? []): {
  name: '${uniqueString(server.id, location)}-Sql-DB-${index}'
  params: {
    serverName: server.name
    (...)
  }
}]
```
