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
3. In the event of a security issue being unresolved after 5 days, escalation to the product group (Bicep/Terraform) to assist the AVM core team, will occur to provide additional support towards resolution; if required.

{{< hint type=note >}}

Please note that the durations stated above are for a reasonable and useful response towards resolution of the issue raised, if possible, and **not** for a fix within these durations; although if possible this will of course happen.

{{< /hint >}}

<br>

All of this will be automated via the use of the [Resource Management GitHub Policy Service](https://microsoft.github.io/GitOps/policies/resource-management.html) configuration and GitHub Actions, where possible and appropriate.

Modules that have to have the AVM core team or Product Groups step in due to the module owners/contributors not responding, the AVM module will become "orphaned"; see [Module Lifecycle](/Azure-Verified-Modules/specs/shared/module-lifecycle/) for more info.

{{< hint type=important >}}

We are also working with Microsoft CSS (Microsoft Customer Services & Support) to onboard AVM into their support so they can take and triage support calls/tickets for AVM via the normal Azure support ticket route.

{{< /hint >}}

## Issue/triage Automation

- [x] ITA01TF.1-5 - If a bug/feature/request/general question is not responded to after 3 business days, then the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.
- [x] ITA01BCP.1-5 - If a bug/feature/request/general question that has the label of "Type: AVM 🅰️ ✌️ ⓜ️" is not responded to after 3 business days, then the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.
- [x] ITA02BCP.1-5 - If after an additional 3 business days there's still no update to the issue that has the label of "Type: AVM 🅰️ ✌️ ⓜ️", the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive.
- [x] ITA02TF.1-5 - If after an additional 3 business days there's still no update to the issue, the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive.
- [ ] ITA03 - If a security issue not responded to after 3 business days, then the AVM Core team will be tagged in a comment on the issue to nudge the module owner
- [ ] ITA04 - If after a further 3 business days and no update to the issue the AVM core team will be assigned to the issue and a further comment stating module owner MIA
- [ ] ITA05 - If after 5 days (total from start of issue being raised) and no response the respective PGs GitHub Team will be tagged and assigned to the issue to assist
- [x] ITA06 - If an issue/PR has been labelled with "Needs: Author Feedback 👂" and hasn't had a response in 4 days, label with "Status: No Recent Activity 💤" and add a comment
- When a reply from anyone to an issue occurs, remove the "Needs: Author Feedback 👂" label and label with "Needs: Attention 👋"
- [x] ITA07 - If an issue/PR has been labelled with "Status: No Recent Activity 💤" and hasn't had any update in 3 days from that point, automatically close it and comment
- [ ] ITA08 - If a issue/PR has a "Status: long-term ⏳" do not auto close it, regardless
- [x] ITA09 - When a new issue of any type is created add the "Needs: Triage 🔍" label.
- [x] ITA10 - When a new PR of any type is created add the "Needs: Triage 🔍" label.
- [ ] ITA11BCP - If AVM or "Azure Verified Modules" is mentioned in an uncategorized issue (i.e., one not using any template), apply the label of "Type: AVM 🅰️ ✌️ ⓜ️" on the issue.

| ID          | AVM Core repo | BRM repo | TF repos |
|-------------|:-------------:|:--------:|:--------:|
| ITA01BCP1-5 |               |    x     |          |
| ITA01TF1-5  |               |          |    x     |
| ITA02BCP1-5 |               |    x     |          |
| ITA02TF1-5  |               |          |    x     |
| ITA03       |               |          |          |
| ITA04       |               |          |          |
| ITA05       |               |          |          |
| ITA06       |       x       |    x     |    x     |
| ITA07       |       x       |    x     |    x     |
| ITA08       |               |          |          |
| ITA09       |               |          |          |
| ITA10       |       x       |    x     |    x     |
