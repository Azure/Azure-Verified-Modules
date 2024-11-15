---
title: RMNFR2 - Parameter/Variable Naming
url: /spec/RMNFR2
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-NonFunctional,
  Category-Inputs/Outputs,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 3020
---

#### ID: RMNFR2 - Category: Inputs - Parameter/Variable Naming

A resource module **MUST** use the following standard inputs:

- `name` (no default)
- `location` (if supported by the resource and not a global resource, then use Resource Group location, if resource supports Resource Groups, otherwise no default)
