---
draft: false
title: AI-assisted solution development
linktitle: AI-assisted solution development
description: Guidance for the Azure Verified Modules (AVM) program on how AI assisted deployment can be used to accelerate solution development using AVM modules.
---

{{% notice style="warning" title="Experimental Content" icon="flask" %}}

The content in this section represents **experimental explorations** of emerging technologies and innovative approaches. To learn more about our experimental content and its implications, please refer to the [Experimental Section Overview]({{% siteparam base %}}/experimental).

{{% /notice %}}

This section explains concepts of developing IaC solution templates using Azure Verified Modules (AVM) with the assistance of AI tools such as GitHub Copilot and covers how AI-assisted development can accelerate the process of building and deploying Azure solutions using AVM modules.

This approach is referred to as **AI-assisted solution development** rather than AI-driven or AI-led because humans remain fully in control of architectural decisions and solution design - AI simply handles the tedious, error-prone tasks of code generation and standards compliance, amplifying human ingenuity rather than replacing it.

## AVM and GitHub Copilot

In the rapidly evolving landscape of AI, the convergence of **Azure Verified Modules (AVM)** and **GitHub Copilot** represents a transformative approach to building Azure solutions, addressing the fundamental challenges developers face: maintaining quality, consistency, and speed while navigating the complexity of modern cloud architectures.

### How They Work Together

1. **AVM provides the foundational "knowledge base"**: Comprehensive, standardized, continuously updated, pre-validated modules that embody Azure best practices, security standards, and architectural patterns. Each module undergoes rigorous testing and validation, ensuring reliability and compliance with Microsoft's standards.
2. **GitHub Copilot brings the AI-powered intelligence to the development workflow**: AI-assisted code generation, module discovery, and real-time guidance based on AVM specifications with understanding both natural language intent and code context. Equipped with knowledge of AVM specifications and practices, Copilot serves as an expert guide that can:
    - **Intelligently discover and recommend** the appropriate AVM modules for your specific requirements
    - **Generate compliant infrastructure code** that adheres to AVM standards and Azure best practices
    - **Accelerate development cycles** by automating repetitive tasks and reducing manual lookups
    - **Maintain consistency** across your infrastructure codebase
    - **Reduce errors** by leveraging validated patterns and catching compliance issues early
3. **Developers focus on solution architecture**: This enables teams to dedicate more time to designing solutions that meet business requirements, rather than working on repetitive tasks.

This synergy means developers can express their infrastructure needs in natural language, and Copilot translates these into production-ready IaC code using validated AVM modules, complete with appropriate configurations, security settings, and dependencies.

### The Result

What once required hours of documentation review, module discovery, and manual code writing can now be accomplished in minutes. Infrastructure teams can iterate faster, maintain higher quality standards, and deliver Azure solutions with confidence, knowing they're built on a foundation of verified, best-practice modules guided by AI technology.

The combination of human expertise, verified infrastructure modules, and AI assistance creates a new opportunity to transform how we build and deploy cloud solutions at scale.
