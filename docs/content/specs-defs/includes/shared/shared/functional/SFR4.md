---
title: SFR4 - Telemetry Enablement Flexibility
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
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-Initial
]
---

#### ID: SFR4 - Category: Telemetry - Telemetry Enablement Flexibility

The telemetry enablement **MUST** be on/enabled by default, however this **MUST** be able to be disabled by a module consumer by setting the below parameter/variable value to `false`:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

{{< hint type=note >}}

Whenever a module references AVM modules that implement the telemetry parameter (e.g., a pattern module that uses AVM resource modules), the telemetry parameter value **MUST** be passed through to these modules. This is necessary to ensure a consumer can reliably enable & disable the telemetry feature for all used modules.

{{< /hint >}}
