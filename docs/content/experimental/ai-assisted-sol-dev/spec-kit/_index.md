---
draft: false
title: Spec Kit
linktitle: Spec Kit
description: Guidance for the Azure Verified Modules (AVM) program on how Spec Kit can be used to accelerate solution development using AVM modules.
---

{{% notice style="warning" title="Experimental Content" icon="flask" %}}

The content in this section represents **experimental explorations** of emerging technologies and innovative approaches. To learn more about our experimental content and its implications, please refer to the [Experimental Section Overview]({{% siteparam base %}}/experimental).

{{% /notice %}}

## Overview

**Spec Kit** is a reference implementation of [Specification-Driven Development (SDD)]({{% siteparam base %}}/experimental/ai-assisted-sol-dev/sdd) principles, developed by members of the open-source community, including engineers from Microsoft and Anthropic. It provides a structured, AI-native workflow for translating project requirements into specifications, plans, and executable tasks - demonstrating how SDD concepts can be operationalized.

**For detailed information (installation instructions, usage guidelines, etc.) visit the official repository**: [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

### Example Scenario

In this chapter we'll explore each step of the Spec Kit workflow in detail. We'll use the following example to illustrate the process: using AVM modules, we need to develop a solution that will host a simple legacy application on a Windows virtual machine (VM). The solution must be secure and auditable. The VM must not be accessible from the internet and its logs should be easily accessible.

## The Spec Kit Workflow

Spec Kit guides development teams through a systematic process that ensures specifications remain the single source of truth throughout the development lifecycle:

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

    click A "#1-constitution"
    click B "#2-specify"
    click C "#3-clarify-optional"
    click D "#4-plan"
    click E "#5-checklist-optional"
    click F "#6-tasks"
    click G "#7-analyze-optional"
    click H "#8-implement"

    style C fill:#e1f5ff
    style E fill:#e1f5ff
    style G fill:#e1f5ff
    style CAS fill:#f5f5f5,stroke:#999999
    style PAT fill:#f5f5f5,stroke:#999999
    style IMP fill:#f5f5f5,stroke:#999999
{{< /mermaid >}}

Each command in the workflow works with [a number of AI agents](https://github.com/github/spec-kit?tab=readme-ov-file#-supported-ai-agents), including GitHub Copilot, enabling AI-assisted processing through the specification-to-implementation pipeline while maintaining human control over architectural decisions and project direction.

### 1. Constitution

The constitution document (`constitution.md`) establishes the governing principles, development guidelines and project-wide constraints that every later step (spec, plan, tasks, implementation) must follow. It acts as the "North Star" for the AI agent. It ensures that fundamental requirements are always met by encoding architectural, compliance, security, coding, and operational rules.

Spec Kit uses `/speckit.constitution` to generate the `constitution.md` file. The constitution can be evolved through iterating over the `constitution.md` file by either manually editing it or repeatedly fine tuning the prompt used with `/speckit.constitution`.

**The constitution typically includes:**

- Required engineering standards
- Guardrails and constraints
- Required / discouraged patterns
- Organizational coding standards
- Testing expectations
- Cloud/platform governance
- Naming conventions, tagging rules
- Compliance/security requirements

Following our [scenario](#example-scenario), here are some examples for what the prompt used to generate the constitution should include:

1. **Architecture & Cloud Rules**
    - Infrastructure must be declarative and written in Bicep only.
    - Must use Azure Verified Modules (AVM) for all supported resource types.
    - Deployment must follow a modular architecture using AVM best practices/standards.

2. **Security & Compliance**
    - Enforce NSG rules, disable all incoming traffic from the internet, require JIT.
    - OS hardening baseline must be applied via VM extension or custom script.
    - All storage must have private endpoints and be encrypted using CMK if required.

3. **Ops & Reliability**
    - Centralized logging via Azure Monitor / Log Analytics workspace.
    - Diagnostics extensions required for Windows Server.

4. **Naming & Tagging**
    - All resources follow Microsoft Cloud Adoption Framework naming conventions.
    - Mandatory tags: owner, costCenter, env, application.

5. **Testing Expectations**
    - Deployment must succeed in at least one Azure region with a Windows Server SKU supported by AVM (e.g., 2022 Datacenter).

### 2. Specify

The specification document (`spec.md`) is used to define the baseline specification for the product, focusing on "the what and the why" rather than the low-level technical requirements. It's detached from the implementation, meaning, the same spec can be used even if the underlying technology changes.

The specification describes WHAT you want to build and WHY - not how. It is focused on user needs, functional requirements, constraints, and success criteria.

Spec Kit uses `/speckit.specify` to generate the `spec.md` file. Specifications can be evolved through iterating over the `spec.md` file by either manually editing it or repeatedly fine tuning the prompt used with `/speckit.specify` and leveraging `/speckit.clarify` to review and challenge the specification.

**The specification typically includes:**

- Feature description
- User/problem statements
- Functional and non-functional requirements
- Scenarios & their constraints
- Input/output expectations
- Success criteria

Following our [scenario](#example-scenario), here are some examples for what the prompt used to generate the specification should include:

1. **What we are building**
    - "A deployable IaC template, based on Azure Verified Modules, that provisions a secure single-VM environment suitable for hosting a legacy Windows Server-based line-of-business application."

2. **Functional Requirements**
    - Deploy all Azure resources through referencing the corresponding AVM module (if available).
    - Deploy required network components: VNet, Subnets, NSG, Bastion, optionally NAT gateway.
    - Install app binaries via Custom Script Extension.
    - Expose the application through an internal load balancer (if needed).

3. **Non-Functional Requirements**
    - Must support repeatable deployments across environments (dev/test/prod).
    - Must comply with corporate security baselines.

4. **Constraints**
    - Legacy application cannot be containerized.
    - Only one VM instance supported.
    - No direct internet access allowed.

5. **User Inputs**
    - VM size, OS license type, admin credentials (via Key Vault), virtual network ranges.

6. **Success Criteria**
    - VM deploys successfully and application runs.
    - Diagnostics logs are set to be collected.
    - Deployment is fully reproducible and parameterized.


### 3. Clarify (Optional)

The clarify step is used to identify missing information, ambiguity, contradictions, or incompleteness in the specification. It runs a structured Q&A loop where the AI agent asks questions derived from the spec and your constitution, ensuring high-quality requirements before planning. This step is crucial when the initial specification is incomplete or ambiguous - which is common for infra projects.

Spec Kit uses `/speckit.clarify` to generate adjust information captured in `spec.md`. The prompt doesn't require any specific inputs as it analyzes the existing specification for gaps.

### 4. Plan

This step is where the technical requirements for the project are defined. Spec Kit consults the constitution to ensure that the non-negotiable principles are respected. The plan turns the specification into a technical architecture and concrete design. It defines how the system will be built - including technical stack and architecture choices. It also outlines the execution flow, primary dependencies, testing approaches, target platforms, and architecture principles.

Spec Kit uses `/speckit.plan` to generate the `plan.md` file. The plan can be evolved through iterating over the `plan.md` file by either manually editing it or repeatedly fine tuning the prompt used with `/speckit.plan`, or leveraging `/speckit.checklist` to review/validate and challenge the plan.

**The plan typically includes:**

- Selected technical stack & components
- Architecture diagram or description
- Component-level (resource-level) breakdown
- API/data contracts (if any)
- Integration points
- Deployment structure
- Region & SKU validation
- Required research (limitations, assumptions)

Following our [scenario](#example-scenario), here are some examples for what the prompt used to generate the plan should include:

1. **Chosen Technologies**
    - AVM Bicep modules

2. **Architecture**
    - Hub/spoke or simple VNet depending on environment.
    - Subnet for VM with NSG enforcing inbound/outbound rules.
    - Azure Bastion for private admin access.
    - VM uses Managed Identity for Key Vault + Storage access.

3. **Research (automatically generated)**
    - Supported Windows Server SKUs in chosen region.
    - VM extension support for custom script on Windows.
    - Whether AVM module supports automatic patching, monitoring, identity binding.

4. **Data Inputs & Contracts**
    - Parameters JSON structure for:
      - VM name, SKU
      - Admin username
      - Key Vault secret names
      - App package URI

5. **Project Structure**
    - File and folder structure:
        ```markdown
        main.bicep
        main.bicepparam
        readme.md
        ```

6. **Quickstart**
    - How to implement/deploy: Steps to deploy via Azure CLI, Bicep CLI, PowerShell or GitHub Actions.

### 5. Checklist (Optional)

The checklist step ensures that all required criteria from the Constitution, Spec, and Plan are met or properly addressed before generating tasks or implementing.

Spec Kit uses `/speckit.checklist` to generate adjustments to the `plan.md` file. The prompt doesn't require any specific inputs as it analyzes the existing plan for gaps.

### 6. Tasks

This step breaks the project work down into manageable and actionable chunks that the agent can tackle one by one. Tasks are the blueprint for coding/automation. For example, a plan can be broken down to individual phases and tasks, such as bootstrapping, test first (tests must fail before core implementation), core implementation, integration refinement, and polish/iterate.

Spec Kit uses `/speckit.tasks` to generate the `tasks.md` file. The prompt doesn't require any specific inputs as it analyzes the existing plan to break it down into actionable tasks.

**Tasks typically include:**

- Ordered, granular, developer-ready instructions, mapping to a single logical unit
- Acceptance criteria per task
- Notes for dependencies between tasks

Following our [scenario](#example-scenario), here are some examples for what the prompt used to generate the tasks should include:

1. **Solution Template Creation Tasks**
    - Create base Bicep structure for the template.
    - Reference the AVM VNet module with parameterized address space.
    - Reference the AVM Subnet module and associate NSG.
    - Reference the AVM NSG module with rules (deny all inbound except required).
    - Reference the AVM VM module with parameters for:
      - VM size
      - OS SKU
      - Managed Identity
      - Boot diagnostics settings
    - Add VM Extension for custom script to install legacy application.
2. **Security Tasks**
    - Integrate Key Vault references for secrets.
    - Apply security baseline hardening script.
3. **Observability Tasks**
    - Add Log Analytics workspace and diagnostic settings.
4. **Documentation Tasks**
    - Generate README with deployment instructions.
    - Generate sample parameter files for dev/test/prod.
5. **Testing Tasks**
    - Write validation tests using What-If and PSRule for Azure.
    - Deploy to sandbox environment for verification.

### 7. Analyze (Optional)

The analyze step runs a final check for consistency, completeness, contradictions, and coverage across all generated artifacts - specification, plan, tasks - before implementation.

Spec Kit uses `/speckit.analyze` to generate an analysis report. The prompt doesn't require any specific inputs as it analyzes the existing spec, plan and tasks to produce the report.

### 8. Implement

The implementation step is the final stage where Spec Kit executes all tasks, building the actual software solution by generating real code, scripts, documentation, tests, and supporting assets. The implementation strictly adheres to the guidelines and requirements set forth in the earlier stages (constitution, specification, plan, and tasks) to ensure consistency, quality, and alignment with the project's goals.

Spec Kit uses `/speckit.implement` to implement all defined tasks by generating all code. The prompt doesn't require any specific inputs as Spec Kit analyzes the existing plan and tasks to perform this step.

Following our [scenario](#example-scenario), here are some examples for what the output of the implementation step should include. Note that GitHub Copilot can actually deploy the generated main.bicep file to Azure, and validate whether the deployment was successful.

1. **Generated Code and Files**
    - Bicep template (e.g., main.bicep)
    - Parameter file(s) (e.g., main.bicepparam)
    - Deployment scripts (if required)
    - Any additionally required configuration files

2. **Test Artifacts**
     - Unit tests, integration tests, IaC linting results
     - What-If validation JSON
     - PSRule for Azure test configs
     - Regression tests (if in constitution)

3. **Documentation**
    - README files
    - Architecture diagrams
    - Quick-start and deployment instructions
    - Known limitations and future improvements

4. **Tooling Outputs**
    - Auto-created scaffolding (directories and files)
    - Code generation aligned to constraints

## Summary

Spec Kit transforms the traditionally ambiguous process of translating requirements into code by establishing a structured, AI-assisted workflow. By following the steps - from Constitution through Implementation - you create a clear chain of traceability where every line of code can be linked back to a specific requirement.

Key takeaways:

- **Start with principles**: The constitution ensures that non-negotiable constraints (security, compliance, architecture patterns) are embedded from the beginning.
- **Iterate on specifications**: Use the clarify step to challenge assumptions and refine requirements before committing to implementation.
- **Plan before coding**: A well-defined plan prevents costly rework and ensures alignment with AVM best practices.
- **Break down complexity**: Tasks make large projects manageable and provide clear acceptance criteria for each unit of work.
- **Validate continuously**: Use analyze and checklist steps to catch inconsistencies early in the process.

When combined with Azure Verified Modules, Spec Kit helps ensure that your infrastructure-as-code solutions are not only functional but also secure, maintainable, and aligned with Azure best practices.

For hands-on examples of using Spec Kit with AVM, see the [Bicep Example]({{% siteparam base %}}/experimental/ai-assisted-sol-dev/bicep) guide.
