---
title: TFNFR26 - Providers in required_providers
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR26
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21260
---

## ID: TFNFR26 - Category: Code Style - Providers in required_providers

The `terraform` block in `terraform.tf` **MUST** contain the `required_providers` block.

Each provider used directly in the module **MUST** be specified with the `source` and `version` properties. Providers in the `required_providers` block **SHOULD** be sorted in alphabetical order.

Do not add providers to the `required_providers` block that are not directly required by this module. If submodules are used then each submodule **SHOULD** have its own `versions.tf` file.

The `source` property **MUST** be in the format of `namespace/name`. If this is not explicitly specified, it can cause failure.

The `version` property **MUST** include a constraint on the minimum version of the provider. Older provider versions may not work as expected.

The `version` property **MUST** include a constraint on the maximum major version. A provider major version release may introduce breaking change, so updates to the major version constraint for a provider **MUST** be tested.

The `version` property constraint **SHOULD** use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

***Note: You can read more about Terraform version constraints in the [documentation](https://developer.hashicorp.com/terraform/language/expressions/version-constraints).***

Good examples:

```terraform
terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

```terraform
terraform {
  required_version = ">= 1.6.6, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.1, < 4.0.0"
    }
  }
}
```

```terraform
terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11, < 4.0"
    }
  }
}
```

Acceptable example (but not recommended):

```terraform
terraform {
  required_version = "1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.11"
    }
  }
}
```

Bad example:

```terraform
terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11"
    }
  }
}
```
