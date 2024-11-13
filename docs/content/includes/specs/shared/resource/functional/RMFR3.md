---
title: RMFR3 - Resource Groups
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Resource,
  Type-Functional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
type: "posts"
---

#### ID: RMFR3 - Category: Composition - Resource Groups

A resource module **MUST NOT** create a Resource Group **for resources that require them.**

In the case that a Resource Group is required, a module **MUST** have an input (scope or variable):

- In Bicep the `targetScope` **MUST** be set to `resourceGroup` or not specified (which means default to `resourceGroup` scope)
- In Terraform the `variable` **MUST** be called `resource_group_name`

Scopes will be covered further in the respective language specific specifications.
