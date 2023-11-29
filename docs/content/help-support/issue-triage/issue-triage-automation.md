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

### ITA01BCP.1-2

If a bug/feature/request/general question that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" and "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" is not responded to after 3 business days, then the issue will be marked with the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label and the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.

### ITA01TF.1-2

If a bug/feature/request/general question that has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label assigned is not responded to after 3 business days, then the issue will be marked with the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label and the AVM Core team will be tagged in a comment on the issue to reach out to the module owner. The AVM core team will also be assigned on the issue.

### ITA02BCP.1-2

If after an additional 3 business days there's still no update to the issue that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be assigned.

### ITA02TF.1-2

If after an additional 3 business days there's still no update to the issue that has the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label assigned, the AVM core team will be assigned to the issue and a further comment stating module owner is unresponsive. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be assigned.

### ITA03BCP

If there's still no response after 5 days (total from start of issue being raised) on an issue that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>", "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the Bicep PG GitHub Team will be tagged and assigned to the issue to assist. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be assigned.

### ITA03TF

If there's still no response after 5 days (total from start of issue being raised) on an issue that has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the Terraform PG GitHub Team will be tagged and assigned to the issue to assist. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be assigned.

### ITA04

If an issue/PR has been labelled with "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" and hasn't had a response in 4 days, label with "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" and add a comment.

### ITA05

If an issue/PR has been labelled with "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" and hasn't had any update in 3 days from that point, automatically close it and comment, unless the issue/PR has a "<mark style="background-color:#B60205;color:white;">Status: long-term ⏳</mark>" - in which case, do not close it.

### ITA24

Remind module owner(s) to start or continue working on this module if there was no activity on the Module Proposal issue for more than 3 weeks. Add "<mark style="background-color:#E99695;">Needs: Attention 👋</mark>" label.

<br>

## Event based automation

This chapter details all automation rules that are based on an event.

### ITA06

When a new issue or PR of any type is created add the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.

### ITA08BCP

If AVM or "Azure Verified Modules" is mentioned in an uncategorized issue (i.e., one not using any template), apply the label of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" on the issue.

### ITA09

When #RR is used in an issue, add the label of "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>".

### ITA10

When #wontfix is used in an issue, mark it by using the label of "<mark style="background-color:#FFFFFF;">Status: Won't Fix 💔</mark>" and close it as not planned.

### ITA11

When a reply from anyone to an issue occurs, remove the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" label and label with "<mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark>".

### ITA12

Clean up e-mail replies to GitHub Issues for readability.

### ITA13

If the language is set to Bicep in the Module proposal, assign the "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" label on the issue.

### ITA14

If the language is set to Terraform in the Module proposal, assign the "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>" label on the issue.

### ITA15

Remove the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label from a PR, if it already has a "<mark>Type: *XYZ*</mark>" label assigned at the time of creating it.

### ITA16

Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label when someone is assigned to a Module Proposal.

### ITA17

If the issue author says they want to be the module owner, assign the issue to the author and respond to them.

```markdown
@${issueAuthor}, thanks for volunteering to be a module owner!

**Please don't start the development just yet!**

The AVM core team will review this module proposal and respond to you first. Thank you!
```

### ITA18

Send automatic response to the issue author if they don't want to be module owner and don't have any candidate in mind. Assign the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label.

```markdown
@${issueAuthor}, thanks for submitting this module proposal!
The AVM core team will review it and will try to find a module owner.
```

### ITA19

Send automatic response to the issue author if they don't want to be module owner but have a candidate in mind. Assign the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label.

```markdown
@${issueAuthor}, thanks for submitting this module proposal with a module owner in mind!

**Please don't start the development just yet!**

The AVM core team will review this module proposal and respond to you and/or the module owner first. Thank you!
```

### ITA20

If the issue type is feature request, assign the "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>" label on the issue.

### ITA21

If the issue type is bug, assign the "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>" label on the issue.

### ITA22

If the issue type is security bug, assign the "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" label on the issue.

### ITA23

Remove the "<mark style="background-color:#EDEDED;">Status: In PR 👉</mark>" label from an issue when it's closed.

<br>

## Where to apply these rules?

The below table details which repositories the above rules are applied to.

| ID                          | AVM Core repository | BRM repository | TF repositories |
|-----------------------------|:-------------------:|:--------------:|:---------------:|
| [ITA01BCP1-2](#ita01bcp1-2) |                     |       ✔️       |                 |
| [ITA01TF1-2](#ita01tf1-2)   |                     |                |       ✔️        |
| [ITA02BCP1-2](#ita02bcp1-2) |                     |       ✔️       |                 |
| [ITA02TF1-2](#ita02tf1-2)   |                     |                |       ✔️        |
| [ITA03BCP](#ita03bcp)       |                     |       ✔️       |                 |
| [ITA03TF](#ita03tf)         |                     |                |       ✔️        |
| [ITA04](#ita04)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA05](#ita05)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA06](#ita06)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA08BCP](#ita08bcp)       |                     |       ✔️       |                 |
| [ITA09](#ita09)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA10](#ita10)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA11](#ita11)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA12](#ita12)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA13](#ita13)             |         ✔️          |                |                 |
| [ITA14](#ita14)             |         ✔️          |                |                 |
| [ITA15](#ita15)             |         ✔️          |       ✔️       |       ✔️        |
| [ITA16](#ita16)             |         ✔️          |                |                 |
| [ITA17](#ita17)             |         ✔️          |                |                 |
| [ITA18](#ita18)             |         ✔️          |                |                 |
| [ITA19](#ita19)             |         ✔️          |                |                 |
| [ITA20](#ita20)             |                     |       ✔️       |                 |
| [ITA21](#ita21)             |                     |       ✔️       |                 |
| [ITA22](#ita22)             |                     |       ✔️       |                 |
| [ITA23](#ita23)             |          ✔️         |                |                 |
| [ITA24](#ita24)             |          ✔️         |                |                 |
