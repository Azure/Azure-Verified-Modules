---
title: Prerequisites
linktitle: Prerequisites
description: Prerequisites for contributing to AVM Terraform modules
weight: 1
---

## GitHub Account

To contribute, you need a GitHub account. If you are a Microsoft employee, your account must be [linked](https://repos.opensource.microsoft.com/link) to your corporate identity and you must be a member of the [Azure](https://repos.opensource.microsoft.com/orgs/Azure) organization.

## Module Owner Access (Microsoft FTEs only)

{{% notice style="note" %}}
This step is **only required if you are (or are becoming) a Terraform module owner**. External contributors and one-off contributors do not need this access.
{{% /notice %}}

Access for Terraform module owners is granted via the **AVM Terraform Module Owners** Entra access package. Request access here:

- [AVM Terraform Module Owners — Access Package](https://myaccess.microsoft.com/@microsoft.onmicrosoft.com#/access-packages/b45b0231-c5ab-43fe-94b1-1efd0547bd67)

Once approved, you will be added to the [`AVM Terraform Module Owners`](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/GroupDetailsMenuBlade/~/Overview/groupId/006e73c9-4e67-4e08-903e-527b1547262c) Entra group, which is the source of truth for who is authorized to own and approve changes on AVM Terraform module repositories.

{{% notice style="tip" %}}
Until your access request is approved, you can continue to contribute by using JIT elevation and by raising PRs that are approved by an existing module owner.
{{% /notice %}}

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
