---
title: TFNFR13 - Default Values with coalesce/try
url: /spec/TFNFR13
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
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
priority: 21130
---

#### ID: TFNFR13 - Category: Code Style - Default Values with coalesce/try

The following example shows how `"${var.subnet_name}-nsg"` **SHOULD** be used when `var.new_network_security_group_name` is `null` or `""`

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
