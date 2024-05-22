---
title: Prerequisites
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## GitHub Account Link and Access

To contribute to this project, you need to have a GitHub account which is [linked](https://repos.opensource.microsoft.com/link) to your Microsoft corporate identity account and be a member of the [Azure](https://repos.opensource.microsoft.com/orgs/Azure) organisation.

## Tooling

### Required Tooling

{{< hint type=tip >}}

We recommend to use Linux or MacOS for your development environment. You can use Windows Subsystem for Linux (WSL) if you are using Windows.

{{< /hint >}}

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)

  If just installed, don't forget to set both your git username & password

  ```PowerShell
  git config --global user.name "John Doe"
  git config --global user.email "johndoe@example.com"
  ```

- [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Terraform extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
  - [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- [Docker](https://www.docker.com/pricing/#/download)
  - [Azure Verified Terraform Scaffold](https://github.com/Azure/tfmod-scaffold) (`mcr.microsoft.com/azterraform:latest`)

<br>

---

<br>

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

- [Go (for writing tests)](https://go.dev/doc/install)
- [tfenv](https://github.com/tfutils/tfenv) - useful when working on multiple modules that use different Terraform versions from the same machine

#### Visual Studio Code Extensions

- [Go extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=golang.go)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

<br>

---

<br>
