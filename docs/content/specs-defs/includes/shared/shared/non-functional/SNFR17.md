---
title: SNFR17 - Semantic Versioning
url: /spec/SNFR17
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Release/Publishing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1210
---

#### ID: SNFR17 - Category: Release - Semantic Versioning

{{< hint type=important >}}

You cannot specify the patch version for Bicep modules in the public Bicep Registry, as this is automatically incremented by 1 each time a module is published. You can only set the Major and Minor versions.

See the [Bicep Contribution Guide](/Azure-Verified-Modules/contributing/bicep/) for more information.

{{< /hint >}}

Modules **MUST** use semantic versioning (aka semver) for their versions and releases in accordance with: [Semantic Versioning 2.0.0](https://semver.org/)

For example all modules should be released using a semantic version that matches this pattern: `X.Y.Z`

- `X` == Major Version
- `Y` == Minor Version
- `Z` == Patch Version

##### Module versioning before first Major version release `1.0.0`

- Initially modules MUST be released as version `0.1.0` and incremented via Minor and Patch versions only until the AVM Core Team are confident the AVM specifications are mature enough and appropriate CI test coverage is in place, plus the module owner is happy the module has been "road tested" and is now stable enough for its first Major release of version `1.0.0`.

  {{< hint type=note >}}

  Releasing as version `0.1.0` initially and only incrementing Minor and Patch versions allows the module owner to make breaking changes more easily and frequently as it's still not an official Major/Stable release. 👍

  {{< /hint >}}

- Until first Major version `1.0.0` is released, given a version number `X.Y.Z`:
  - `X` Major version MUST NOT be bumped.
  - `Y` Minor version MUST be bumped when introducing breaking changes (which would normally bump Major after `1.0.0` release) or feature updates (same as it will be after `1.0.0` release).
  - `Z` Patch version MUST be bumped when introducing non-breaking, backward compatible bug fixes (same as it will be after `1.0.0` release).
