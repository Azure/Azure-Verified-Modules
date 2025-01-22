---
title: SNFR25 - Resource Naming
url: /spec/SNFR25
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1010
---

#### ID: SNFR25 - Category: Composition - Resource Naming

Module owners **MUST** set the default resource name prefix for child, extension, and interface resources to the associated abbreviation for the specific resource as documented in the following CAF article [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), if specified and documented. This reduces the amount of input values a module consumer **MUST** provide by default when using the module.

For example, a Private Endpoint that is being deployed as part of a resource module, via the mandatory interfaces, **MUST** set the Private Endpoint's default name to begin with the prefix of `pep-`.

Module owners **MUST** also provide the ability for these default names, including the prefixes, to be overridden via a parameter/variable if the consumer wishes to.

Furthermore, as per [RMNFR2]({{% siteparam base %}}/spec/RMNFR2), Resource Modules **MUST** not have a default value specified for the name of the primary resource and therefore the name **MUST** be provided and specified by the module consumer.

The name provided **MAY** be used by the module owner to generate the rest of the default name for child, extension, and interface resources if they wish to. For example, for the Private Endpoint mentioned above, the full default name that can be overridden by the consumer, **MAY** be `pep-<primary-resource-name>`.

{{% notice style="tip" %}}

If the resource does not have a documented abbreviation in [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), then the module owner is free to use a sensible prefix instead.

{{% /notice %}}
