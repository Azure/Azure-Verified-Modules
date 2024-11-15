---
title: TFNFR35 - Reviewing Potential Breaking Changes
url: /spec/TFNFR35
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
priority: 21350
---

#### ID: TFNFR35 - Category: Code Style - Reviewing Potential Breaking Changes

Potential breaking(surprise) changes introduced by `resource` block

1. Adding a new `resource` without `count` or `for_each` for conditional creation, or creating by default
2. Adding a new argument assignment with a value other than the default value provided by the provider's schema
3. Adding a new nested block without making it `dynamic` or omitting it by default
4. Renaming a `resource` block without one or more corresponding `moved` blocks
5. Change `resource`'s `count` to `for_each`, or vice versa

[Terraform `moved` block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring) could be your cure.

Potential breaking changes introduced by `variable` and `output` blocks

1. Deleting(Renaming) a `variable`
2. Changing `type` in a `variable` block
3. Changing the `default` value in a `variable` block
4. Changing `variable`'s `nullable` to `false`
5. Changing `variable`'s `sensitive` from `false` to `true`
6. Adding a new `variable` without `default`
7. Deleting an `output`
8. Changing an `output`'s `value`
9. Changing an `output`'s `sensitive` value

These changes do not necessarily trigger breaking changes, but they are very likely to, they **MUST** be reviewed with caution.
