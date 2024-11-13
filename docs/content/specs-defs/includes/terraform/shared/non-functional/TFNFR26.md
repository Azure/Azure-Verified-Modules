---
title: TFNFR26 - Providers in required_providers
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-CodeStyle,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 260
---

#### ID: TFNFR26 - Category: Code Style - Providers in required_providers

The `terraform` block in `terraform.tf` **MUST** contain the `required_providers` block.

Each provider used directly in the module **MUST** be specified with the `source` and `version` properties. Providers in the `required_providers` block **SHOULD** be sorted in alphabetical order.

Do not add providers to the `required_providers` block that are not directly required by this module. If submodules are used then each submodule **SHOULD** have its own `versions.tf` file.

The `source` property **MUST** be in the format of `namespace/name`. If this is not explicitly specified, it can cause failure.

The `version` property **MUST** include a constraint on the minimum version of the provider. Older provider versions may not work as expected.

The `version` property **MUST** include a constraint on the maximum major version. A provider major version release may introduce breaking change, so updates to the major version constraint for a provider **MUST** be tested.

The `version` property constraint **MAY** use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

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
