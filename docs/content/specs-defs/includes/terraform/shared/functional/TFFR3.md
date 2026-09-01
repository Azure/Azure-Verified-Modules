---
title: TFFR3 - Providers - Permitted Versions
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR3
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TF/CI/Enforced # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20030
---

## ID: TFFR3 - Category: Providers - Permitted Versions

The AVM provider rules are documented in [avm_provider_azapi_version_constraint]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_provider_azapi_version_constraint), [avm_provider_azurerm_disallowed]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_provider_azurerm_disallowed), and [avm_provider_azurerm_version_constraint]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_provider_azurerm_version_constraint).

{{% notice style="important" %}}

Every new AVM Terraform module — resource, pattern, or utility — **MUST** use `Azure/azapi` for every Azure control-plane resource and every data-plane operation supported by AzAPI. The AzureRM provider is permitted only for the unsupported data-plane/non-ARM API exception defined below.

{{% /notice %}}

Authors **MUST** only use the following Azure providers, and versions, in their modules:

| provider | min version | max version | permitted use |
| --- | --- | --- | --- |
| Azure/azapi | >= 2.12 | < 3.0 | All Azure control-plane resources and supported data-plane operations |
| hashicorp/azurerm | >= 4.0 | < 5.0 | Only a specific unsupported data-plane/non-ARM API operation under the exception below |

Pattern modules **MAY** also use other Microsoft-maintained providers when required by the pattern. Examples include `integrations/github`, `microsoft/azuredevops`, `microsoft/fabric`, and `microsoft/msgraph`. Each provider **MUST** be declared with minimum and maximum major version constraints as required by [TFNFR26]({{% siteparam base %}}/spec/TFNFR26).

Resource and utility modules **MUST NOT** use these additional providers. Except for the narrow AzureRM exception below, third-party providers **MUST NOT** be used by any AVM Terraform module, regardless of module classification.

{{% notice style="note" %}}

The AzAPI floor is `2.12` because [TFFR8]({{% siteparam base %}}/spec/TFFR8) requires every module to expose the `ignore_body_changes` argument, which was introduced in `Azure/azapi` v2.12.0. Modules pinned below that version will fail to plan because the argument is absent from the provider schema.

{{% /notice %}}

This prohibition applies to every Terraform configuration shipped with the module, including:

- The root module and all submodules.
- Every configuration under `examples/`, including examples executed as end-to-end tests.
- Terraform tests, test fixtures, and supporting setup configurations.
- Terraform snippets in `_header.md`, `_footer.md`, generated documentation, and other repository documentation.

Supporting control-plane resources needed by an example, end-to-end test, or fixture **MUST** use AzAPI. AzureRM **MUST NOT** be used for resource groups, role assignments, monitoring resources, networking, or any other ARM control-plane resource.

### Exception — unsupported data-plane/non-ARM API operations

An AVM Terraform module that is otherwise built with AzAPI **MAY** declare the AzureRM provider only for a specific data-plane or non-ARM API operation whose functionality is genuinely unavailable through `azapi_data_plane_resource`, `azapi_resource`, `azapi_resource_action`, or `azapi_update_resource`. This exception is intended for isolated operations such as a data-plane resource whose AzureRM implementation calls a service endpoint rather than Azure Resource Manager. It is not a general fallback for a missing or inconvenient AzAPI schema. Every `azurerm_*` block **MUST** independently satisfy this exception; one permitted block does not authorize any other AzureRM use.

Where this exception applies, the module **MUST**:

- Continue to declare and use AzAPI as its required, primary Azure provider.
- Scope every `azurerm_*` resource or data source to the exact unsupported data-plane/non-ARM operation.
- Pin the AzureRM provider to `~> 4.0` in `required_providers`.
- Use AzAPI for every control-plane resource and every data-plane operation that AzAPI supports.
- Document the exception in the module's `README.md`, including each `azurerm_*` block, the data-plane/non-ARM API it wraps, why AzAPI cannot implement it, and the upstream AzAPI issue or pull request tracking support.
- Replace the `azurerm_*` block with AzAPI in the next module release after the required capability ships.
- Add the following TFLint exclusion:

  ```hcl
  rule "avm_provider_azurerm_disallowed" {
    enabled = false
  }
  ```

Examples, end-to-end tests, Terraform tests, fixtures, and documentation snippets **MAY** configure or exercise AzureRM only when required by that exact permitted data-plane operation. All supporting control-plane resources in those surfaces **MUST** use AzAPI.

This exception **MUST NOT** be used to:

- Implement any ARM control-plane resource.
- Avoid AzAPI because its body schema is more verbose or less convenient.
- Avoid raising an AzAPI capability gap for an unsupported control-plane operation.
- Side-step any AzAPI-specific specification that applies to the module's AzAPI resources.

The `azurerm` remote state backend and the final segment of a published Terraform Registry module address, such as `/azurerm` in an existing AVM module source, are names and are not provider declarations. They **MAY** appear where required for state storage or to reference an existing published AVM module. A dependency's provider implementation is governed by that dependency's own repository; its Registry address does not by itself justify a direct `hashicorp/azurerm` declaration or `azurerm_*` block in the consuming module repository. Any such direct use **MUST** independently satisfy the data-plane exception above.

Authors **MUST** use the `required_providers` block in their module to enforce the provider versions.

The following is an example.

- In it we use the [pessimistic version constraint operator](https://developer.hashicorp.com/terraform/language/expressions/version-constraints#operators) `~>`.
- That is to say that `~> 2.12` is equivalent to `>= 2.12, < 3.0`.

```terraform
terraform {
  required_providers {
    # AzAPI is required for every AVM Terraform module.
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
  }
}
```
