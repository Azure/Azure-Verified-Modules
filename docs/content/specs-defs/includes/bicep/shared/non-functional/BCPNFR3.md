---
title: BCPNFR3 - Usage Example formats
url: /spec/BCPNFR3
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Documentation,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 11040
---

#### ID: BCPNFR3 - Category: Documentation - Usage Example formats

Usage examples for Bicep modules **MUST** be provided in the following formats:

- Bicep file (orchestration module style) - `.bicep`

  ```bicep
  module <resourceName> 'br/public:avm/res/<publishedModuleName>:1.0.0' = {
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
