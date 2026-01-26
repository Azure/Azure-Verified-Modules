---
draft: false
title: Using AVM with GitHub Copilot
linktitle: Using AVM with GitHub Copilot
type: default
weight: 1
description: How to use GitHub Copilot to accelerate creation and maintenance of Azure Verified Modules (AVM) for both Bicep and Terraform.
---

{{% notice style="note" %}}

This page is a work in progress and will be updated as we improve & finalize the content. Please check back regularly for updates.

{{% /notice %}}

## Introduction

When developing Azure solutions using Azure Verified Modules (AVM), there are several areas that GitHub Copilot can help you be more productive when working with Infrastructure as Code (IaC) for both Bicep and Terraform.:

1. [Creation of your AVM IaC from scratch](#creating-avm-iac-from-scratch)
1. [Copying and adapting existing AVM code snippets and examples](#copying-and-adapting-existing-avm-code-snippets)
1. [Converting non-AVM IaC to use AVM](#converting-non-avm-iac-to-use-avm)
1. [Refactoring Existing AVM IaC to Use Different Technologies or Architectures](#refactoring-existing-avm-iac-to-use-different-technologies-or-architectures)
1. [Updating existing AVM modules to use the latest version](#updating-existing-avm-modules-to-use-the-latest-version)
1. [Creating documentation for your AVM IaC](#creating-documentation-for-your-avm-iac)

Using GitHub Copilot in Visual Studio Code (VS Code) will have a significant benefit in productivity across all three of these areas.

This page will help you use GitHub Copilot in Visual Studio Code to get an AI accelerated benefit when building your scenarios. It will also cover common concepts, approaches and tips that will help you get the most out of GitHub Copilot when working with AVM modules for both Bicep and Terraform.

{{% notice style="Visual Studio Code Recommended" %}}

We currently recommend using Visual Studio Code. This guide focuses on GitHub Copilot & GitHub Copilot Chat in Visual Studio Code. Many of the concepts and approaches may be available in other IDEs that support GitHub Copilot, such as JetBrains IDEs and Visual Studio. But at the time of writing this Guide, Visual Studio Code provides the most complete feature set for GitHub Copilot users.

{{% /notice %}}

## Setting up your Environment

To get started with using GitHub Copilot for AVM module development, you'll need to have the following prerequisites in place:

1. [Visual Studio Code](https://code.visualstudio.com/download) or [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) installed.

  {{% notice style="note" title="GitHub Codespaces" %}}

  You can also use GitHub Codespaces to work on thees repos without needing to install anything locally. For example, open the [https://github.com/Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) repository in GitHub Codespaces by clicking the button below:
  [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Azure/bicep-registry-modules)

  {{% /notice %}}

1. Install and configure the GitHub Copilot and GitHub Copilot Chat extensions, and optional, but recommended the GitHub Copilot for Azure extension.

  | Extension | Install VS Code | Install VS Code Insiders |
  |-----------|-----------------|--------------------------|
  | GitHub Copilot | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Aextension%2FGitHub.copilot) | [![Install in VS Code Insiders](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Aextension%2FGitHub.copilot) |
  | GitHub Copilot Chat | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Aextension%2FGitHub.copilot-chat) | [![Install in VS Code Insiders](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Aextension%2FGitHub.copilot-chat) |
  | GitHub Copilot for Azure | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Aextension%2Fms-azuretools.vscode-azure-github-copilot) | [![Install in VS Code Insiders](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Aextension%2Fms-azuretools.vscode-azure-github-copilot) |

{{% notice style="note" title="GitHub Codespaces" %}}

If you are using GitHub Codespaces, these extensions are already installed and configured for you.

{{% /notice %}}

1. Open Visual Studio Code or Visual Studio Code Insiders and sign in to GitHub Copilot using your GitHub account. See [Set up Copilot in VS Code](https://code.visualstudio.com/docs/copilot/setup) for more information.

{{% notice style="note" title="GitHub Copilot Account" %}}

Although a GitHub free account is sufficient to use GitHub Copilot to work with AVM, a GitHub Copilot Business or Pro subscription will provide acess to premium models, which enabled more reliably dealing with more complex AVM scenarios.

{{% /notice %}}

### Adding MCP Servers

Now that you've enabled GitHub Copilot, you can give it access to **tools**, such as searching _Microsoft Learn_ or getting _Azure Bicep Best practices_. Some VS Code extentions automatically provide you access to tools when you install them (for example, the [Github Copilot for Azure](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azure-github-copilot) extension. But other tools may be provided by [Model Context Protocol](https://modelcontextprotocol.io/introduction) (MCP) servers.

You should enable GitHub Copilot to access the following MCP Servers:

| MCP Server | Description | Install VS Code | Install VS Code Insiders |
|------------|-------------|-----------------|--------------------------|
| Microsoft Docs | Search and retrieve content from Microsoft Learn, Azure documentation, and official Microsoft technical resources. | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](vscode:mcp/install?%7B%22name%22%3A%22microsoft-docs%22%2C%22gallery%22%3Atrue%2C%22url%22%3A%22https%3A%2F%2Flearn.microsoft.com%2Fapi%2Fmcp%22%7D) | [![Install in VS Code Insiders](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](vscode-insiders:mcp/install?%7B%22name%22%3A%22microsoft-docs%22%2C%22gallery%22%3Atrue%2C%22url%22%3A%22https%3A%2F%2Flearn.microsoft.com%2Fapi%2Fmcp%22%7D) |

There are many other MCP Servers that you can configure GitHub Copilot to use, such as [GitHub](vscode:mcp/install?%7B%22name%22%3A%22github%22%2C%22gallery%22%3Atrue%2C%22url%22%3A%22https%3A%2F%2Fapi.githubcopilot.com%2Fmcp%2F%22%7D), but these aren't required to get started with AVM module development. You can find a list of MCP Servers that are curated by the Visual Studio Code team on the [MCP Servers for agent mode](https://code.visualstudio.com/mcp) page.

For more information on configuring MCP Servers in Visual Studio Code, see the [Model Context Protocol](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) page in the Visual Studio Code documentation.

### Custom Chat Modes

Chat modes in Visual Studio Code let you customize how GitHub Copilot Chat responds for different tasks—like answering questions, editing code, or running automated workflows. You can easily switch between modes in the Chat view to match what you need to do. The default Agent chat mode is great for general tasks, but often makes mistakes or assumptions when it comes to building IaC using AVM modules. For example, it is extremely common for GitHub Copilot to use older or even hallucinated AVM modules.

To prevent these issues we can set up custom chat modes that give GitHub Copilot clear guidance and context for AVM scenarios. This includes providing clear instructions on how GitHub Copilot should retrieve AVM best practices, module documentation and the current versions of each module.

| IaC Type | Title | Description | Install |
| -------- | ----- | ----------- | ------- |
| Bicep | [Azure AVM Bicep mode](chatmodes/azure-verified-modules-bicep.chatmode.md) | Create, update, or review Azure IaC in Bicep using Azure Verified Modules (AVM). | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Achat-chatmode%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fchatmodes%2Fazure-verified-modules-bicep.chatmode.md) [![Install in VS Code](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Achat-chatmode%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fchatmodes%2Fazure-verified-modules-bicep.chatmode.md) |
| Terraform | [Azure AVM Terraform mode](chatmodes/azure-verified-modules-terraform.chatmode.md) | Create, update, or review Azure IaC in Terraform using Azure Verified Modules (AVM). | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Achat-chatmode%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fchatmodes%2Fazure-verified-modules-terraform.chatmode.md) [![Install in VS Code](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Achat-chatmode%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fchatmodes%2Fazure-verified-modules-terraform.chatmode.md) |

{{% notice style="note" title="Awesome-Copilot Repository on GitHub" %}}

These custom chat modes are available in the [GitHub Awesome Copilot repository](https://github.com/github/awesome-copilot).

{{% /notice %}}

For more information on creating custom chat modes in Visual Studio Code, see [Custom chat modes](https://code.visualstudio.com/docs/copilot/chat/chat-modes#_custom-chat-modes) page in the Visual Studio Code documentation.

#### To install a custom chat mode

1. Click the custom chat mode to install from the table above.
1. Confirm that you want to install the custom chat mode:

  <img src="{{% siteparam base %}}/images/usage/gh-copilot/github-copilot-chat-mode-install-confirm.png" alt="Confirm installation of Prompt File into VS Code" style="max-width:800px;" />

1. Select whether to install the custom chat mode into this workspace (`.github/chatmode/`) or into your global user account, making it available to every workspace you work on.

  <img src="{{% siteparam base %}}/images/usage/quickstart/github-copilot/github-copilot-chat-mode-install-location.png" alt="Select scope of Prompt File" style="max-width:800px;" />

1. You can choose a name for the custom chat mode, or leave it as the default name.

  <img src="{{% siteparam base %}}/images/usage/quickstart/github-copilot/github-copilot-chat-mode-install-name.png" alt="Select scope of Prompt File" style="max-width:800px;" />

Once the custom chat mode is installed, you can switch to it in the GitHub Copilot chat box by clicking the `Agent` dropdown and selecting the custom chat mode from the list of available chat modes.

### Custom Prompt Files

Custom prompt files allow you to define reusable prompts that can be used with GitHub Copilot Chat to perform complex mulit-step tasks. These prompts can be used to help you with common tasks when working with AVM modules, such as updating your Bicep files to use the latest versions of Azure Verified Modules (AVM).

It is recommended to install the following prompt files to help you perform common tasks when working with AVM modules:

| IaC Type | Title | Description | Install |
| -------- | ----- | ----------- | ------- |
| Bicep | [Update Azure Verified Modules in Bicep Files](prompts/update-avm-modules-in-bicep.prompt.md) | Update all the Azure Verified Modules (AVM) in the selected Bicep files to the latest versions. | [![Install in VS Code](https://img.shields.io/badge/VS_Code-Install-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://vscode.dev/redirect?url=vscode%3Achat-prompt%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fprompts%2Fupdate-avm-modules-in-bicep.prompt.md) [![Install in VS Code](https://img.shields.io/badge/VS_Code_Insiders-Install-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Achat-prompt%2Finstall%3Furl%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fgithub%2Fawesome-copilot%2Fmain%2Fprompts%2Fupdate-avm-modules-in-bicep.prompt.md) |
| Terraform | Update Azure Verified Modules in Terraform Files | Not yet available | Coming soon |

{{% notice style="note" title="Awesome-Copilot Repository on GitHub" %}}

These prompt files are available in the [GitHub Awesome Copilot repository](https://github.com/github/awesome-copilot).

{{% /notice %}}

#### To install a prompt file

1. Click the prompt file to install from the table.
1. Confirm that you want to install the prompt file:

  <img src="{{% siteparam base %}}/images/usage/quickstart/github-copilot/github-copilot-prompt-file-install-confirm.png" alt="Confirm installation of Prompt File into VS Code" style="max-width:800px;" />

1. Select whether to install the prompt file into this workspace (`.github/prompts/`) or into your global user account, making it available to every workspace you work on.

  <img src="{{% siteparam base %}}/images/usage/quickstart/github-copilot/github-copilot-prompt-file-install-location.png" alt="Select scope of Prompt File" style="max-width:800px;" />

1. You can choose a name for the prompt file, or leave it as the default name.

  <img src="{{% siteparam base %}}/images/usage/quickstart/github-copilot/github-copilot-prompt-file-install-name.png" alt="Select scope of Prompt File" style="max-width:800px;" />

Once the prompt file is installed, you can use it by typing `/` in the GitHub Copilot Agent input box and selecting the prompt file from the list of available prompts.

### Instruction Files

TBC - currently no AVM specific instruction files are available (there are TF and Bicep ones though)

## How to use GitHub Copilot with AVM

GitHub Copilot can significantly enhance your productivity when working with Azure Verified Modules (AVM) for both Bicep and Terraform. It can assist you in various tasks, such as creating new AVM IaC from scratch, copying and adapting existing AVM code snippets, converting non-AVM IaC to use AVM, refactoring existing AVM IaC to use different technologies or architectures, updating existing AVM modules to use the latest version, and creating documentation for your AVM IaC.

### Creating AVM IaC from Scratch

When starting a new AVM module, you can use GitHub Copilot to help generate the initial structure and boilerplate code. For example, you can start typing a comment or a function name, and GitHub Copilot will suggest completions based on the context of your code.

### Copying and Adapting Existing AVM Code Snippets

If you have existing AVM code snippets or examples, you can use GitHub Copilot to help adapt them to your specific needs. For example, you can copy an existing module and start modifying it, and GitHub Copilot will suggest changes based on the context of your modifications.

### Converting Non-AVM IaC to Use AVM

If you have existing Infrastructure as Code (IaC) that does not use AVM, you can use GitHub Copilot to help convert it to use AVM. For example, you can start by copying the existing code and then modify it to use AVM modules, and GitHub Copilot will suggest changes based on the context of your modifications.

### Refactoring Existing AVM IaC to Use Different Technologies or Architectures

If you need to refactor existing AVM IaC to use different technologies or architectures, GitHub Copilot can help. For example, if you're moving to a zero trust architecture, you can start by modifying the existing code and GitHub Copilot will suggest changes based on the context of your modifications.

### Updating Existing AVM Modules to Use the Latest Version

When a new version of an AVM module is released, you can use GitHub Copilot to help update your existing code to use the latest version. For example, you can start by modifying the module version in your code and GitHub Copilot will suggest changes based on the context of your modifications.

### Creating Documentation for Your AVM IaC

GitHub Copilot can also help you create documentation for your AVM IaC. For example, you can start by writing a comment or a function name, and GitHub Copilot will suggest documentation based on the context of your code. This can help you create consistent and comprehensive documentation for your AVM modules.
