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

## Telemetry Enablement

To meet [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) & [SFR4](/Azure-Verified-Modules/specs/shared/#id-sfr4---category-telemetry---telemetry-enablement-flexibility) you can use the below code sample in your AVM Modules to achieve this.

{{< include file="/static/includes/sample.telem.tf" language="terraform" options="linenos=false" >}}
