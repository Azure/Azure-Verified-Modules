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

1. Creation of your AVM IaC from scratch
1. Copying and adapting existing AVM code snippets and examples
1. Converting non-AVM IaC to use AVM
1. Refactoring existing IaC that uses AVM to use different technologies or architectures, e.g. moving to zero trust architectures.
1. Updating existing AVM modules to use the latest version of the module
1. Creating documentation for your AVM IaC, such as design documentation and architecture diagrams (e.g. Mermaid)

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
