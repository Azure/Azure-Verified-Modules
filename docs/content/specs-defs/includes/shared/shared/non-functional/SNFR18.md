---
title: SNFR18 - Breaking Changes
url: /spec/SNFR18
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Release/Publishing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1220
---

#### ID: SNFR18 - Category: Release - Breaking Changes

A module **SHOULD** avoid breaking changes, e.g., deprecating inputs vs. removing. If you need to implement changes that cause a breaking change, the major version should be increased.

{{% notice style="info" %}}

Modules that have not been released as `1.0.0` may introduce breaking changes, as explained in the previous ID [SNFR17]({{% siteparam base %}}/spec/SNFR17). That means that you have to introduce non-breaking and breaking changes with a minor version jump, as long as the module has not reached version `1.0.0`.

{{% /notice %}}

There are, however, scenarios where you want to include breaking changes into a commit and not create a new major version. If you want to introduce breaking changes as part of a minor update, you can do so. In this case, it is essential to keep the change backward compatible, so that the existing code will continue to work. At a later point, another update can increase the major version and remove the code introduced for the backward compatibility.

{{% notice style="tip" %}}

See the language specific examples to find out how you can deal with deprecations in AVM modules.

- [Bicep]({{% siteparam base %}}/contributing/bicep/composition/#deprecation)

{{% /notice %}}
