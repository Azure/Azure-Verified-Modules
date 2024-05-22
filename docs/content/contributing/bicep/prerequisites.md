---
title: Prerequisites
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## GitHub Account Link and Access

You need to have a personal GitHub account which is [linked](https://aka.ms/LinkYourGitHubAccount) to your Microsoft corporate identity. Once the link step is complete you must join the [Azure](https://repos.opensource.microsoft.com/orgs/Azure) organization.

## Recommended Learning

Before you start contributing to the AVM, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Bicep

- [Deploy and manage resources in Azure by using Bicep](https://learn.microsoft.com/learn/paths/bicep-deploy/)
- [Structure your Bicep code for collaboration](https://learn.microsoft.com/learn/modules/structure-bicep-code-collaboration/)
- [Manage changes to your Bicep code by using Git](https://learn.microsoft.com/learn/modules/manage-changes-bicep-code-git/)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

<br>

## Tooling

### Required Tooling

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)

  If just installed, don't forget to set both your git username & password

    ```PowerShell
    git config --global user.name "John Doe"
    git config --global user.email "johndoe@example.com"
    ```

- [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually)

  {{< hint type=note >}}

  Must be manually kept up-to-date.

  {{< /hint >}}

- [Pester](https://pester.dev/docs/introduction/installation)
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

<br>
