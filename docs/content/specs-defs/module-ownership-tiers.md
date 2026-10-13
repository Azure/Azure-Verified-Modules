---
title: Module Ownership Tiers
url: /specs/shared/module-ownership-tiers/
description: Planned module ownership tiers for the Azure Verified Modules (AVM) program
---

{{% notice style="important" title="Planned for early 2027" %}}

Module ownership tiers are planned, not yet in effect. AVM will confirm any ownership changes when it implements tiering in early 2027. The initial tier classifications are not yet published. Until then, the current module ownership model applies.

For more information, read [Azure Verified Modules (AVM) is now owned by Azure engineering](https://techcommunity.microsoft.com/blog/azuretoolsblog/azure-verified-modules-avm-is-now-owned-by-azure-engineering/4563822).

{{% /notice %}}

AVM plans to classify modules by who owns and maintains them. Tiers describe the owner of a module, not its quality. Every module in every tier is built to the same AVM specifications and passes the same CI checks.

## Tiers

| Tier | Owned by | What it means |
| --- | --- | --- |
| **Tier 1 (Core)** | The AVM Core Team | The AVM Core Team inside Azure engineering owns these modules directly. It maintains them alongside the AVM specifications and framework. |
| **Tier 2 (Maintained)** | Any Microsoft FTE or team | Microsoft full-time employees or teams own these modules. This includes other Azure engineering teams that own modules for their own services. This is the current ownership model. |

The announcement blog post refers to the AVM Core Team as the AVM engineering team. See [Team Definitions & RACI]({{% siteparam base %}}/specs/shared/team-definitions/) for the definition of each team.

If a module is in Tier 1, the AVM Core Team owns it in both Bicep and Terraform.

A possible Tier 3 for vetted external owners is an idea, not a commitment. AVM will not consider it before the second half of calendar year 2027.

See [Module Support]({{% siteparam base %}}/help-support/module-support/) for how to report issues with a module.
