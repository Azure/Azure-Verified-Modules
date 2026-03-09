---
title: Prerequisites
linktitle: Prerequisites
description: Prerequisites for contributing to AVM Terraform modules
weight: 1
---

## GitHub Account

To contribute, you need a GitHub account. If you are a Microsoft employee, your account must be [linked](https://repos.opensource.microsoft.com/link) to your corporate identity and you must be a member of the [Azure](https://repos.opensource.microsoft.com/orgs/Azure) organization.

## Required Tooling

{{% notice style="tip" %}}
We recommend Linux, macOS, or Windows Subsystem for Linux (WSL) for your development environment.
{{% /notice %}}

- [Git](https://git-scm.com/downloads)

  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```

- [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Docker](https://www.docker.com/pricing/#/download) (or [Podman](https://podman-desktop.io/downloads)) — required for running `./avm` pre-commit and pr-check commands
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [HashiCorp Terraform extension](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
  - [Microsoft Azure Terraform extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)
  - [EditorConfig extension](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
