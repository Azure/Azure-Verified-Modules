---
title: TFNFR36 - Legacy AzureRM resource group deletion behavior
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR36
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21360
---

## ID: TFNFR36 - Category: Code Style - Legacy AzureRM resource group deletion behavior

{{% notice style="warning" %}}

This specification applies only to existing legacy modules that still use AzureRM while they are being migrated. It does not apply to a new module that uses AzureRM solely for the narrow unsupported data-plane/non-ARM API exception in [TFFR3]({{% siteparam base %}}/spec/TFFR3), because that exception does not permit AzureRM resource-group management.

{{% /notice %}}

In a legacy AzureRM module, the `prevent_deletion_if_contains_resources` provider setting **SHOULD** be set to `false` until the module is migrated. Azure Policy remediation can add resources during a test run, and the provider's default behavior can then prevent cleanup of the test resource group.
