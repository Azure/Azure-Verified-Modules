---
title: Solution Development
linktitle: Solution Development
type: default
weight: 4
description: Advanced Solution Development guidance for the Azure Verified Modules (AVM) program. It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

## Considerations and steps of Solution Development

- Decide on the IaC language (Bicep or Terraform)
- Decide on the module sourcing method (public registry, private registry, inner-sourcing)
- Decide on the orchestration method (template or pipeline)
- Identify the resources needed for the solution (are they all available in AVM?)
- Implement, validate, deploy, test the solution

## Questions to cover on this page

- Pick a realistically complex solution and demonstrate how to build it using AVM modules
- Best practices for coding (link to official language specific guidance AND AVM specs where/if applicable)
- Best practices for input and output parameters

## Next steps

**To be covered in separate, future articles.**

To make this solution enterprise-ready, you need to consider the following:

- Deploy with DevOps tools and practices (e.g., CI/CD in Azure DevOps, GitHub Actions, etc.)
- Deploy into Azure Landing Zones (ALZ)
- Make sure the solution follows the recommendations of the Well-Architected Framework (WAF) and it's compliant with and integrates into your organization's policies and standards, e.g.:
  - Security & Identity (e.g., RBAC, Entra ID, service principals, secrets management, MFA, etc.)
  - Networking (e.g., Azure Firewall, NSGs, etc.)
  - Monitoring (e.g., Azure Monitor, Log Analytics, etc.)
  - Cost management (e.g., Azure Cost Management, budgets, etc.)
  - Governance (e.g., Azure Policy, etc.)

## Other recommendations

- Don't use latest, but a specific version of the module
- Don't expose secrets in output parameters/command line/logs/etc.
- Don't use hard-coded values, but use parameters and variables
