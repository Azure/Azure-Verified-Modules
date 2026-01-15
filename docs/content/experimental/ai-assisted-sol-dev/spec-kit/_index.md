---
draft: false
title: Spec-Kit
linktitle: Spec-Kit
description: Guidance for the Azure Verified Modules (AVM) program on how Spec-Kit can be used to accelerate solution development using AVM modules.
---

{{% notice style="warning" title="Experimental Content" icon="flask" %}}

The content in this section represents **experimental explorations** of emerging technologies and innovative approaches. To learn more about our experimental content and its implications, please refer to the [Experimental Section Overview]({{% siteparam base %}}/experimental).

{{% /notice %}}

## Overview

**Spec-Kit** is a reference implementation of [Specification-Driven Development (SDD)]({{% siteparam base %}}/experimental/ai-assisted-sol-dev/sdd) principles, developed collaboratively by Microsoft engineers and open source contributors. It provides a structured, AI-native workflow for translating project requirements into specifications, plans, and executable tasks—demonstrating how SDD concepts can be operationalized with GitHub Copilot.

**For detailed information, including installation instructions and usage guidelines, visit the official repository**: [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

{{% notice style="tip" %}}

On a Windows PC, to get the **uv package manager CLI** tool required for locally installing the **Specify CLI**, run the following command:

`winget install astral-sh.uv`

{{% /notice %}}

## The Spec-Kit Workflow

Spec-Kit guides development teams through a systematic process that ensures specifications remain the single source of truth throughout the development lifecycle:

{{< mermaid zoom="false">}}

flowchart TB
    subgraph CAS["Constitution&nbsp;and&nbsp;Specification"]
        direction LR
        A["**Step 1**<br><code>/speckit.constitution</code><br>Establish project principles"] --> B["**Step 2**<br><code>/speckit.specify</code><br>Create baseline specification"]
        B --> C["**Step 3** <br><code>/speckit.clarify</code><br>(optional)<br>Ask structured questions"]
    end

    subgraph PAT["Implementation&nbsp;Plan&nbsp;and&nbsp;Tasks"]
        direction LR
        D["**Step 4** <br><code>/speckit.plan</code><br>Create implementation plan"] --> E["**Step 5** <br><code>/speckit.checklist</code><br>(optional)<br>Generate quality checklists"]
        E --> F["**Step 6** <br><code>/speckit.tasks</code><br>Generate actionable tasks"]
        F --> G["**Step 7** <br><code>/speckit.analyze</code><br>(optional)<br>Consistency & alignment report"]
    end

    subgraph IMP["Implementation"]
        H["**Step 8** <br><code>/speckit.implement</code><br>Execute<br>implementation"]
    end

    CAS --> PAT
    PAT --> IMP

    style C fill:#e1f5ff
    style E fill:#e1f5ff
    style G fill:#e1f5ff
    style CAS fill:#f5f5f5,stroke:#999999
    style PAT fill:#f5f5f5,stroke:#999999
    style IMP fill:#f5f5f5,stroke:#999999
{{< /mermaid >}}

Each command in the workflow works with [a number of AI agents](https://github.com/github/spec-kit?tab=readme-ov-file#-supported-ai-agents), including GitHub Copilot, enabling AI-assisted processing through the specification-to-implementation pipeline while maintaining human control over architectural decisions and project direction.


