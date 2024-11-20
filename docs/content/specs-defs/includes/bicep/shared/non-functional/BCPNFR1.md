---
title: BCPNFR1 - Data Types
url: /spec/BCPNFR1
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 11010
---

#### ID: BCPNFR1 - Category: Inputs - Data Types

To simplify the consumption experience for module consumers when interacting with complex data types input parameters, mainly objects and arrays, the Bicep feature of [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) **MUST** be used and declared.

{{< hint type=tip >}}

User-Defined Types are GA in Bicep as of version v0.21.1, please ensure you have this version installed as a minimum.

{{< /hint >}}

[User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) allow intellisense support in supported IDEs (e.g. Visual Studio Code) for complex input parameters using arrays and objects.

{{< hint type=important title="CARML Migration Exemption" >}}

While the [transition of CARML](/Azure-Verified-Modules/faq/#carml-evolution) modules into AVM is complete, retrofitting [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) for all modules will take a considerable amount of time.

Therefore, the addition of [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) is currently **NOT** mandated/enforced. However, past their initial release, all modules **MUST** implement [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) prior to the release of their next version.

{{< /hint >}}
