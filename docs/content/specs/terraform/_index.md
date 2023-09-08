---
title: Terraform Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< hint type=tip >}}

Make sure to checkout the [Shared Specification](/Azure-Verified-Modules/specs/shared/) first before reading further so you understand the specifications items that are shared and agnostic to the IaC language/tool.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

{{< toc >}}

## Shared Requirements (Resource & Pattern Modules)

### Functional Requirements

#### ID: TFFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules. However, they **MUST** be referenced only by a HashiCorp Terraform registry reference to a pinned version e.g.

```terraform
module "other-module" {
  source  = "Azure/xxx/azurerm"
  version = "1.2.3"
}
```

They **MUST NOT** use git reference to a module.

```terraform
module "other-module" {
  source = "git::https://xxx.yyy/xxx.git"
}
```

```terraform
module "other-module" {
  source = "github.com/xxx/yyy"
}
```

> See [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) for more information

### Non-Functional Requirements

#### ID: TFNFR1 - Category: Documentation - Descriptions

Where descriptions for variables and outputs spans multiple lines. The description **MUST** provide variable input examples for each variable using the HEREDOC format and embedded markdown.

Example:

{{< include file="/static/includes/sample.var_example.tf" language="terraform" options="linenos=false" >}}

#### ID: TFNFR2 - Category: Documentation - Module Documentation Generation

Terraform modules documentation **MUST** be automatically generated via [Terraform Docs](https://github.com/terraform-docs/terraform-docs).

A file called `.terraform-docs.yml` **MUST** be present in the root of the module and have the following content:

{{< include file="/static/includes/terraform-docs.yml" language="yaml" options="linenos=false" >}}
