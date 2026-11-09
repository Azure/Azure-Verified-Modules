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

Access for Terraform module owners is granted via the **Azure Verified Modules (AVM) Module Contributors** Entra access package. Request access here:

- [Azure Verified Modules (AVM) Module Contributors — Access Package](https://aka.ms/avm/id/access-package/module-contributor)

Once approved, you will be added to the [`azure-verified-modules-module-contributors`](https://aka.ms/avm/id/groups/module-contributors) Entra group, which is the source of truth for who is authorized to own and approve changes on AVM Terraform module repositories.

{{% notice style="tip" %}}
Until your access request is approved, you can continue to contribute by using JIT elevation and by raising PRs that are approved by an existing module owner.
{{% /notice %}}

## Required Tooling

{{% notice style="tip" %}}
`Avm.Authoring` supports Windows, Linux, and macOS. Use PowerShell 7.4 or later on every platform.
{{% /notice %}}

- [Git](https://git-scm.com/downloads)

  ```powershell
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```

- [PowerShell 7.4 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- [`Avm.Authoring`](https://github.com/Azure/azure-verified-modules-tools#install) from Microsoft Artifact Registry (MAR)

  MAR is not registered by default. Use `Microsoft.PowerShell.PSResourceGet` 1.2.0 or later. If needed, upgrade it, then start a new PowerShell session:

  ```powershell
  Install-PSResource -Name Microsoft.PowerShell.PSResourceGet `
      -Version 1.2.0 `
      -Repository PSGallery `
      -Scope CurrentUser
  ```

  Register MAR once, then install the module:

  ```powershell
  Import-Module Microsoft.PowerShell.PSResourceGet -MinimumVersion 1.2.0
  Register-PSResourceRepository -Name MAR `
      -Uri 'https://mcr.microsoft.com' `
      -ApiVersion ContainerRegistry `
      -Trusted
  Install-PSResource -Name avm.authoring `
      -Repository MAR `
      -Scope CurrentUser
  Import-Module Avm.Authoring
  avm doctor
  ```

  Use lowercase `avm.authoring` for the registry lookup; no Azure sign-in is needed. To update from MAR, repeat `Install-PSResource` with `-Reinstall`, then start a new PowerShell session. `avm update` still uses PowerShell Gallery. The module downloads, verifies, and caches its managed tools, including Terraform, on demand. Run `avm doctor --install` to preload every supported tool. Docker and Podman are not required.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [HashiCorp Terraform extension](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
  - [Microsoft Azure Terraform extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)
  - [EditorConfig extension](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
