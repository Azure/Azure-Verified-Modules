---
title: TFNFR8 - Resource & Data Block Orders
url: /spec/TFNFR8
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21080
---

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

All the meta-arguments **SHOULD** be declared on the top of `resource` or `data` blocks in the following order:

1. `provider`
2. `count`
3. `for_each`

Then followed by:

1. required arguments
2. optional arguments
3. required nested blocks
4. optional nested blocks

All ranked in alphabetical order.

These meta-arguments **SHOULD** be declared at the bottom of a `resource` block with the following order:

1. `depends_on`
2. `lifecycle`

The parameters of `lifecycle` block **SHOULD** show up in the following order:

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
