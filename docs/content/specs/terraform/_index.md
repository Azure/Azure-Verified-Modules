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

<br>

This page contains the **Terraform specific requirements** for AVM modules (**Resource and Pattern modules**) that ALL Terraform AVM modules **MUST** meet. These requirements are in addition to the [Shared Specification](/Azure-Verified-Modules/specs/shared/) requirements that ALL AVM modules **MUST** meet.

{{< hint type=important >}}

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by Azure Terraform PG/Engineering(@Azure/terraform-azure) and AVM core team(@Azure/avm-core-team).

{{< /hint >}}

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements               | Non-functional requirements                 |
| ------------------------------------------------ | ------------------------------------- | ------------------------------------------- |
| Shared requirements (resource & pattern modules) | [TFFR](#functional-requirements-tffr) | [TFNFR](#non-functional-requirements-tfnfr) |
| Resource module level requirements               | *N/A*                                 | *N/A*                                       |
| Pattern module level requirements                | *N/A*                                 | *N/A*                                       |

<br>

{{< toc >}}

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for Terraform AVM modules (Resource and Pattern).

<br>

### Functional Requirements (TFFR)

{{< hint type=note >}}
This section includes **Terraform specific, functional requirements (TFFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: TFFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules. However, they **MUST** be referenced only by a HashiCorp Terraform registry reference to a pinned version e.g.,

```terraform
module "other-module" {
  source  = "Azure/xxx/azurerm"
  version = "1.2.3"
}
```

Module owners **MUST** always specify a `version`, like:

* `"1.2.3"`
* `"~> 1.2"`
* `"~> 1"`
* `">= 1.3.5, < 2.0"`

Module's major version upgrade might contain breaking changes or even cause data loss. Module owners **MUST NOT** specify a `version` constriction that leads to an unconstrained major version, like:

* `">= 1.2.3"`

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

Modules **MUST NOT** contain references to non-AVM modules.

{{< hint type=tip >}}
See [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) for more information.
{{< /hint >}}

<br>

---

<br>

#### ID: TFFR2 - Category: Outputs - Additional Terraform Outputs

Module owners **MUST** output the following additional outputs as a minimum in their modules:

| Output                                                                                  | Terraform Output Name                                 | MUST/SHOULD |
| --------------------------------------------------------------------------------------- | ----------------------------------------------------- | ----------- |
| Full Resource Output Object                                                             | `resource`                                            | MUST        |
| Full Resource Output (map of) Object/s of child resource/extension/associated resources | `resource_<child/extension/associated resource name>` | SHOULD      |

<br>

---

<br>

#### ID: TFFR3 - Category: Inputs - No `enabled` or `module_depends_on` variable

Since Terraform 0.13, `count`, `for_each` and `depends_on` are introduced for modules, module development is significantly simplified. Module's owners **MUST NOT** add variables like `enabled` or `module_depends_on`).

<br>

---

<br>

### Non-Functional Requirements (TFNFR)

{{< hint type=note >}}
This section includes **Terraform specific, non-functional requirements (TFNFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: TFNFR1 - Category: Documentation - Descriptions

Where descriptions for variables and outputs spans multiple lines. The description **MUST** provide variable input examples for each variable using the HEREDOC format and embedded markdown.

Example:

{{< include file="/static/includes/sample.var_example.tf" language="terraform" options="linenos=false" >}}

<br>

---

<br>

#### ID: TFNFR2 - Category: Documentation - Module Documentation Generation

Terraform modules documentation **MUST** be automatically generated via [Terraform Docs](https://github.com/terraform-docs/terraform-docs).

A file called `.terraform-docs.yml` **MUST** be present in the root of the module and have the following content:

{{< include file="/static/includes/terraform-docs.yml" language="yaml" options="linenos=false" >}}

<br>

---

<br>

#### ID: TFNFR3 - Category: Contribution/Support - GitHub Repo Branch Protection

Module owners **MUST** set a branch protection policy on their GitHub Repositories for AVM modules against their default branch, typically `main`, to do the following:

1. Requires a Pull Request before merging
2. Require approval of the most recent reviewable push
3. Dismiss stale pull request approvals when new commits are pushed
4. Require linear history
5. Prevents force pushes
6. Not allow deletions
7. Require CODEOWNERS review
8. Do not allow bypassing the above settings
9. Above settings **MUST** also be enforced to administrators

{{< hint type=tip >}}

If you use the [template repository](/Azure-Verified-Modules/contributing/terraform/#template-repository) as mentioned in the contribution guide, the above will automatically be set.

{{< /hint >}}

<br>

---

<br>

#### ID: TFNFR4 - Category: Composition - Code Styling - lower snake_casing

Module owners **MUST** use [lower snake_casing](https://wikipedia.org/wiki/Snake_case) for naming the following:

- Locals
- Variables
- Outputs
- Resources (symbolic names)
- Modules (symbolic names)

For example: `snake_casing_example` (every word in lowercase, with each word separated by an underscore `_`)

<br>

---

<br>

#### ID: TFNFR5 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [Terraform](https://www.terraform.io/)
  - `terraform <validate/fmt/test>`
- [terrafmt](https://github.com/katbyte/terrafmt)
- [Checkov](https://www.checkov.io/)
- [tflint (with azurerm ruleset)](https://github.com/terraform-linters/tflint-ruleset-azurerm)
- [Go](https://go.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Go for your own tests.

<br>

#### ID: TFNFR6 - 

---

<br>

