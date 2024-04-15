---
title: Module Support
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

As mentioned in the [What, Why, How](/Azure-Verified-Modules/concepts/what-why-how) page, we understand that long-term support from Microsoft in an initiative like AVM is critical to its adoption by consumers and therefore the success of AVM. Therefore we have aligned and provide the below support statement/process for AVM modules.

{{< hint type=important >}}

Issues with an AVM module should be raised on the repo they are hosted on, not the AVM Central (`Azure/Azure-Verified-Modules`) repo!

*Not an issue if you raise in the wrong place, we will transfer it to it's correct home 👍*

{{< /hint >}}

<br>

Azure Verified Modules are supported by the AVM teams, as defined [here](/Azure-Verified-Modules/specs/shared/team-definitions/), using GitHub issues in the following order of precedence:

1. Module owners/contributors
2. If there is no response within 3 business days, then the AVM core team will step in by:
    - First attempting to contact the module owners/contributors to prompt them to act.
    - If there is no response within a further 24 hours (on business days), the AVM core team will take ownership, triage, and provide a response within a further 2 business days.
3. In the event of a security issue being unaddressed after 5 business days, escalation to the product group (Bicep/Terraform) to assist the AVM core team, will occur to provide additional support towards resolution; if required.

{{< hint type=note >}}

Please note that the durations stated above are for a reasonable and useful response towards resolution of the issue raised, if possible, and **not** for a fix within these durations; although if possible this will of course happen.

{{< /hint >}}

<br>

All of this will be automated via the use of the Resource Management feature of the [Microsoft GitHub Policy Service](https://github.com/apps/microsoft-github-policy-service) and GitHub Actions, where possible and appropriate.

Modules that have to have the AVM core team or Product Groups step in due to the module owners/contributors not responding, the AVM module will become "orphaned"; see [Module Lifecycle](/Azure-Verified-Modules/specs/shared/module-lifecycle/) for more info.

{{< hint type=important >}}

You can also raise a ticket with Microsoft CSS (Microsoft Customer Services & Support) and your ticket will be triaged by them for any platform issues and if deemed not the platform but a module issue, it will be redirected to the AVM team and the module owner(s).

{{< /hint >}}
