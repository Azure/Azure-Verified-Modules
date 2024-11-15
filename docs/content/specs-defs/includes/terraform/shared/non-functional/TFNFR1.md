---
title: TFNFR1 - Descriptions
url: /spec/TFNFR1
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
priority: 21010
---

#### ID: TFNFR1 - Category: Documentation - Descriptions

Where descriptions for variables and outputs spans multiple lines. The description **MUST** provide variable input examples for each variable using the HEREDOC format and embedded markdown.

Example:

{{< include file="/static/includes/sample.var_example.tf" language="terraform" options="linenos=false" >}}
