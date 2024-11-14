---
title: TFNFR24 - Handling Deprecated Variables
url: /spec/TFNFR24
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
priority: 21240
---

#### ID: TFNFR24 - Category: Code Style - Handling Deprecated Variables

Sometimes we will find names for some `variable` are not suitable anymore, or a change **SHOULD** be made to the data type. We want to ensure forward compatibility within a major version, so direct changes are strictly forbidden. The right way to do this is move this `variable` to an independent `deprecated_variables.tf` file, then redefine the new parameter in `variable.tf` and make sure it's compatible everywhere else.

Deprecated `variable` **MUST** be annotated as `DEPRECATED` at the beginning of the `description`, at the same time the replacement's name **SHOULD** be declared. E.g.,

```terraform
variable "enable_network_security_group" {
  type        = string
  default     = null
  description = "DEPRECATED, use `network_security_group_enabled` instead; Whether to generate a network security group and assign it to the subnet. Changing this forces a new resource to be created."
}
```

A cleanup of `deprecated_variables.tf` **MAY** be performed during a major version release.
