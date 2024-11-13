---
title: SNFR25 - Resource Naming
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-Initial
]
type: "posts"
priority: 10
---

#### ID: SNFR25 - Category: Composition - Resource Naming

Module owners **MUST** set the default resource name prefix for child, extension, and interface resources to the associated abbreviation for the specific resource as documented in the following CAF article [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), if specified and documented. This reduces the amount of input values a module consumer **MUST** provide by default when using the module.

For example, a Private Endpoint that is being deployed as part of a resource module, via the mandatory interfaces, **MUST** set the Private Endpoint's default name to begin with the prefix of `pep-`.

Module owners **MUST** also provide the ability for these default names, including the prefixes, to be overridden via a parameter/variable if the consumer wishes to.

Furthermore, as per [RMNFR2](/Azure-Verified-Modules/specs/shared#id-snfr22---category-inputs---parametersvariables-for-resource-ids), Resource Modules **MUST** not have a default value specified for the name of the primary resource and therefore the name **MUST** be provided and specified by the module consumer.

The name provided **MAY** be used by the module owner to generate the rest of the default name for child, extension, and interface resources if they wish to. For example, for the Private Endpoint mentioned above, the full default name that can be overridden by the consumer, **MAY** be `pep-<primary-resource-name>`.

{{< hint type=tip >}}

If the resource does not have a documented abbreviation in [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), then the module owner is free to use a sensible prefix instead.

{{< /hint >}}
