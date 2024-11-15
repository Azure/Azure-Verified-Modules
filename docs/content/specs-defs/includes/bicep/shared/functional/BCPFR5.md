---
title: BCPFR5 - Availability Zones Implementation
url: /spec/BCPFR5
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-Functional,
  Category-Inputs/Outputs,
  Language-Bicep,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 10040
---

#### ID: BCPFR5 - Category: Inputs - Availability Zones Implementation

To implement requirement [SFR5](/Azure-Verified-Modules/specs/shared/#id-sfr5---Category-Naming/Composition---availability-zones), the following convention **SHOULD** apply:

{{< tabs "zones" >}}
  {{< tab "Module accepts multiple zones" >}}
  In this case, the parameter should be implemented like

  ```bicep
  @description('Optional. The Availability Zones to place the resources in.')
  @allowed([
    1
    2
    3
  ])
  param zones int[] = [
    1
    2
    3
  ]

  resource myResource (...) {
    (...)
    properties: {
      (...)
      zones: map(zones, zone => string(zone))
    }
  }
  ```

  {{< /tab >}}
  {{< tab "Module accepts a single zone" >}}
  In this case, the parameter should be implemented using a singular-named `zone` parameter of type `int` like

  ```bicep
  @description('Required. The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.')
  @allowed([
    0
    1
    2
    3
  ])
  param zone int

  resource myResource (...) {
    (...)
    properties: {
      (...)
      zones: zone != 0 ? [ string(zone) ] : null
    }
  }
  ```

  {{< /tab >}}
{{< /tabs >}}
