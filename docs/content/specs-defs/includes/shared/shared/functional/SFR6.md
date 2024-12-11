---
title: SFR6 - Data Redundancy
url: /spec/SFR6
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 60
---

#### ID: SFR6 - Category: Composition - Data Redundancy

Modules that deploy resources or patterns that support data redundancy **SHOULD** enable this to the highest possible value by default, e.g. `RA-GZRS`. When a resource or pattern doesn't provide the ability to specify data redundancy as a simple property, e.g. `GRS` etc., then the modules **MUST** provide the ability to enable data redundancy for the resources or pattern via parameters/variables.

For example, a Storage Account module can simply set the `sku.name` property to `Standard_RAGZRS`. Whereas a SQL DB or Cosmos DB module will need to expose more properties, via parameters/variables, to allow the specification of the regions to replicate data to as per the consumers requirements.

{{< hint type=note >}}

For information on the data redundancy options in Azure, see [Cross-region replication in Azure](https://learn.microsoft.com/en-us/azure/reliability/cross-region-replication-azure)

{{< /hint >}}
