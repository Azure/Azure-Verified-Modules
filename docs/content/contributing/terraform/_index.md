---
title: Terraform AVM Modules Contribution Guide
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## Recommended Learning

Before you start contributing to the AVM, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Terraform

- [Hashicorp Terraform Docs](https://developer.hashicorp.com/terraform/docs)
- [Terraform associate exam prep](https://developer.hashicorp.com/terraform/tutorials/certification-003?product_intent=terraform)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

## Tooling

### Required Tooling

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
- [Go extenstion for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=golang.go)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

## Repositories

Each Terraform AVM module will have its own GitHub Repository in the [`Azure` GitHub Organization](https://github.com/Azure); as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

This repo will be created by the Module Owners and the AVM Core team collaboratively, including the configuration of permissions as per [SNFR9](/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions)

## Directory and File Structure

Below is the directory and file structure expected for each AVM Terraform repository/module.
See template repo [here](https://github.com/Azure/terraform-azurerm-avm-template).

- `tests/` - (for unit tests and additional E2E/integration if required - e.g. tflint etc.)
- `modules/` - (for sub-modules only if used)
- `examples/` - (all examples must deploy successfully and delete successfully - these are customer facing)
- `/...` - (Module files that live in the root of module directory)
  - `main.tf`
  - `locals.tf`
  - `variables.tf`
  - `outputs.tf`
  - `terraform.tf`
  - `locals.version.tf.json`
  - `README.md`
  - (If a larger module you may chose to carve up the above files into dot notation for each resources/sub-module e.g.)
    - `main.resource1.tf`
    - `locals.resource1.tf`

### Example Directory and File Structure within an AVM Terraform Module Repository

```txt
/ Root of Repository.
│   (optional) locals.resource1.tf
│   (optional) main.resource1.tf
│   locals.tf
│   locals.version.tf.json
│   main.tf
│   outputs.tf
│   README.md
│   terraform.tf
│   variables.tf
│
├───examples
├───modules
└───tests
```

## Module Publishing

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<armresourcename>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***

## Telemetry Enablement

To meet [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) & [SFR4](/Azure-Verified-Modules/specs/shared/#id-sfr4---category-telemetry---telemetry-enablement-flexibility) you should use the below code sample in your AVM Modules to achieve this:

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
