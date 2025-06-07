---
title: Module Support
description: Module Support for the Azure Verified Modules (AVM) program
---

{{% notice style="warning" title="Recent Changes to Support Statements" %}}

The AVM support statements and targets have been updated as of **June 2025**. To understand the changes, please review the below updates on this page.

For more information and reasoning behind the changes, please refer to the blog post we published on this topic: [Tech Community: Azure Verified Modules: Support Statement & Target Response Times Update](https://techcommunity.microsoft.com/blog/azuretoolsblog/azure-verified-modules-support-statement--target-response-times-update/4421489)

{{% /notice %}}

As mentioned on the [Introduction]({{% siteparam base %}}/overview/introduction) page, we understand that long-term support from Microsoft in an initiative like AVM is critical to its adoption by consumers and therefore the success of AVM. Therefore we have aligned and provide the below support statement/process for AVM modules:

## Support Statements

{{% notice style="info" %}}

Module owners do go on holiday or have periods of leave from time to time, during these times the AVM core team will attempt to triage issues based on the below on behalf of module owners. 👍

{{% /notice %}}

### For bugs/security issues

- 5 business days for a triage, meaningful response, and ETA to be provided for fix/resolution by module owner (which could be past the 5 days)
  - For issues that breach the 5 business days, the AVM core team will be notified and will attempt to respond to the issue within an additional 5 business days to assist in triage.
  - For security issues, the Bicep or Terraform Product Groups may step in to resolve security issues, if unresolved, after a further additional 5 business days.

### For feature requests

- 15 business days for a meaningful response and initial triage to understand the feature request. An ETA may be provided by the module owner if possible.

{{% notice style="caution" title="AVM is Open-Source" %}}

AVM is open-source, therefore, contributions are welcome via Pull Requests or comments in Issues from anyone in the world at any time on any Pull Request or Issues to assist AVM module owners 🌐

Review the [contribution guidance]({{% siteparam base %}}/contributing) to get involved!

{{% /notice %}}

{{% notice style="info" %}}

All of this will be automated via the use of the Resource Management feature of the [Microsoft GitHub Policy Service](https://github.com/apps/microsoft-github-policy-service) and GitHub Actions, where possible and appropriate.

{{% /notice %}}

{{% notice style="note" %}}

Please note that the durations stated above are for a reasonable and useful response towards resolution of the issue raised, if possible, and **not** for a fix within these durations; although if possible this will of course happen.

{{% /notice %}}

{{% notice style="tip" %}}

Issues that are likely related to an AVM module should be directly submitted on the module's GitHub repository as an "*AVM - Module Issue*". To identify the correct code repository, see the AVM [module indexes]({{% siteparam base %}}/indexes).

If an issue is likely related to the Azure platform, its APIs or configuration, script or programming languages, etc., you need to [raise a ticket with Microsoft CSS (Microsoft Customer Services & Support)](https://azure.microsoft.com/support/create-ticket) where your ticket will be triaged for any platform issues. If deemed a platform issue, the ticket will be addressed accordingly. In case it's deemed not a platform but a module issue, you will be redirected to submit a module issue on GitHub.

{{% /notice %}}

---

## Orphaned Modules

Modules that have to have the AVM core team or Product Groups step in due to the module owners/contributors not responding, the AVM module will become "orphaned"; see [Module Lifecycle]({{% siteparam base %}}/specs/shared/module-lifecycle/) for more info.

{{% notice style="info" %}}

If a module is orphaned, the AVM team will try to find a new owner by:

1. Listing [orphaned modules](https://aka.ms/AVM/OrphanedModules) in a saved GitHub issue query on the [AVM module index](https://aka.ms/AVM/ModuleIndex) pages for potential new owners to pick up.
2. In more urgent or high priority cases, selectively identifying a new module owner from the pool of existing AVM module owners/contributors to take over the module.

**To raise attention to an orphaned module and allow the AVM team to better prioritize actions, customers can leave a comment on the "orphaned module" issue, explaining their use case and why they would like to see the module supported.** This will help the AVM team to prioritize the module for a new owner.

{{% /notice %}}
