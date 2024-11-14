---
title: TFNFR25 - Verified Modules Requirements
url: /spec/TFNFR25
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
priority: 21250
---

#### ID: TFNFR25 - Category: Code Style - Verified Modules Requirements

The `terraform.tf` file **MUST** only contain one `terraform` block.

The first line of the `terraform` block **MUST** define a `required_version` property for the Terraform CLI.

The `required_version` property **MUST** include a constraint on the minimum version of the Terraform CLI. Previous releases of the Terraform CLI can have unexpected behavior.

The `required_version` property **MUST** include a constraint on the maximum major version of the Terraform CLI. Major version releases of the Terraform CLI can introduce breaking changes and **MUST** be tested.

The `required_version` property constraint **MAY** use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

***Note: You can read more about Terraform version constraints in the [documentation](https://developer.hashicorp.com/terraform/language/expressions/version-constraints).***

Example `terraform.tf` file:

```terraform
terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.11"
    }
  }
}
```
