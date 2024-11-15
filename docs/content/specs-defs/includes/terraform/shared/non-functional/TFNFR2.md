---
title: TFNFR2 - Module Documentation Generation
url: /spec/TFNFR2
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Documentation,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 21020
---

#### ID: TFNFR2 - Category: Documentation - Module Documentation Generation

Terraform modules documentation **MUST** be automatically generated via [Terraform Docs](https://github.com/terraform-docs/terraform-docs).

A file called `.terraform-docs.yml` **MUST** be present in the root of the module and have the following content:

{{< include file="/static/includes/terraform-docs.yml" language="yaml" options="linenos=false" >}}
