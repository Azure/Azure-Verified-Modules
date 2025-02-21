---
title: BCPFR7 - Cross-Referencing Modules
url: /spec/BCPFR7
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 10060
---

#### ID: BCPFR7 - Cross-Referencing published Modules

**Resource modules**, that reference other modules (child, utility, or other resource modules), **MUST** disable the telemetry on the referenced modules.

{{% notice style="note" %}}

This only applies to resource modules that reference other modules, such as:

- other resource modules
- utility modules
- child-modules qualifying for publishing, i.e. having a `version.json` file in their directory and exposing the `enableTelemetry` input parameter

For pattern modules, [SFR4]({{% siteparam base %}}/spec/SFR4/) still applies.

{{% /notice %}}

A variable named `enableReferencedModulesTelemetry` is created in the main.bicep file of the module, that cross-references other published modules, and set to `false`. This variable is used to set the `enableTelemetry` parameter of cross-referenced modules.

```Bicep
var enableReferencedModulesTelemetry = false

// local referencing
module virtualNetwork_subnets 'subnet/main.bicep' = [
  for (subnet, index) in (subnets ?? []): {
    name: '${uniqueString(deployment().name, location)}-subnet-${index}'
    params: {
      (...)
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

// published module reference
module virtualNetwork_subnet 'br/public:avm/res/network/virtual-network/subnet:0.1.0' = {
  name: '${uniqueString(deployment().name, location)}-subnet-${index}'
    params: {
      (...)
      enableTelemetry: enableReferencedModulesTelemetry
    }
}
```
