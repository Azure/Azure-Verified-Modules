---
title: Module Specifications
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
url: /specs/module-specs/
---

This section documents all the specifications for Azure Verified Modules (AVM) and their respective IaC languages.

- [Shared (Bicep & Terraform)](/Azure-Verified-Modules/specs/shared)
  - [Interfaces](/Azure-Verified-Modules/specs/shared/interfaces)
- [Bicep Specific](/Azure-Verified-Modules/specs/bicep)
  - [Interfaces](/Azure-Verified-Modules/specs/bicep/interfaces)
- [Terraform Specific](/Azure-Verified-Modules/specs/terraform)

<!-- ## How to read the specifications?

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

## How to propose changes to the specifications?

{{< hint type=important >}}

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by the AVM core team(@Azure/avm-core-team).

{{< /hint >}}

{{< hint type=important >}}

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by Azure Terraform PG/Engineering(@Azure/terraform-avm) and AVM core team(@Azure/avm-core-team).

{{< /hint >}} -->

{{< tagsBasedNavigationTable folder="content/specs-defs/includes" tags="Class-Resource,Class-Pattern,Language-Bicep" recursive=true strict=false showHint=true summarize=false >}}