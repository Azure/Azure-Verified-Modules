---
title: SFR5 - Availability Zones
url: /spec/SFR5
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
priority: 50
---

#### ID: SFR5 - Category: Composition - Availability Zones

Modules that deploy ***zone-redundant*** resources **MUST** enable the spanning across as many zones as possible by default, typically all 3.

Modules that deploy ***zonal*** resources **MUST** provide the ability to specify a zone for the resources to be deployed/pinned to. However, they **MUST NOT** default to a particular zone by default, e.g. `1` in an effort to make the consumer aware of the zone they are selecting to suit their architecture requirements.

For both scenarios the modules **MUST** expose these configuration options via configurable parameters/variables.

{{< hint type=note >}}

For information on the differences between zonal and zone-redundant services, see [Availability zone service and regional support](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support)

{{< /hint >}}
