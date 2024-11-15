---
title: TFNFR36 - Setting prevent_deletion_if_contains_resources
url: /spec/TFNFR36
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
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 360
---

#### ID: TFNFR36 - Category: Code Style - Setting prevent_deletion_if_contains_resources

From Terraform AzureRM 3.0, the default value of `prevent_deletion_if_contains_resources` in `provider` block is `true`. This will lead to an unstable test because the test subscription has some policies applied, and they will add some extra resources during the run, which can cause failures during destroy of resource groups.

Since we cannot guarantee our testing environment won't be applied some [Azure Policy Remediation Tasks](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?tabs=azure-portal) in the future, for a robust testing environment, `prevent_deletion_if_contains_resources` **SHOULD** be explicitly set to `false`.
