---
title: "SNFR18 - Breaking Changes"
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Shared","Type-NonFunctional","Category-Release","Language-Shared","Enforcement-SHOULD","Persona-Owner","Persona-Contributor","Lifecycle-Maintenance"]
type: "posts"
priority: 220
---

#### ID: SNFR18 - Category: Release - Breaking Changes

A module **SHOULD** avoid breaking changes, e.g., deprecating inputs vs. removing. If you need to implement changes that cause a breaking change, the major version should be increased.

{{< hint type=info >}}

Modules that have not been released as `1.0.0` may introduce breaking changes, as explained in the previous ID [SNFR17](/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning). That means that you have to introduce non-breaking and breaking changes with a minor version jump, as long as the module has not reached version `1.0.0`.

{{< /hint >}}

There are, however, scenarios where you want to include breaking changes into a commit and not create a new major version. If you want to introduce breaking changes as part of a minor update, you can do so. In this case, it is essential to keep the change backward compatible, so that the existing code will continue to work. At a later point, another update can increase the major version and remove the code introduced for the backward compatibility.

{{< hint type=tip >}}

See the language specific examples to find out how you can deal with deprecations in AVM modules.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/composition/#deprecation)

{{< /hint >}}