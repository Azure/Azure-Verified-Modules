---
title: TFNFR27 - Provider Declarations in Modules
url: /spec/TFNFR27
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
priority: 21270
---

#### ID: TFNFR27 - Category: Code Style - Provider Declarations in Modules

[By rules](https://www.terraform.io/docs/language/modules/develop/providers.html), in the module code `provider` **MUST NOT** be declared. The only exception is when the module indeed need different instances of the same kind of `provider`(Eg. manipulating resources across different `location`s or accounts), you **MUST** declare `configuration_aliases` in `terraform.required_providers`. See details in this [document](https://www.terraform.io/docs/language/providers/configuration.html#alias-multiple-provider-configurations).

`provider` block declared in the module **MUST** only be used to differentiate instances used in  `resource` and `data`. Declaration of fields other than `alias` in `provider` block is strictly forbidden. It could lead to module users unable to utilize `count`, `for_each` or `depends_on`. Configurations of the `provider` instance **SHOULD** be passed in by the module users.

Good examples:

In verified module:

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [ azurerm.alternate ]
    }
  }
}
```

In the root module where we call this verified module:

````terraform
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "alternate"
  features {}
}

module "foo" {
  source = "xxx"
  providers = {
    azurerm = azurerm
    azurerm.alternate = azurerm.alternate
  }
}
````

Bad example:

In verified module:

```terraform
provider "azurerm" {
  # Configuration options
  features {}
}
