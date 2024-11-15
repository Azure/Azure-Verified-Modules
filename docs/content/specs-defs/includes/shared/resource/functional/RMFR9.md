---
title: RMFR9 - End-of-life resource versions
url: /spec/RMFR9
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-Functional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 2090
---

#### ID: RMFR9 - Category: Composition - End-of-life resource versions

When a given version of an Azure resource used in a resource module reaches its end-of-life (EOL) and is no longer supported by Microsoft, the module owner **SHOULD** ensure that:

1. The module is aligned with these changes and only includes supported versions of the resource. This is typically achieved through the allowed values in the parameter that specifies the resource SKU or type.
2. The following notice is shown under the `Notes` section of the module's `readme.md`. (If any related public announcement is available, it can also be linked to from the Notes section.):
    > "Certain versions of this Azure resource reached their end of life. The latest version of this module only includes supported versions of the resource. All unsupported versions have been removed from the related parameters."
3. AND the related parameter's description:
    > "Certain versions of this Azure resource reached their end of life. The latest version of this module only includes supported versions of the resource. All unsupported versions have been removed from this parameter."
