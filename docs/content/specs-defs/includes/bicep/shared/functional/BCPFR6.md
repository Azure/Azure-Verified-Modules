---
title: BCPFR6 - Cross-Referencing Child-Modules
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPFR6
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 10050
---

## ID: BCPFR6 - Cross-Referencing Child-Modules

Parent templates **MUST** reference all their direct child-templates to allow for an end-to-end deployment experience.
For example, the SQL server template must reference its child database module and encapsulate it in a loop to allow for the deployment of multiple databases.

```Bicep
@description('Optional. The databases to create in the server')
param databases databaseType[]?

resource server 'Microsoft.Sql/servers@(...)' = { (...) }

module server_databases 'database/main.bicep' = [for (database, index) in (databases ?? []): {
  name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
  params: {
    serverName: server.name
    (...)
  }
}]
```
