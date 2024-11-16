---
title: BCPFR4 - Telemetry Enablement
url: /spec/BCPFR4
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-Functional,
  Category-Telemetry,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 10030
---

#### ID: BCPFR4 - Category: Composition - Telemetry Enablement

To comply with specifications outlined in [SFR3](/Azure-Verified-Modules/spec/SFR3) & [SFR4](/Azure-Verified-Modules/spec/SFR4) you **MUST** incorporate the following code snippet into your modules. Place this code sample in the "top level" `main.bicep` file; it is not necessary to include it in any nested Bicep files (child modules).

{{< include file="/static/includes/sample.telem.bicep" language="bicep" options="linenos=false" >}}