---
title: Module Support
description: Module Support for the Azure Verified Modules (AVM) program
---

{{% notice style="important" title="AVM is now owned by Azure engineering" %}}

On **13 October 2026**, AVM moved into the Azure Deployments team within Microsoft's Azure engineering organization.

This move adds dedicated engineering resources to AVM. It also replaces the previous day-based response targets with the support model described below.

For more information, read [Azure Verified Modules (AVM) is now owned by Azure engineering](https://techcommunity.microsoft.com/blog/azuretoolsblog/azure-verified-modules-avm-is-now-owned-by-azure-engineering/4563822).

{{% /notice %}}

AVM is an open-source Microsoft project with dedicated engineers and distributed module ownership. The AVM Core Team maintains modules directly and improves the shared specifications, tooling, automation, and framework. For who owns which modules, see [Module Ownership Tiers]({{% siteparam base %}}/specs/shared/module-ownership-tiers/).

## Support Statement

AVM follows the support model used by Azure CLI, Azure PowerShell, Bicep, AzAPI, and the AzureRM Terraform provider.

- Report module bugs and feature requests in the module's GitHub repository.
- AVM does not provide fixed response or resolution targets for GitHub issues.

Dedicated engineers maintain modules and improve the framework used by all module owners. This commitment replaces the previous day-based targets, which AVM could not meet consistently.

### Security vulnerabilities

Do not report security vulnerabilities through public GitHub issues. Report them privately to the [Microsoft Security Response Center](https://aka.ms/opensource/security/create-report), as described in the [repository security policy](https://github.com/Azure/Azure-Verified-Modules/security/policy).

{{% notice style="caution" title="AVM is Open-Source" %}}

AVM is open-source, therefore, contributions are welcome via Pull Requests or comments in Issues from anyone in the world at any time on any Pull Request or Issues to assist AVM module owners 🌐

Review the [contribution guidance]({{% siteparam base %}}/contributing) to get involved!

{{% /notice %}}

{{% notice style="tip" %}}

Issues that are likely related to an AVM module should be directly submitted on the module's GitHub repository as an "*AVM - Module Issue*". To identify the correct code repository, see the AVM [module indexes]({{% siteparam base %}}/indexes).

If an issue is likely related to the Azure platform, its APIs or configuration, script or programming languages, etc., you need to [raise a ticket with Microsoft CSS (Microsoft Customer Services & Support)](https://azure.microsoft.com/support/create-ticket) where your ticket will be triaged for any platform issues. If deemed a platform issue, the ticket will be addressed accordingly. In case it's deemed not a platform but a module issue, you will be redirected to submit a module issue on GitHub.

{{% /notice %}}

---

## Orphaned Modules

A module becomes orphaned when it has no active module owner. See [Module Lifecycle]({{% siteparam base %}}/specs/shared/module-lifecycle/) for more information.

{{% notice style="info" %}}

If a module is orphaned, the AVM Core Team will provide essential maintenance and try to find a new owner by:

1. Listing [orphaned modules](https://aka.ms/AVM/OrphanedModules) in a saved GitHub issue query on the [AVM module index](https://aka.ms/AVM/ModuleIndex) pages for potential new owners to pick up.
2. In more urgent or high priority cases, selectively identifying a new module owner from the pool of existing AVM module owners/contributors to take over the module.

**To raise attention to an orphaned module and allow the AVM team to better prioritize actions, customers can leave a comment on the "orphaned module" issue, explaining their use case and why they would like to see the module supported.** This will help the AVM team to prioritize the module for a new owner.

{{% /notice %}}
