---
title: Terraform Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
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

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by Azure Terraform PG/Engineering(@Azure/terraform-azure) and AVM core team(@Azure/avm-core-team).

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

Module owners **MUST** output the following additional outputs as a minimum in their modules:

| Output                                                                                  | Terraform Output Name                                 | MUST/SHOULD |
| --------------------------------------------------------------------------------------- | ----------------------------------------------------- | ----------- |
| Full Resource Output Object                                                             | `resource`                                            | MUST        |
| Full Resource Output (map of) Object/s of child resource/extension/associated resources | `resource_<child/extension/associated resource name>` | SHOULD      |

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

#### ID: TFNFR6 - Category: Code Style - The Order of `resource` and `data` in the Same File

For the definition of resources in the same file, the resources be depended on come first, after them are the resources depending on others.

Resources have dependencies should be defined close to each other.

<br>

---
<br>

#### ID: TFNFR7 - Category: Code Style - The Use of `count` and `for_each`

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

#### ID: TFNFR8 - Category: Code Style - Orders Within `resource` and `data` Blocks

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

* `count`
* `depends_on`
* `for_each`
* `lifecycle`
* `provider`

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

#### ID: TFNFR9 - Category: Code Style - Order within a `module` block

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

#### ID: TFNFR10 - Category: Code Style - Values in `ignore_changes` passed to `provider`, `depends_on`, `lifecycle` blocks are not allowed to use double quotations

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

#### ID: TFNFR11 - Category: Code Style - `null` comparison as creation toogle

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

---

<br>

#### ID: TFNFR12 - Category: Code Style - Optional nested object argument should use `dynamic`

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

---

#### ID: TFNFR13 - Category: Code Style - Use `coalesce` or `try` when setting default values for nullable expressions

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

---

<br>

