---
title: SNFR17 - Semantic Versioning
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Release,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
type: "posts"
priority: 210
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
