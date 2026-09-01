---
title: TFNFR27 - Provider Declarations in Modules
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR27
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21270
---

## ID: TFNFR27 - Category: Code Style - Provider Declarations in Modules

[By rule](https://developer.hashicorp.com/terraform/language/modules/develop/providers), every published AVM module and submodule **MUST NOT** declare a `provider` block. Provider configuration belongs exclusively to the consuming root module.

When a module requires an alternate provider instance, it **MUST** declare that alias through `configuration_aliases` in `terraform.required_providers` and the consumer **MUST** pass the configured alias through the module's `providers` map. A provider block containing only `alias` is not permitted in an AVM module.

This is enforced by [avm_terraform_provider_block_disallowed]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_terraform_provider_block_disallowed).

Good examples:

In verified module:

```terraform
terraform {
  required_providers {
    azapi = {
      source                = "Azure/azapi"
      version               = "~> 2.12"
      configuration_aliases = [azapi.alternate]
    }
  }
}
```

In the root module where we call this verified module:

````terraform
provider "azapi" {}

provider "azapi" {
  alias = "alternate"
}

module "foo" {
  source = "xxx"
  providers = {
    azapi           = azapi
    azapi.alternate = azapi.alternate
  }
}
````

Bad example:

In verified module:

```terraform
provider "azapi" {
  alias = "alternate"
}
