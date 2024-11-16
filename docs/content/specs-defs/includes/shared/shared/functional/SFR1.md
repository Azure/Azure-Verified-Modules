---
title: SFR1 - Preview Services
url: /spec/SFR1
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-Functional,
  Category-Naming/Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-BAU
]
priority: 10
---

#### ID: SFR1 - Category: Composition - Preview Services

Modules **MAY** create/adopt public preview services and features at their discretion.

Preview API versions **MAY** be used when:

- The resource/service/feature is GA but the only API version available for the GA resource/service/feature is a preview version
  - For example, Diagnostic Settings (`Microsoft.Insights/diagnosticSettings`) the latest version of the API available with GA features, like Category Groups etc., is `2021-05-01-preview`
  - Otherwise the latest "non-preview" version of the API **SHOULD** be used

Preview services and features, **SHOULD NOT** be promoted and exposed, unless they are supported by the respective PG, and it's documented publicly.

However, they **MAY** be exposed at the module owners discretion, but the following rules **MUST** be followed:

- The description of each of the parameters/variables used for the preview service/feature **MUST** start with:
  - *"THIS IS A <PARAMETER/VARIABLE> USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE PRODUCT DOCS FOR CLARIFICATION"*