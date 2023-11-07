---
title: Terraform Contribution Guide
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

{{< hint type=tip >}}

Before submitting a new [module proposal](https://aka.ms/avm/moduleproposal) for either Bicep or Terraform, please review the FAQ section on ["CARML/TFVM to AVM Evolution Details"](/Azure-Verified-Modules/faq/#carmltfvm-to-avm-evolution-details)

{{< /hint >}}

{{< hint type=important >}}
While this page describes and summarizes important aspects of contributing to AVM, it only references *some* of the shared and language specific requirements.

Therefore, this contribution guide **MUST** be used in conjunction with the [Shared Specification](/Azure-Verified-Modules/specs/shared/) and the [Terraform specific](/Azure-Verified-Modules/specs/terraform/) specifications. **ALL AVM modules** (Resource and Pattern modules) **MUST meet the respective requirements described in these  specifications**!
{{< /hint >}}

<br>

## Recommended Learning

Before you start contributing to the AVM, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Terraform

- [HashiCorp Terraform Docs](https://developer.hashicorp.com/terraform/docs)
- [Terraform associate exam prep](https://developer.hashicorp.com/terraform/tutorials/certification-003?product_intent=terraform)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

<br>

## Tooling

### Required Tooling

{{< hint type=tip >}}

We **strongly** recommend you use Linux or MacOS for your development environment.
You can use Windows Subsystem for Linux (WSL) if you are using Windows.

{{< /hint >}}

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)
- [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Terraform extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
  - [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

- [CodeTour extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.codetour)
- [Go (for writing tests)](https://go.dev/doc/install)
- [Go extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=golang.go)
- [tfenv](https://github.com/tfutils/tfenv) - useful when working on multiple modules that use different Terraform versions from the same machine
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

<br>

## Repositories

Each Terraform AVM module will have its own GitHub Repository in the [`Azure` GitHub Organization](https://github.com/Azure); as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

This repo will be created by the Module Owners and the AVM Core team collaboratively, including the configuration of permissions as per [SNFR9](/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions)

<br>

### Repository Labels

As per [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) the repositories created by module owners **MUST** have and use the pre-defined GitHub labels.

To apply these labels to the repository review the PowerShell script `Set-AvmGitHubLabels.ps1` that is provided in [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels).

## Template Repository

We have created a [template repository](https://github.com/Azure/terraform-azurerm-avm-template) to help you get started.
Please click the `use this template` and create a copy of the repo in the Azure organization.

You will then have to complete configuration of your repo and start an internal business review.
See [this link (internal only)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review?anchor=conduct-initial-repo-configuration-and-trigger-business-review).

<br>

## Directory and File Structure

Below is the directory and file structure expected for each AVM Terraform repository/module.
See template repo [here](https://github.com/Azure/terraform-azurerm-avm-template).

- `tests/` - (for unit tests and additional tests if required - e.g. tflint etc.)
  - `unit/` - (optional, may use further sub-directories if required)
- `modules/` - (for sub-modules only if used)
- `examples/` - (all examples must deploy without successfully without requiring input - these are customer facing)
  - `defaults` - (minimum/required parameters/variables only, heavy reliance on the default values for other parameters/variables)
  - `<other folders for examples as required>`
- `/...` - (Module files that live in the root of module directory)
  - `_header.md` - (required for documentation generation)
  - `_footer.md` - (required for documentation generation)
  - `main.tf`
  - `locals.tf`
  - `variables.tf`
  - `outputs.tf`
  - `terraform.tf`
  - `locals.version.tf.json` - (required for telemetry, should match the upcoming release tag)
  - `README.md` (autogenerated)
  - `main.resource1.tf` (If a larger module you may chose to use dot notation for each resource)
  - `locals.resource1.tf`

<br>

## Casing

Use `snake_casing` as per [TFNFR3](/Azure-Verified-Modules/specs/terraform/#id-tfnfr4---category-composition---code-styling---lower-snake_casing).

<br>

## Module Publishing

When the AVM Modules are published to the HashiCorp Registry, they **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<ARM resource type>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

### Publishing Process

1. Ensure your module is ready for publishing:
    1. All tests are passing
    2. All examples are passing
    3. All documentation is generated
    4. A pull request approval from a member of the [`@Azure/avm-core-team-technical`](https://github.com/orgs/Azure/teams/avm-core-team-technical/members)
    5. There is a release tag in the repo
2. If you are using Just In Time (JIT) admin access to your repo, visit the internal repos page to elevate your access.
3. Sign in to the [HashiCorp Registry](https://registry.terraform.io/) using GitHub
4. Publish a module by selecting the `Publish` button in the top right corner, then `Module`
5. Select the repo and accept the terms

<br>

## Telemetry

To meet [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) & [SFR4](/Azure-Verified-Modules/specs/shared/#id-sfr4---category-telemetry---telemetry-enablement-flexibility).
We have provided the sample code below, however it is already included in the [template-repo](https://github.com/Azure/terraform-azurerm-avm-template).

{{< include file="/static/includes/sample.telem.tf" language="terraform" options="linenos=false" >}}

In addition, you should use a `locals.version.tf.json` file to store the module version in a machine readable format:

{{< hint type=important >}}

Do not include the `v` prefix in the `module_version` value.

{{< /hint >}}

```json
{
  "locals": {
    "module_version": "1.0.0"
  }
}
```

## Eventual Consistency

When creating modules, it is important to understand that the Azure Resource Manager (ARM) API is sometimes eventually consistent.
This means that when you create a resource, it may not be available immediately.
A good example of this is data plane role assignments.
When you create such a role assignment, it may take some time for the role assignment to be available.
We can use an optional `time_sleep` resource to wait for the role assignment to be available before creating resources that depend on it.

```hcl
# In variables.tf...
variable "wait_for_rbac_before_foo_operations" {
  type = object({
    create  = optional(string, "30s")
    destroy = optional(string, "0s")
  })
  default     = {}
  description = <<DESCRIPTION
This variable controls the amount of time to wait before performing foo operations.
It only applies when `var.role_assignments` and `var.foo` are both set.
This is useful when you are creating role assignments on the bar resource and immediately creating foo resources in it.
The default is 30 seconds for create and 0 seconds for destroy.
DESCRIPTION
}

# In main.tf...
resource "time_sleep" "wait_for_rbac_before_foo_operations" {
  count = length(var.role_assignments) > 0 && length(var.foo) > 0 ? 1 : 0
  depends_on = [
    azurerm_role_assignment.this
  ]
  create_duration  = var.wait_for_rbac_before_foo_operations.create
  destroy_duration = var.wait_for_rbac_before_foo_operations.destroy

  # This ensures that the sleep is re-created when the role assignments change.
  triggers = {
    role_assignments = jsonencode(var.role_assignments)
  }
}

resource "azurerm_foo" "this" {
  for_each = var.foo
  depends_on = [
    time_sleep.wait_for_rbac_before_foo_operations
  ]
  # ...
}
```
