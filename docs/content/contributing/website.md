---
title: Website Contribution Guide
linktitle: Website
description: Website Contribution Guidance for the Azure Verified Modules (AVM) program
---

Looking to contribute to the AVM Website, well you have made it to the right place/page. 👍

Follow the below instructions, especially the pre-requisites, to get started contributing to the library.

## Context/Background

Before jumping into the pre-requisites and specific section contribution guidance, please familiarize yourself with this context/background on how this library is built to help you contribute going forward.

This [site](https://aka.ms/avm) is built using [Hugo](https://gohugo.io/), a static site generator, that's source code is stored in the [AVM GitHub repo](https://aka.ms/avm/repo) (link in header of this site too) and is hosted on [GitHub Pages](https://pages.github.com), via the repo.

The reason for the combination of Hugo & GitHub pages is to allow us to present an easy to navigate and consume library, rather than using a native GitHub repo, which is not easy to consume when there are lots of pages and folders. Also, Hugo generates the site in such a way that it is also friendly for mobile consumers.

### But I don't have any skills in Hugo?

That's okay and you really don't need them. Hugo just needs you to be able to author markdown (`.md`) files and it does the rest when it generates the site 👍

## Pre-Requisites

Read and follow the below sections to leave you in a "ready state" to contribute to AVM.

A "ready state" means you have a forked copy of the [`Azure/Azure-Verified-Modules` repo](https://aka.ms/avm/repo) cloned to your local machine and open in VS Code.

## Run and Access a Local Copy of AVM Website During Development

When in VS Code you should be able to open a terminal and run the below commands to access a copy of the AVM website from a local web server, provided by Hugo, using the following address [`http://localhost:1313/Azure-Verified-Modules/`](http://localhost:1313/Azure-Verified-Modules/):

```text
cd docs
hugo server -D // you can add "--poll 700ms", if file changes are not detected
```

### Software/Applications

To contribute to this website, you will need the following installed:

{{% notice style="tip" %}}

You can use `winget` to install all the pre-requisites easily for you. See the [below section](#winget-install-commands)

{{% /notice %}}

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Visual Studio Code (VS Code)](https://code.visualstudio.com/Download)
  - Extensions:
    - `editorconfig.editorconfig`, `streetsidesoftware.code-spell-checker`, `ms-vsliveshare.vsliveshare`, `medo64.render-crlf`, `vscode-icons-team.vscode-icons`
    - VS Code will recommend automatically to install these when you open this repo, or a fork of it, in VS Code.
- [Hugo Extended](https://gohugo.io/installation/)

### winget Install Commands

To install `winget` follow the [install instructions here.](https://learn.microsoft.com/windows/package-manager/winget/#install-winget)

```text
winget install --id 'Git.Git'
winget install --id 'Microsoft.VisualStudioCode'
winget install --id 'Hugo.Hugo.Extended'
```

### Other requirements

- [A GitHub profile/account](https://github.com/join)
- A fork of the [`Azure/Azure-Verified-Modules` repo](https://aka.ms/avm/repo) into your GitHub org/account and cloned locally to your .
  - Instructions on forking a repo and then cloning it can be found [here](https://docs.github.com/get-started/quickstart/fork-a-repo).

## Useful Resources

Below are links to a number of useful resources to have when contributing to AVM:

- [Geekdocs Theme (that we use) - Docs](https://geekdocs.de/usage/getting-started/)
- [Hugo Quick Start](https://gohugo.io/getting-started/quick-start/)
- [Hugo Docs](https://gohugo.io/documentation/)
- [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/)

## Steps to do before contributing anything (after pre-requisites)

Run the following commands in your terminal of choice from the directory where you fork of the repo is located:

```text
git checkout main
git pull
git fetch -p
git fetch -p upstream
git pull upstream main
git push
```

Doing this will ensure you have the latest changes from the upstream repo, and you are ready to now create a new branch from `main` by running the below commands:

```text
git checkout main
git checkout -b <YOUR-DESIRED-BRANCH-NAME-HERE>
```

## Top Tips

### Sometimes the local version of the website may show some inconsistencies that don't reflect the content you have created

If this happens, simply kill the Hugo local web server by pressing `CTRL` + `C` and then restart the Hugo web server by running `hugo server -D` from the `docs/` directory.
