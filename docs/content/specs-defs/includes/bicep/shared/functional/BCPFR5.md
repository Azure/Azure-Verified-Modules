---
title: BCPFR5 - Availability Zones Implementation
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPFR5
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 10040
---

## ID: BCPFR5 - Category: Inputs - Availability Zones Implementation

To implement requirement [SFR5]({{% siteparam base %}}/spec/SFR5), the following convention **SHOULD** apply:

{{< tabs title="Availability Zones" >}}
{{% tab title="Module accepts multiple zones" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="" >}}
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
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Module accepts a single zone" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="" >}}
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
  {{< /highlight >}}

{{% /tab %}}

{{< /tabs >}}
