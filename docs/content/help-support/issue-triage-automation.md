---
title: Issue/Triage Automation
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

This page details the automation that is in place to help with the triage of issues and PRs raised against the AVM modules.

## Schedule based automation

This section details all automation rules that are based on a schedule.

{{< hint type=note >}}
When calculating the number of business days in the issue/triage automation, the built-in logic considers Monday-Friday as business days. The logic doesn't consider any holidays.
{{< /hint >}}

### ITA01TF.1-2

If a bug/feature/request/general question is not responded to after 3 business days, then the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.
### ITA01BCP.1-2

If a bug/feature/request/general question that has the label of "Type: AVM 🅰️ ✌️ ⓜ️" is not responded to after 3 business days, then the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.

### ITA02BCP.1-2

If after an additional 3 business days there's still no update to the issue that has the label of "Type: AVM 🅰️ ✌️ ⓜ️", the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive.

### ITA02TF.1-2

If after an additional 3 business days there's still no update to the issue, the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive.

### ITA03BCP

If after 5 days (total from start of issue being raised) and no response the Bicep PG GitHub Team will be tagged and assigned to the issue to assist

### ITA03TF

If after 5 days (total from start of issue being raised) and no response the Terraform PG GitHub Team will be tagged and assigned to the issue to assist

### ITA04

If an issue/PR has been labelled with "Needs: Author Feedback 👂" and hasn't had a response in 4 days, label with "Status: No Recent Activity 💤" and add a comment

### ITA05

If an issue/PR has been labelled with "Status: No Recent Activity 💤" and hasn't had any update in 3 days from that point, automatically close it and comment, unless the issue/PR has a "Status: long-term ⏳" - in which case, do not close it.

<br>

## Event based automation

This chapter details all automation rules that are based on an event.

### ITA06

When a new issue of any type is created add the "Needs: Triage 🔍" label.

### ITA07

When a new PR of any type is created add the "Needs: Triage 🔍" label.

### ITA08BCP

If AVM or "Azure Verified Modules" is mentioned in an uncategorized issue (i.e., one not using any template), apply the label of "Type: AVM 🅰️ ✌️ ⓜ️" on the issue.

### ITA09

When #RR is used in an issue, add the label of "Needs: Author Feedback 👂"

### ITA10

When #wontfix is used in an issue, mark it by using the label of "Status: Won't Fix 💔" and close it as not planned.

### ITA11

When a reply from anyone to an issue occurs, remove the "Needs: Author Feedback 👂" label and label with "Needs: Attention 👋"

### ITA12

Clean up e-mail replies to GitHub Issues for readability

<br>

## Where to apply these rules?

The below table details which repositories the above rules are applied to.

| ID                          | AVM Core repository | BRM repository | TF repositories |
| --------------------------- | :-----------------: | :------------: | :-------------: |
| [ITA01BCP1-2](#ita01bcp1-2) |                     |       ✔️        |                 |
| [ITA01TF1-2](#ita01tf1-2)   |                     |                |        ✔️        |
| [ITA02BCP1-2](#ita02bcp1-2) |                     |       ✔️        |                 |
| [ITA02TF1-2](#ita02tf1-2)   |                     |                |        ✔️        |
| [ITA03BCP](#ita03bcp)       |                     |       ✔️        |                 |
| [ITA03TF](#ita03tf)         |                     |                |        ✔️        |
| [ITA04](#ita04)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA05](#ita05)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA06](#ita06)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA07](#ita07)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA08BCP](#ita08bcp)       |                     |       ✔️        |                 |
| [ITA09](#ita09)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA10](#ita10)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA11](#ita11)             |          ✔️          |       ✔️        |        ✔️        |
| [ITA12](#ita12)             |          ✔️          |       ✔️        |        ✔️        |
