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
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11024
---

## ID: BCPNFR24 - Category: Naming/Composition - Deterministic Deployment Names

When a module references child, utility, or other modules, the deployment name **MUST** be **deterministic**. This means the deployment name must produce the same value for the same set of inputs across repeated deployments.

{{% notice style="note" title="Why deterministic?" %}}

Azure Resource Manager enforces an [800-deployment limit](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits) per scope (resource group, subscription, management group). Non-deterministic names (e.g., those incorporating timestamps or `utcNow()`) create a new deployment object on every run, quickly exhausting this limit — especially at subscription and management group scopes where cleanup is difficult and unreliable.

Deterministic deployment names cause Azure to **overwrite** the previous deployment object, keeping the deployment count stable regardless of how many times the module is deployed.

{{% /notice %}}

### Requirement

Module owners **MUST** construct deployment names for referenced modules using `uniqueString()` seeded with the **parent resource's ID** (`<parentResource>.id`), rather than `deployment().name`, `subscription().id`, `resourceGroup().id`, `utcNow()`, or other non-deterministic or scope-level values.

The deployment name **MUST** follow the pattern:

```text
'${uniqueString(<parentResource>.id)}-<ChildModuleDescriptor>-${index}'
```

Where:

| Segment | Description |
|---|---|
| `uniqueString(<parentResource>.id)` | A deterministic hash derived from the parent resource's resource ID. This is both unique per resource instance and stable across deployments. |
| `<ChildModuleDescriptor>` | A short, human-readable label identifying the child module being deployed (e.g., `DB`, `Subnet`, `FederatedIdentityCred`). |
| `${index}` | The loop index variable, included when deploying in a loop. Omit for single (non-looped) deployments. |

### Why parent resource ID?

Using the parent resource's ID as the `uniqueString` seed provides two critical properties:

1. **Deterministic** — the same parent resource always produces the same hash, so repeated deployments overwrite rather than accumulate.
2. **Collision-free** — different parent resource instances produce different hashes, so deploying multiple instances of the same module type within the same scope does not cause naming collisions.

Other approaches fail on one or both of these properties:

| Approach | Deterministic? | Collision-free? | Issue |
|---|---|---|---|
| `deployment().name` | ❌ | ✅ | Changes every deployment; hits 800-limit |
| `utcNow()` / timestamps | ❌ | ✅ | Changes every deployment; hits 800-limit |
| `subscription().id` + `resourceGroup().id` | ✅ | ❌ | Same hash for all resources in the same RG; collisions when deploying multiple instances |
| **`<parentResource>.id`** | **✅** | **✅** | **Recommended — stable and unique per instance** |

### Examples

Example 1: Single child module deployment

```bicep
resource server 'Microsoft.Sql/servers@2023-05-01-preview' = { ... }

module server_database 'database/main.bicep' = {
  name: '${uniqueString(server.id)}-Sql-DB'
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
  name: '${uniqueString(server.id)}-Sql-DB-${index}'
  params: {
    serverName: server.name
    (...)
  }
}]
```

Example 3: Federated identity credentials on a user-assigned managed identity

```bicep
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = { ... }

module identity_federatedIdentityCredentials 'federated-identity-credential/main.bicep' = [for (credential, index) in (federatedIdentityCredentials ?? []): {
  name: '${uniqueString(userAssignedIdentity.id)}-UserMSI-FederatedIdentityCred-${index}'
  params: {
    userAssignedIdentityName: userAssignedIdentity.name
    (...)
  }
}]
```

{{% notice style="important" %}}

Do **NOT** use any of the following patterns for deployment names in module references:

```bicep
// ❌ Non-deterministic — uses deployment().name which changes each run
name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'

// ❌ Non-deterministic — uses utcNow()
name: '${utcNow()}-Sql-DB-${index}'

// ❌ Deterministic but NOT collision-free — same hash for all resources in a scope
name: '${uniqueString(subscription().id, resourceGroup().id, location)}-Sql-DB-${index}'
```

{{% /notice %}}
