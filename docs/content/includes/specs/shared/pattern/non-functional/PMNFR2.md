---
title: PMNFR2 - Use Resource Modules to Build a Pattern Module
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Pattern,
  Type-NonFunctional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
type: "posts"
---

#### ID: PMNFR2 - Category: Composition - Use Resource Modules to Build a Pattern Module

A Pattern Module **SHOULD** be built from AVM Resources Modules to establish a standardized code base and improve maintainability. If a valid reason exists, a pattern module **MAY** contain native resources ("vanilla" code) where it's necessary. A Pattern Module **MUST NOT** contain references to non-AVM modules.

Valid reasons for not using a Resource Module for a resource required by a Pattern Module include but are not limited to:

- When using a Resource Module would result in hitting scaling limitations and/or would reduce the capabilities of the Pattern Module due to the limitations of Azure Resource Manager.
- Developing a Pattern Module under time constraint, without having all required Resource Modules readily available.

{{< hint type=note >}}
In the latter case, the Pattern Module **SHOULD** be updated to use the Resource Module when the required Resource Module becomes available, to avoid accumulating technical debt. Ideally, all required Resource Modules **SHOULD** be developed first, and then leveraged by the Pattern Module.
{{< /hint >}}
