---
title: Terraform Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/terraform/
---

{{< hint type=tip >}}

Make sure to checkout the [Shared Specification](/Azure-Verified-Modules/specs/shared/) first before reading further so you understand the specifications items that are shared and agnostic to the IaC language/tool.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

<br>

This page contains the **Terraform specific requirements** for AVM modules (**Resource and Pattern modules**) that ALL Terraform AVM modules **MUST** meet. These requirements are in addition to the [Shared Specification](/Azure-Verified-Modules/specs/shared/) requirements that ALL AVM modules **MUST** meet.

{{< hint type=important >}}

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by Azure Terraform PG/Engineering(@Azure/terraform-avm) and AVM core team(@Azure/avm-core-team).

{{< /hint >}}

{{< hint type=important >}}

Provider Versatility: Users have the autonomy to choose between AzureRM, AzAPI, or a combination of both, tailored to the specific complexity of module requirements.

{{< /hint >}}

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements               | Non-functional requirements                 |
| ------------------------------------------------ | ------------------------------------- | ------------------------------------------- |
| Shared requirements (resource & pattern modules) | [TFFR](#functional-requirements-tffr) | [TFNFR](#non-functional-requirements-tfnfr) |
| Resource module level requirements               | *N/A*                                 | *N/A*                                       |
| Pattern module level requirements                | *N/A*                                 | *N/A*                                       |

<br>

{{< toc >}}

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for Terraform AVM modules (Resource and Pattern).

<br>

### Functional Requirements (TFFR)

{{< hint type=note >}}
This section includes **Terraform specific, functional requirements (TFFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: TFFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules. However, they **MUST** be referenced only by a HashiCorp Terraform registry reference to a pinned version e.g.,

```terraform
module "other-module" {
  source  = "Azure/xxx/azurerm"
  version = "1.2.3"
}
```

They **MUST NOT** use git reference to a module.

```terraform
module "other-module" {
  source = "git::https://xxx.yyy/xxx.git"
}
```

```terraform
module "other-module" {
  source = "github.com/xxx/yyy"
}
```

Modules **MUST NOT** contain references to non-AVM modules.

{{< hint type=tip >}}
See [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) for more information.
{{< /hint >}}

<br>

---

<br>

#### ID: TFFR2 - Category: Outputs - Additional Terraform Outputs

Authors **SHOULD NOT** output entire resource objects as these may contain sensitive outputs and the schema can change with API or provider verisons.
Instead, authors **SHOULD** output the *computed* attributes of the resource as discreet outputs.
This kind of pattern protects against provider schema changes and is known as an [anti-corruption layer](https://learn.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer).

Remember, you **SHOULD NOT** output values that are already inputs (other than `name`).

E.g.

```terraform
# Resource output, computed attribute.
output "foo" {
  description = "MyResource foo attribute"
  value = azurerm_resource_myresource.foo
}

# Resource output for resources that are deployed using `for_each`. Again only computed attributes.
output "childresource_foos" {
  description = "MyResource childs' foo attributes"
  value = {
    for key, value in azurerm_resource_mychildresource : key => value.foo
  }
}

# Output of a sensitive attribute
output "bar" {
  description = "MyResource bar attribute"
  value     = azurerm_resource_myresource.bar
  sensitive = true
}
```

<br>

---

<br>

### Non-Functional Requirements (TFNFR)

{{< hint type=note >}}
This section includes **Terraform specific, non-functional requirements (TFNFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: TFNFR1 - Category: Documentation - Descriptions

Where descriptions for variables and outputs spans multiple lines. The description **MUST** provide variable input examples for each variable using the HEREDOC format and embedded markdown.

Example:

{{< include file="/static/includes/sample.var_example.tf" language="terraform" options="linenos=false" >}}

<br>

---

<br>

#### ID: TFNFR2 - Category: Documentation - Module Documentation Generation

Terraform modules documentation **MUST** be automatically generated via [Terraform Docs](https://github.com/terraform-docs/terraform-docs).

A file called `.terraform-docs.yml` **MUST** be present in the root of the module and have the following content:

{{< include file="/static/includes/terraform-docs.yml" language="yaml" options="linenos=false" >}}

<br>

---

<br>

#### ID: TFNFR3 - Category: Contribution/Support - GitHub Repo Branch Protection

Module owners **MUST** set a branch protection policy on their GitHub Repositories for AVM modules against their default branch, typically `main`, to do the following:

1. Requires a Pull Request before merging
2. Require approval of the most recent reviewable push
3. Dismiss stale pull request approvals when new commits are pushed
4. Require linear history
5. Prevents force pushes
6. Not allow deletions
7. Require CODEOWNERS review
8. Do not allow bypassing the above settings
9. Above settings **MUST** also be enforced to administrators

{{< hint type=tip >}}

If you use the [template repository](/Azure-Verified-Modules/contributing/terraform/#template-repository) as mentioned in the contribution guide, the above will automatically be set.

{{< /hint >}}

<br>

---

<br>

#### ID: TFNFR4 - Category: Composition - Code Styling - lower snake_casing

Module owners **MUST** use [lower snake_casing](https://wikipedia.org/wiki/Snake_case) for naming the following:

- Locals
- Variables
- Outputs
- Resources (symbolic names)
- Modules (symbolic names)

For example: `snake_casing_example` (every word in lowercase, with each word separated by an underscore `_`)

<br>

---

<br>

#### ID: TFNFR5 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [Terraform](https://www.terraform.io/)
  - `terraform <validate/fmt/test>`
- [terrafmt](https://github.com/katbyte/terrafmt)
- [Checkov](https://www.checkov.io/)
- [tflint (with azurerm ruleset)](https://github.com/terraform-linters/tflint-ruleset-azurerm)
- [Go](https://go.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Go for your own tests.

<br>

---

<br>

#### ID: TFNFR6 - Category: Code Style - Resource & Data Order

For the definition of resources in the same file, the resources be depended on come first, after them are the resources depending on others.

Resources have dependencies should be defined close to each other.

<br>

---
<br>

#### ID: TFNFR7 - Category: Code Style - count & for_each Use

<br>

We can use `count` and `for_each` to deploy multiple resources, but the improper use of `count` can lead to [anti pattern](https://github.com/Azure/terraform-robust-module-design/tree/main/looping_for_resources_or_modules/count_index_antipattern).

You can use `count` to create some kind of resources under certain conditions, for example:

```terraform
resource "azurerm_network_security_group" "this" {
  count               = local.create_new_security_group ? 1 : 0
  name                = coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.new_network_security_group_tags
}
```

The module's owners **MUST** use `map(xxx)` or `set(xxx)` as resource's `for_each` collection, the map's key or set's element **MUST** be static literals.

Good example:

```terraform
resource "azurerm_subnet" "pair" {
  for_each             = var.subnet_map // `map(string)`, when user call this module, it could be: `{ "subnet0": "subnet0" }`, or `{ "subnet0": azurerm_subnet.subnet0.name }`
  name                 = "${each.value}"-pair
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

Bad example:

```terraform
resource "azurerm_subnet" "pair" {
  for_each             = var.subnet_name_set // `set(string)`, when user use `toset([azurerm_subnet.subnet0.name])`, it would cause an error.
  name                 = "${each.value}"-pair
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

<br>

---

<br>

#### ID: TFNFR8 - Category: Code Style - Resource & Data Block Orders

There are 3 types of assignment statements in a `resource` or `data` block: argument, meta-argument and nested block. The argument assignment statement is a parameter followed by `=`:

```terraform
location = azurerm_resource_group.example.location
```

or:

```terraform
tags = {
  environment = "Production"
}
```

Nested block is a assignment statement of parameter followed by `{}` block:

```terraform
subnet {
  name           = "subnet1"
  address_prefix = "10.0.1.0/24"
}
```

Meta-arguments are assignment statements can be declared by all `resource` or `data` blocks. They are:

- `count`
- `depends_on`
- `for_each`
- `lifecycle`
- `provider`

The order of declarations within `resource` or `data` blocks is:

All the meta-arguments should be declared on the top of `resource` or `data` blocks in the following order:

1. `provider`
2. `count`
3. `for_each`

Then followed by:

1. required arguments
2. optional arguments
3. required nested blocks
4. optional nested blocks

All ranked in alphabetical order.

These meta-arguments should be declared at the bottom of a `resource` block with the following order:

1. `depends_on`
2. `lifecycle`

The parameters of `lifecycle` block should show up in the following order:

1. `create_before_destroy`
2. `ignore_changes`
3. `prevent_destroy`

parameters under `depends_on` and `ignore_changes` are ranked in alphabetical order.

Meta-arguments, arguments and nested blocked are separated by blank lines.

`dynamic` nested blocks are ranked by the name comes after `dynamic`, for example:

```terraform
  dynamic "linux_profile" {
    for_each = var.admin_username == null ? [] : ["linux_profile"]

    content {
      admin_username = var.admin_username

      ssh_key {
        key_data = replace(coalesce(var.public_ssh_key, tls_private_key.ssh[0].public_key_openssh), "\n", "")
      }
    }
  }
```

This `dynamic` block will be ranked as a block named `linux_profile`.

Code within a nested block will also be ranked following the rules above.

PS: You can use [`avmfix`](https://github.com/lonegunmanb/azure-verified-module-fix) tool to reformat your code automatically.

<br>

---

<br>

#### ID: TFNFR9 - Category: Code Style - Module Block Order

The meta-arguments below should be declared on the top of a `module` block with the following order:

1. `source`
2. `version`
3. `count`
4. `for_each`

blank lines will be used to separate them.

After them will be required arguments, optional arguments, all ranked in alphabetical order.

These meta-arguments below should be declared on the bottom of a `resource` block in the following order:

1. `depends_on`
2. `providers`

Arguments and meta-arguments should be separated by blank lines.

<br>

---

<br>

#### ID: TFNFR10 - Category: Code Style - No Double Quotes in ignore_changes

Good example:

```hcl
lifecycle {
    ignore_changes = [
      tags,
    ]
}
```

Bad example:

```hcl
lifecycle {
    ignore_changes = [
      "tags",
    ]
}
```

<br>

---

<br>

#### ID: TFNFR11 - Category: Code Style - Null Comparison Toggle

Sometimes we need to ensure that the resources created compliant to some rules at a minimum extent, for example a `subnet` has to connected to at least one `network_security_group`. The user may pass in a `security_group_id` and ask us to make a connection to an existing `security_group`, or want us to create a new security group.

Intuitively, we will define it like this:

```terraform
variable "security_group_id" {
  type = string
}

resource "azurerm_network_security_group" "this" {
  count               = var.security_group_id == null ? 1 : 0
  name                = coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.new_network_security_group_tags
}
```

The disadvantage of this approach is if the user create a security group directly in the root module and use the `id` as a `variable` of the module, the expression which determines the value of `count` will contain an `attribute` from another `resource`, the value of this very `attribute` is "known after apply" at plan stage. Terraform core will not be able to get an exact plan of deployment during the "plan" stage.

You can't do this:

```terraform
resource "azurerm_network_security_group" "foo" {
  name                = "example-nsg"
  resource_group_name = "example-rg"
  location            = "eastus"
}

module "bar" {
  source = "xxxx"
  ...
  security_group_id = azurerm_network_security_group.foo.id
}
```

For this kind of parameters, wrapping with `object` type is recommended：

```terraform
variable "security_group" {
  type = object({
    id   = string
  })
  default     = null
}
```

The advantage of doing so is encapsulating the value which is "known after apply" in an object, and the `object` itself can be easily found out if it's `null` or not. Since the `id` of a `resource` cannot be `null`, this approach can avoid the situation we are facing in the first example, like the following:

```terraform
resource "azurerm_network_security_group" "foo" {
  name                = "example-nsg"
  resource_group_name = "example-rg"
  location            = "eastus"
}

module "bar" {
  source = "xxxx"
  ...
  security_group = {
    id = azurerm_network_security_group.foo.id
  }
}
```

Please use this technique under this use case only.

<br>

---

<br>

#### ID: TFNFR12 - Category: Code Style - Dynamic for Optional Nested Objects

An example from the community:

```terraform
resource "azurerm_kubernetes_cluster" "main" {
  ...
  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? [1] : []

    content {
      type                      = var.identity_type
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }
  ...
}
```

Please refer to the coding style in the example. If you just want to declare some nested block under conditions, please use:

```terraform
for_each = <condition> ? [<some_item>] : []
```

<br>

---

<br>

#### ID: TFNFR13 - Category: Code Style - Default Values with coalesce/try

The following example shows how to use `"${var.subnet_name}-nsg"` when `var.new_network_security_group_name` is `null` or `""`

Good examples:

```terraform
coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
```

```terraform
try(coalesce(var.new_network_security_group.name, "${var.subnet_name}-nsg"), "${var.subnet_name}-nsg")
```

Bad examples:

```terraform
var.new_network_security_group_name == null ? "${var.subnet_name}-nsg" : var.new_network_security_group_name)
```

<br>

---

<br>

#### ID: TFNFR14 - Category: Inputs - Not allowed variables

Since Terraform 0.13, `count`, `for_each` and `depends_on` are introduced for modules, module development is significantly simplified. Module's owners **MUST NOT** add variables like `enabled` or `module_depends_on` to control the entire module's operation. Boolean feature toggles are acceptable however.

<br>

---

<br>

#### ID: TFNFR15 - Category: Code Style - Variable Definition Order

Input variables should follow this order:

1. All required fields, in alphabetical order
2. All optional fields, in alphabetical order

A `variable` without `default` value is a required field, otherwise it's an optional one.

<br>

---

<br>

#### ID: TFNFR16 - Category: Code Style - Variable Naming Rules

The naming of a `variable` should follow [HashiCorp's naming rule](https://www.terraform.io/docs/extend/best-practices/naming.html).

`variable` used as feature switches should use positive statement, use `xxx_enabled` instead of `xxx_disabled`. Avoid double negatives like `!xxx_disabled`.

Please use `xxx_enabled` instead of `xxx_disabled` as name of a `variable`.

<br>

---

<br>

#### ID: TFNFR17 - Category: Code Style - Variables with Descriptions

The target audience of `description` is the module users.

For a newly created `variable` (Eg. `variable` for switching `dynamic` block on-off), it's `description` should precisely describe the input parameter's purpose and the expected data type. `description` should not contain any information for module developers, this kind of information can only exist in code comments.

For `object` type `variable`, `description` can be composed in HEREDOC format:

```terraform
variable "kubernetes_cluster_key_management_service" {
  type = object({
    key_vault_key_id         = string
    key_vault_network_access = optional(string)
  })
  default     = null
  description = <<-EOT
  - `key_vault_key_id` - (Required) Identifier of Azure Key Vault key. See [key identifier format](https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates#vault-name-and-object-name) for more details. When Azure Key Vault key management service is enabled, this field is required and must be a valid key identifier. When `enabled` is `false`, leave the field empty.
  - `key_vault_network_access` - (Optional) Network access of the key vault Network access of key vault. The possible values are `Public` and `Private`. `Public` means the key vault allows public access from all networks. `Private` means the key vault disables public access and enables private link. Defaults to `Public`.
EOT
}
```

<br>

---

<br>

#### ID: TFNFR18 - Category: Code Style - Variables with Types

`type` **MUST** be defined for every `variable`. `type` should be as precise as possible, `any` can only be defined with adequate reasons.

- Use `bool` instead of `string` or `number` for `true/false`
- Use `string` for text
- Use concrete `object` instead of `map(any)`

<br>

---

<br>

#### ID: TFNFR19 - Category: Code Style - Sensitive Data Variables

If `variable`'s `type` is `object` and contains one or more fields that would be assigned to a `sensitive` argument, then this whole `variable` should be declared as `sensitive = true`, otherwise you should extract sensitive field into separated variable block with `senstive = true`.

<br>

---

<br>

#### ID: TFNFR20 - Category: Code Style - Non-Nullable Defaults for collection values

Nullable SHOULD be set to `false` for collection values (e.g. sets, maps, lists) when using them in loops. However for scalar values like string and number, a null value MAY have a semantic meaning and as such these values are allowed.

<br>

---

<br>

#### ID: TFNFR21 - Category: Code Style - Discourage Nullability by Default

Avoid `nullable = true`.

<br>

---

<br>

#### ID: TFNFR22 - Category: Code Style - Avoid sensitive = false

Avoid `sensitive = false`.

<br>

---

<br>

#### ID: TFNFR23 - Category: Code Style - Sensitive Default Value Conditions

Setting a default value for a sensitive input is not permitted, e.g. a default password.

<br>

---

<br>

#### ID: TFNFR24 - Category: Code Style - Handling Deprecated Variables

Sometimes we will find names for some `variable` are not suitable anymore, or a change should be made to the data type. We want to ensure forward compatibility within a major version, so direct changes are strictly forbidden. The right way to do this is move this `variable` to an independent `deprecated_variables.tf` file, then redefine the new parameter in `variable.tf` and make sure it's compatible everywhere else.

Deprecated `variable` must be annotated as `DEPRECATED` at the beginning of the `description`, at the same time the replacement's name should be declared. E.g.

```terraform
variable "enable_network_security_group" {
  type        = string
  default     = null
  description = "DEPRECATED, use `network_security_group_enabled` instead; Whether to generate a network security group and assign it to the subnet. Changing this forces a new resource to be created."
}
```

A cleanup of `deprecated_variables.tf` can be performed during a major version release.

<br>

---

<br>

#### ID: TFNFR25 - Category: Code Style - Verified Modules Requirements

The `terraform.tf` file must only contain one `terraform` block.

The first line of the `terraform` block must define a `required_version` property for the Terraform CLI.

The `required_version` property must include a constraint on the minimum version of the Terraform CLI. Previous releases of the Terraform CLI can have unexpected behaviour.

The `required_version` property must include a constraint on the maximum major version of the Terraform CLI. Major version releases of the Terraform CLI can introduce breaking changes and *MUST* be tested.

The `required_version` property constraint can use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

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

<br>

---

<br>

#### ID: TFNFR26 - Category: Code Style - Providers in required_providers

The `terraform` block in `terraform.tf` must contain the `required_providers` block.

Each provider used directly in the module must be specified with the `source` and `version` properties. Providers in the `required_providers` block should be sorted in alphabetical order.

Do not add providers to the `required_providers` block that are not directly required by this module. If submodules are used then each submodule should have its own `versions.tf` file.

The `source` property must be in the format of `namespace/name`. If this is not explicity specified, it can cause failure.

The `version` property must include a constraint on the minumum version of the provider. Older provider versions may not work as expected.

The `version` property must include a constraint on the maximum major version. A provider major version release may introduce breaking change, so updates to the major version constraint for a provider *MUST* be tested.

The `version` property constraint can use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

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

<br>

---

<br>

#### ID: TFNFR27 - Category: Code Style - Provider Declarations in Modules

[By rules](https://www.terraform.io/docs/language/modules/develop/providers.html), in the module code `provider` cannot be declared. The only exception is when the module indeed need different instances of the same kind of `provider`(Eg. manipulating resources across different `location`s or accounts), you **MUST** declare `configuration_aliases` in `terraform.required_providers`. See details in this [document](https://www.terraform.io/docs/language/providers/configuration.html#alias-multiple-provider-configurations).

`provider` block declared in the module can only be used to differentiate instances used in  `resource` and `data`. Declaration of fields other than `alias` in `provider` block is strictly forbidden. It could lead to module users unable to utilize `count`, `for_each` or `depends_on`. Configurations of the `provider` instance should be passed in by the module users.

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
```

<br>

---

<br>

#### ID: TFNFR28 - Category: Code Style - Provider Declarations in Modules

<br>

---

<br>

#### ID: TFNFR29 - Category: Code Style - Sensitive Data Outputs

<br>

---

<br>

#### ID: TFNFR30 - Category: Code Style - Handling Deprecated Outputs

Sometimes we notice that the name of certain `output` is not appropriate anymore, however, since we have to ensure forward compatibility in the same major version, it's not allowed to change the name directly. We need to move it to an independent `deprecated_outputs.tf` file, then redefine a new output in `output.tf` and make sure it's compatible everywhere else in the module.

A cleanup can be performed to `deprecated_outputs.tf` and other logics related to compatibility during a major version upgrade.

<br>

---

<br>

#### ID: TFNFR31 - Category: Code Style - locals.tf for Locals Only

In `locals.tf` file we could declare multiple `locals` blocks, but only `locals` blocks are allowed.

You **MAY** declare `locals` blocks next to a `resource` block or `data` block for some advanced scenarios, like making a fake module to execute some light-weight tests aimed at the expressions.

<br>

---

<br>

#### ID: TFNFR32 - Category: Code Style - Alphabetical Local Arrangement

<br>

---

<br>

#### ID: TFNFR33 - Category: Code Style - Precise Local Types

Good example:

```terraform
{
  name = "John"
  age  = 52
}
```

Bad example:

```terraform
{
  name = "John"
  age  = "52" # age should be number
}
```

<br>

---

<br>

#### ID: TFNFR34 - Category: Code Style - Using Feature Toggles

E.g., our previous release was `v1.2.1`, now we'd like to submit a pull request which contains such new `resource`:

```terraform
resource "azurerm_route_table" "this" {
  location            = local.location
  name                = coalesce(var.new_route_table_name, "${var.subnet_name}-rt")
  resource_group_name = var.resource_group_name
}
```

A user who's just upgraded the module's version would be surprised to see a new resource to be created in a newly generated plan file.

A better approach is adding a feature toggle to be turned off by default:

```terraform
variable "create_route_table" {
  type     = bool
  default  = false
  nullable = false
}

resource "azurerm_route_table" "this" {
  count               = var.create_route_table ? 1 : 0
  location            = local.location
  name                = coalesce(var.new_route_table_name, "${var.subnet_name}-rt")
  resource_group_name = var.resource_group_name
}
```

Similarly, when adding a new argument assignment in a `resource` block, we should use the default value provided by the provider's schema or `null`. We should use `dynamic` block with default omitted configuration when adding a new nested block inside a `resource` block.

<br>

---

<br>

#### ID: TFNFR35 - Category: Code Style - Reviewing Potential Breaking Changes

Potential breaking(surprise) changes introduced by `resource` block

1. Adding a new `resource` without `count` or `for_each` for conditional creation, or creating by default
2. Adding a new argument assignment with a value other than the default value provided by the provider's schema
3. Adding a new nested block without making it `dynamic` or omitting it by default
4. Renaming a `resource` block without one or more corresponding `moved` blocks
5. Change `resource`'s `count` to `for_each`, or vice versa

[Terraform `moved` block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring) could be your cure.

Potential breaking changes introduced by `variable` and `output` blocks

1. Deleting(Renaming) a `variable`
2. Changing `type` in a `variable` block
3. Changing the `default` value in a `variable` block
4. Changing `variable`'s `nullable` to `false`
5. Changing `variable`'s `sensitive` from `false` to `true`
6. Adding a new `variable` without `default`
7. Deleting an `output`
8. Changing an `output`'s `value`
9. Changing an `output`'s `sensitive` value

These changes do not necessarily trigger breaking changes, but they are very likely to, they **MUST** be reviewed with caution.

<br>

---

<br>

#### ID: TFNFR36 - Category: Code Style - Setting prevent_deletion_if_contains_resources

From Terraform AzureRM 3.0, the default value of `prevent_deletion_if_contains_resources` in `provider` block is `true`. This will lead to an unstable test(because the test subscription has some policies applied and they will add some extra resources during the run, which can cause failures during destroy of resource groups).

Since we cannot guarantee our testing environment won't be applied some [Azure Policy Remediation Tasks](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?tabs=azure-portal) in the future, for a robust testing environment, please explicitly set `prevent_deletion_if_contains_resources` to `false`.

<br>

---

<br>

#### ID: TFNFR37 - Category: Code Style - Tool Usage by Module Owner

`newres` is a command-line tool that generates Terraform configuration files for a specified resource type. It automates the process of creating `variables.tf` and `main.tf` files, making it easier to get started with Terraform and reducing the time spent on manual configuration.

Module owners are encouraged to use `newres` when they're trying to add new `resource` block, attribute, or nested block. They may generate the whole block along with the corresponding `variable` blocks in an empty folder, then copy-paste the parts they need with essential refactorings.

<br>

---

<br>
