---
title: SNFR19 - Registries Targeted
url: /spec/SNFR19
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Publishing,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 230
---

#### ID: SNFR19 - Category: Publishing - Registries Targeted

Modules **MUST** be published to their respective language public registries.

- Bicep = [Bicep Public Module Registry](https://aka.ms/BRM)
  - Within the `avm` directory
- Terraform = [HashiCorp Terraform Registry](https://registry.terraform.io/)

{{< hint type=tip >}}

See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/)
- [Terraform](/Azure-Verified-Modules/contributing/terraform/)

{{< /hint >}}
