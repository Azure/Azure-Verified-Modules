---
title: RMFR3 - Resource Groups
url: /spec/RMFR3
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-Functional,
  Category-Naming/Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 2030
---

#### ID: RMFR3 - Category: Composition - Resource Groups

A resource module **MUST NOT** create a Resource Group **for resources that require them.**

In the case that a Resource Group is required, a module **MUST** have an input (scope or variable):

- In Bicep the `targetScope` **MUST** be set to `resourceGroup` or not specified (which means default to `resourceGroup` scope)
- In Terraform the `variable` **MUST** be called `resource_group_name`

Scopes will be covered further in the respective language specific specifications.
