---
title: TFFR2 - Additional Terraform Outputs
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-Functional,
  Category-Outputs,
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
---

#### ID: TFFR2 - Category: Outputs - Additional Terraform Outputs

Authors **SHOULD NOT** output entire resource objects as these may contain sensitive outputs and the schema can change with API or provider versions.
Instead, authors **SHOULD** output the *computed* attributes of the resource as discreet outputs.
This kind of pattern protects against provider schema changes and is known as an [anti-corruption layer](https://learn.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer).

Remember, you **SHOULD NOT** output values that are already inputs (other than `name`).

E.g.,

```terraform
# Resource output, computed attribute.
output "foo" {
  description = "MyResource foo attribute"
  value = azurerm_resource_myresource.foo
}

# Resource output for resources that are deployed using `for_each`. Again only computed attributes.
output "childresource_foos" {
  description = "MyResource children's foo attributes"
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
