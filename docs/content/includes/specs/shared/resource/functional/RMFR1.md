---
title: RMFR1 - Single Resource Only
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
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
---

#### ID: RMFR1 - Category: Composition - Single Resource Only

A resource module **MUST** only deploy a single instance of the primary resource, e.g., one virtual machine per instance.

Multiple instances of the module **MUST** be used to scale out.
