---
title: Module Support
description: Module Support for the Azure Verified Modules (AVM) program
---

As mentioned on the [Introduction]({{% siteparam base %}}/overview/introduction) page, we understand that long-term support from Microsoft in an initiative like AVM is critical to its adoption by consumers and therefore the success of AVM. Therefore we have aligned and provide the below support statement/process for AVM modules.

## Support Mechanism

Azure Verified Modules are supported by the AVM teams, as defined [here]({{% siteparam base %}}/specs/shared/team-definitions/), using GitHub issues in the following order of precedence:

1. Module owners/contributors
2. If there is no response within 3 business days, then the AVM core team will step in by:
    - First attempting to contact the module owners/contributors to prompt them to act.
    - If there is no response within a further 24 hours (on business days), the AVM core team will take ownership, triage, and provide a response within a further 2 business days.
3. In the event of a security issue being unaddressed after 5 business days, escalation to the product group (Bicep/Terraform) to assist the AVM core team, will occur to provide additional support towards resolution; if required.

All of this will be automated via the use of the Resource Management feature of the [Microsoft GitHub Policy Service](https://github.com/apps/microsoft-github-policy-service) and GitHub Actions, where possible and appropriate.

{{% notice style="note" %}}

Please note that the durations stated above are for a reasonable and useful response towards resolution of the issue raised, if possible, and **not** for a fix within these durations; although if possible this will of course happen.

{{% /notice %}}

{{% notice style="important" %}}

Issues with an AVM module should be raised on the repo they are hosted on, not the AVM Central (`Azure/Azure-Verified-Modules`) repo!

*Not an issue if you raise in the wrong place, we will transfer it to it's correct home 👍*

{{% /notice %}}

{{% notice style="important" %}}

Issues that are likely related to an AVM module should be directly submitted on the module's GitHub repository as an "*AVM - Module Issue*". To identify the correct code repository, see the AVM [module indexes]({{% siteparam base %}}/indexes).

If an issue is likely related to the Azure platform, its APIs or configuration, script or programming languages, etc., you need to raise a ticket with Microsoft CSS (Microsoft Customer Services & Support) where your ticket will be triaged for any platform issues. If deemed a platform issue, the ticket will be addressed accordingly. In case it's deemed not a platform but a module issue, you will be redirected to submit a module issue on GitHub.

{{% /notice %}}

## Orphaned Modules

Modules that have to have the AVM core team or Product Groups step in due to the module owners/contributors not responding, the AVM module will become "orphaned"; see [Module Lifecycle]({{% siteparam base %}}/specs/shared/module-lifecycle/) for more info.

{{% notice style="info" %}}

If a module is orphaned, the AVM team will try to find a new owner by:

1. Listing [orphaned modules](https://aka.ms/AVM/OrphanedModules) in a saved GitHub issue query on the [AVM module index](https://aka.ms/AVM/ModuleIndex) pages for potential new owners to pick up.
2. In more urgent or high priority cases, selectively identifying a new module owner from the pool of existing AVM module owners/contributors to take over the module.

**To raise attention to an orphaned module and allow the AVM team to better prioritize actions, customers can leave a comment on the "orphaned module" issue, explaining their use case and why they would like to see the module supported.** This will help the AVM team to prioritize the module for a new owner.

{{% /notice %}}
