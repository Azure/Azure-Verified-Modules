---
title: Prerequisites
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

<!--
NOTE:

Removed ## Recommended Learning since advanced (not basic) knowledge is required around Git, TF and Docker, it is considered a hard requirement. Someone just looking at the Terraform Docs or code and trying to figure out how to contribute will not be successful. Contributors need to have a good understanding and holistic view of all tools and how to use them.

-->

## Tooling

### Required Tooling

{{< hint type=tip >}}

We **strongly** recommend you use Linux or MacOS for your development environment. You can use Windows Subsystem for Linux (WSL) if you are using Windows.

{{< /hint >}}

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)

  If just installed, don't forget to set both your git username & password

  ```PowerShell
  git config --global user.name "John Doe"
  git config --global user.email "johndoe@example.com"
  ```

- [Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)

  {{< hint type=note >}}

  Must be manually kept up-to-date.

  {{< /hint >}}

- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Terraform extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
  - [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

<br>

---

<br>

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

<br>

---

<br>

#### Visual Studio Code Extensions

- [CodeTour extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.codetour)
- [Go extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=golang.go)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

<br>

---

<br>

#### Desktop/CLI Tooling

- [Go (for writing tests)](https://go.dev/doc/install)
- [tfenv](https://github.com/tfutils/tfenv) - useful when working on multiple modules that use different Terraform versions from the same machine
- [grept](https://github.com/Azure/grept) - powerful linting tool for repositories, ensures predefined standards, maintains codebase consistency, and quality
- [Docker](https://www.docker.com/pricing/#/download) - for executing e2e tests, formatting code and to make sure to meet pipeline requirements using the [Azure Verified Terraform Scaffold](https://github.com/Azure/tfmod-scaffold)
- [GitHub Desktop](https://desktop.github.com/)
  - To enhance streamlined integration during interactions with upstream repositories, GitHub Desktop will automatically configure your local git repository to use the upstream repository as a remote.

<br>

---

<br>
