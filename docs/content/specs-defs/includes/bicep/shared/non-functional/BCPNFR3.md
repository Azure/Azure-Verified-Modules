---
title: BCPNFR3 - Usage Example formats
url: /spec/BCPNFR3
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Documentation, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11040
---

#### ID: BCPNFR3 - Category: Documentation - Usage Example formats

Usage examples for Bicep modules **MUST** be provided in the following formats:

- Bicep file (orchestration module style) - `.bicep`

  ```bicep
  module <resourceName> 'br/public:avm/[res|ptn|utl]/<publishedModuleName>:>version<' = {
    name: '${uniqueString(deployment().name, location)}-test-<uniqueIdentifier>'
    params: { (...) }
  }
  ```

- JSON / ARM Template Parameter Files - `.json`

  ```json
  {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": { (...) }
  }
  ```

{{< hint type=note >}}

The above formats are currently automatically taken & generated from the `tests/e2e` tests. It is enough to run the `Set-ModuleReadMe` or `Set-AVMModule` functions (from the `utilities` folder) to update the usage examples in the readme(s).

{{< /hint >}}

{{< hint type=note >}}

Bicep Parameter Files (`.bicepparam`) are being reviewed and considered by the AVM team for the usability and features at this time and will likely be added in the future.

{{< /hint >}}
