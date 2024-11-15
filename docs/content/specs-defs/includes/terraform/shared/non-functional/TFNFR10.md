---
title: TFNFR10 - No Double Quotes in ignore_changes
url: /spec/TFNFR10
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
  Lifecycle-BAU
]
priority: 21100
---

#### ID: TFNFR10 - Category: Code Style - No Double Quotes in ignore_changes

The `ignore_changes` attribute **MUST NOT** be enclosed in double quotes.

Good example:

```hcl
lifecycle {
    ignore_changes = [
      tags,
    ]
}
```

Bad example:

```hcl
lifecycle {
    ignore_changes = [
      "tags",
    ]
}
```
