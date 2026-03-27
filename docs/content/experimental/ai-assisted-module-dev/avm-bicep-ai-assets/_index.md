---
draft: false
title: AVM Bicep AI Assets
linktitle: AVM Bicep AI Assets
description: Catalog of GitHub Copilot custom instructions, agents, prompts, and skills available in the BRM repository for AI-assisted AVM module development.
---

{{% notice style="warning" title="Experimental Content" icon="flask" %}}

The content in this section represents **experimental exploration** of emerging technologies and innovative approaches. To learn more about our experimental content and its implications, please refer to the [Experimental Section Overview]({{% siteparam base %}}/experimental).

{{% /notice %}}

This page provides a catalog of all AI-assisted development assets available in the [Bicep Registry Modules (BRM)](https://github.com/Azure/bicep-registry-modules) repository. Each asset is linked to its source file for full details.

## Custom Instructions

Custom instructions provide persistent, repository-wide context that shapes how GitHub Copilot generates and reviews code. They are automatically loaded by Copilot when working in the repository.

### Global Instructions

Global instructions provide GitHub Copilot with an overview of the AVM Bicep repository structure, critical compliance requirements (including mandatory AVM specification adherence), tool usage guidance, module discovery methods (AVM module index, MCR, Azure Resource Reference), and schema/API version lookup procedures. This is the primary instruction file that ensures all AI-generated code aligns with AVM standards.

See the full content of the global instructions here: [`.github/copilot-instructions.md`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/copilot-instructions.md)

## Skills

Skills encode complex, multi-step domain workflows into structured instructions that GitHub Copilot can follow precisely. They define prerequisites, rules, phases, and expected outputs. When the IDE starts, skill descriptions are indexed so that Copilot is aware of their existence and purpose. The full content of a skill is only loaded into the context when the user's prompt references a topic that aligns with the skill's described purpose.

### Child Module Publishing


**Source**: [`.github/skills/avm-child-module-publishing/SKILL.md`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/skills/avm-child-module-publishing/SKILL.md)
**Description**: Guides the end-to-end workflow for publishing a Bicep child module to the AVM public registry. Covers prerequisite verification, allowed-list registration, telemetry instrumentation, version file creation, changelog updates, parent module updates, and final validation. This skill implements the official [Child Module Publishing]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing/) workflow.

**Example prompt:**

```text
Publish AVM child module avm/res/network/virtual-network/virtual-network-peering
```

Note: in some cases, VS Code is not identifying the correct skill based on the above prompt. If this happens, you can try to use the follow prompt that explicitly triggers the correct skill:

```text
/avm-child-module-publishing Publish AVM child module avm/res/network/virtual-network/virtual-network-peering
```

## Prompt Files

Prompt files are reusable, parameterized task templates that can be invoked to perform specific analysis or planning tasks against a target module.

| Name / Source | Description | Example |
|---|---|---|
| **Tech-debt-analysis** [`.github/prompts/avm.tech-debt-analysis-ARM-API.prompt.md`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/prompts/avm.tech-debt-analysis-ARM-API.prompt.md)| Analyzes AVM Bicep modules for technical debt, including inconsistencies, documentation gaps, spelling mistakes, conflicting information, and quality issues across module files and examples. This is a read-only analysis — it does not modify any files. | `/AVM-Tech-debt-analysis` |
| **AVM-Update-module-with-latest-ARM-API-versions** [`.github/prompts/avm.create-plan-update-ARM-API.prompt.md`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/prompts/avm.create-plan-update-ARM-API.prompt.md)| Analyzes AVM Bicep modules to identify resources with outdated ARM API versions, compares them against the latest stable versions, and generates detailed implementation plans for required updates. This is a planning-only task — it does not modify any files. | `/AVM-Update-module-to-latest-API-versions` |
