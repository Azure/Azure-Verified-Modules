---
draft: true
title: Using AVM with GitHub Copilot
linktitle: Using AVM with GitHub Copilot
type: default
weight: 3
description: How to use GitHub Copilot to accelerate creation and maintainance of Azure Verified Modules (AVM) for both Bicep and Terraform.
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

> [!NOTE]
> We recommend using Visual Studio Code. This guide focuses on GitHub Copilot & GitHub Copilot Chat in Visual Studio Code. Many of the concepts and approaches may be available in other IDEs that support GitHub Copilot, such as JetBrains IDEs and Visual Studio. But at the time of writing this Guide, Visual Studio Code provides the most complete feature set for GitHub Copilot users.

## Getting Setup

To get started with using GitHub Copilot for AVM module development, you'll need to have the following prerequisites in place:

1. [Visual Studio Code](https://code.visualstudio.com/download) or [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) installed.

> [!NOTE]
> You can also use GitHub Codespaces to work on thees repos without needing to install anything locally. For example, open the [https://github.com/Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) repository in GitHub Codespaces by clicking the button below:
> [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Azure/bicep-registry-modules)

1. GitHub Copilot extension installed and configured
1. Basic understanding of AVM modules and their structure

Topics/concepts that are relevant and applicable for both Bicep and Terraform.

### Configuring MCP Servers

### Adding Prompt Files

### Adding Modes

## Using GitHub Copilot with AVM IaC

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
