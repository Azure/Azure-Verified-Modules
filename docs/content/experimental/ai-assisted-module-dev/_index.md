---
draft: false
title: AI-Assisted Module Development
linktitle: AI-Assisted Module Dev
description: Using GitHub Copilot and related AI features to develop and maintain Azure Verified Modules (AVM).
---

{{% notice style="warning" title="Experimental Content" icon="flask" %}}

The content in this section represents **experimental exploration** of emerging technologies and innovative approaches. To learn more about our experimental content and its implications, please refer to the [Experimental Section Overview]({{% siteparam base %}}/experimental).

{{% /notice %}}

{{% notice style="info" title="For Module Owners" icon="user-gear" %}}

This section covers **module development and maintenance scenarios** and is primarily relevant for **AVM module owners**. If you are an end user looking to leverage AVM to develop complex solutions using AI, see [AI-Assisted IaC Solution Development]({{% siteparam base %}}/experimental/ai-assisted-sol-dev).

{{% /notice %}}

## Overview

AVM module owners and members of the AVM core team can leverage **GitHub Copilot** and related AI capabilities to accelerate the development, maintenance, and validation of AVM Bicep modules. By embedding AVM-specific knowledge directly into the development environment, we reduce manual effort, improve consistency, and help ensure compliance with AVM specifications from the start.

The AVM core team is building a set of AI-powered assets that GitHub Copilot can use to provide AVM-aware assistance. These assets fall into several categories:

- **Custom Instructions**: Markdown files that automatically guide GitHub Copilot's behavior whenever it generates or reviews code, providing persistent context about the project's baseline, such as coding standards and compliance requirements.
- **Custom Agents**: Specialized AI personas that focus on a specific workflow (e.g., planning, implementing, or validating module changes), each with a defined scope, tools, and the ability to hand off work to other agents.
- **Prompt Files**: Reusable, parameterized task templates that define a specific analysis or action for Copilot to perform, targeting specific modules or files.
- **Skills**: Detailed, step-by-step workflow definitions that encode domain-specific expertise. Skill descriptions are included in the system prompt on every chat turn, but their full content is loaded into context on demand — only when the model determines relevance to the user's request or the user explicitly invokes the skill.

The actual implementations of these assets may vary between Bicep and Terraform, and they will evolve over time as best practices emerge and capabilities mature. The AVM core team will continue adding documentation and examples as we make progress - both developing new assets from scratch and refining existing ones.

{{% notice style="orange" title="Coming Soon" icon="hourglass-half" %}}

Content for AI-assisted AVM Terraform module development is currently being developed and will be available soon. Stay tuned for updates!

{{% /notice %}}
