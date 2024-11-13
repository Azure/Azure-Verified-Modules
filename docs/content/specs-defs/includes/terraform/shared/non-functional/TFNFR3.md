---
title: TFNFR3 - GitHub Repo Branch Protection
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Contribution/Support,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 30
---

#### ID: TFNFR3 - Category: Contribution/Support - GitHub Repo Branch Protection

Module owners **MUST** set a branch protection policy on their GitHub Repositories for AVM modules against their default branch, typically `main`, to do the following:

1. Requires a Pull Request before merging
2. Require approval of the most recent reviewable push
3. Dismiss stale pull request approvals when new commits are pushed
4. Require linear history
5. Prevents force pushes
6. Not allow deletions
7. Require CODEOWNERS review
8. Do not allow bypassing the above settings
9. Above settings **MUST** also be enforced to administrators

{{< hint type=tip >}}

If you use the [template repository](/Azure-Verified-Modules/contributing/terraform/#template-repository) as mentioned in the contribution guide, the above will automatically be set.

{{< /hint >}}
