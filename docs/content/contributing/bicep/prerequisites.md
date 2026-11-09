---
title: Bicep Contribution Prerequisites
linktitle: Prerequisites
description: Bicep Contribution Prerequisites for the Azure Verified Modules (AVM) program
---


## GitHub Account Link and Access

You need to have a personal GitHub account which is [linked](https://aka.ms/LinkYourGitHubAccount) to your Microsoft corporate identity. Once the link step is complete you must join the [Azure](https://repos.opensource.microsoft.com/orgs/Azure) organization.

## Recommended Learning

Before you start contributing to the AVM, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Bicep

- [Deploy and manage resources in Azure by using Bicep](https://learn.microsoft.com/learn/paths/bicep-deploy/)
- [Bicep file structure and syntax](https://learn.microsoft.com/azure/azure-resource-manager/bicep/file)
- [Best practices for Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/best-practices)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

## Tooling

### Required Tooling

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)

  If just installed, set your Git name and email:

    ```PowerShell
    git config --global user.name "John Doe"
    git config --global user.email "johndoe@example.com"
    ```

- [PowerShell 7.4 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- [`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring)

  ```powershell
  Install-PSResource Avm.Authoring
  Import-Module Avm.Authoring
  avm doctor
  ```

  If you already have an older installation, run `avm update` and import the updated module. `Avm.Authoring` downloads and caches its pinned Bicep CLI on demand for authoring commands; no separate Bicep installation is needed for those commands. See [initializing and updating Bicep module files]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/).

- [Pester](https://pester.dev/docs/introduction/installation) for the existing Bicep Pester and local deployment test scripts. `avm pre-commit` does not run those tests.
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

#### Visual Studio Code Extensions

- [CodeTour extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.codetour)
- [ARM Tools extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
- [ARM Template Viewer extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)
- [PSRule extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bewhite.psrule-vscode)
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

#### Desktop Tooling

- [GitHub Desktop](https://desktop.github.com/)
  - To enhance streamlined integration during interactions with upstream repositories, GitHub Desktop will automatically configure your local git repository to use the upstream repository as a remote.
