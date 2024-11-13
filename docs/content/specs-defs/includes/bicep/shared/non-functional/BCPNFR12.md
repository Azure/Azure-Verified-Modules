---
title: BCPNFR12 - Deployment Test Naming
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Testing,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 120
---

#### ID: BCPNFR12 - Category: Testing - Deployment Test Naming

Module owners **MUST** invoke the module in their test using the syntax:

```bicep
module testDeployment '../../../main.bicep' =
```

Example 1: Working example with a single deployment

```bicep
module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    (...)
  }
}
```

Example 2: Working example using a deployment loop

```bicep
@batchSize(1)
module testDeployment '../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    (...)
  }
}]
```

The syntax is used by the ReadMe-generating utility to identify, pull & format usage examples.
