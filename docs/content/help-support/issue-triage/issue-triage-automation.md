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

If a bug/feature/request/general question that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" and "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" is not responded to after 3 business days, then the issue will be marked with the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label and the AVM Core team will be mentioned in a comment on the issue to reach out to the module owner.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 3 business days.
- Has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" labels added.

**Action(s):**

- Add a reply, mentioning the `Azure/avm-core-team-technical-bicep` team.
- Add the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label.

{{< hint type=tip >}}
- To prevent further actions to take effect, the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label must be removed, once this issue has been responded to.
- To avoid this rule being (re)triggered, the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" must be removed as part of the triage process (when the issue is first responded to).
{{< /hint >}}

---

### ITA01TF.1-2

If a bug/feature/request/general question that has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label added is not responded to after 3 business days, then the issue will be marked with the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label and the AVM Core team will be mentioned in a comment on the issue to reach out to the module owner.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 3 business days.
- Has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label added.

**Action(s):**

- Add a reply, mentioning the `Azure/avm-core-team-technical-bicep` team.
- Add the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label.

{{< hint type=tip >}}
- To prevent further actions to take effect, the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label must be removed, once this issue has been responded to.
- To avoid this rule being (re)triggered, the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" must be removed as part of the triage process (when the issue is first responded to).
{{< /hint >}}

---

### ITA02BCP.1-2

If after an additional 3 business days there's still no update to the issue that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the AVM core team will be mentioned on the issue and a further comment stating module owner is unresponsive will be added. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be added.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 3 business days.
- Has the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" labels added.

**Action(s):**

- Add a reply, mentioning the `Azure/avm-core-team-technical-bicep` team.
- Add the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label.

{{< hint type=tip >}}
- To avoid this rule being (re)triggered, the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" labels must be removed when the issue is first responded to!
- Remove the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label once the issue has been responded to.
{{< /hint >}}

---

### ITA02TF.1-2

If after an additional 3 business days there's still no update to the issue that has the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label added, the AVM core team will be mentioned on the issue and a further comment stating module owner is unresponsive will be added. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be added.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 3 business days.
- Has the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" label added.

**Action(s):**

- Add a reply, mentioning the `Azure/avm-core-team-technical-bicep` team.
- Add the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label.

{{< hint type=tip >}}
- To avoid this rule being (re)triggered, the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" labels must be removed when the issue is first responded to!
- Remove the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label once the issue has been responded to.
{{< /hint >}}

---

### ITA03BCP

If there's still no response after 5 days (total from start of issue being raised) on an issue that has the labels of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>", "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the Bicep PG GitHub Team will be mentioned on the issue to assist. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be added.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 5 business days.
- Has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", the "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>", the "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>",  and "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" labels added.

**Action(s):**

- Add a reply, mentioning the `Azure/bicep-admins` team.
- Add the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label.

{{< hint type=tip >}}
- To avoid this rule being (re)triggered, the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" labels must be removed when the issue is first responded to!
- Remove the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label once the issue has been responded to.
{{< /hint >}}

---

### ITA03TF

If there's still no response after 5 days (total from start of issue being raised) on an issue that has the labels of "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>", the Terraform PG GitHub Team will be mentioned on the issue to assist. The "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label will also be added.

**Schedule:**

- Triggered every Monday-Friday, at 12:00.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 5 business days.
- Has the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>", the "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>", and "<mark style="background-color:#850000;color:white;">Status: Response Overdue 🚩</mark>" labels added.

**Action(s):**

- Add a reply, mentioning the `Azure/terraform-avm` team.
- Add the "<mark style="background-color:#FF0000;color:white;">Needs: Immediate Attention ‼️</mark>" label.

---

### ITA04

If an issue/PR has been labelled with "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" and hasn't had a response in 4 days, label with "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" and add a comment.

**Schedule:**

- Triggered every 3 hours.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 4 days.
- Has the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" label added.
- Does not have the "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" label added.

**Action(s):**

- Add the "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" label.
- Add a reply.

{{< hint type=tip >}}
To prevent further actions to take effect, one of the following conditions must be met:

- The author must respond in a comment within 3 days of the automatic comment left on the issue.
- The "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" label must be removed.
- If applicable, the "<mark style="background-color:#B60205;color:white;">Status: Long Term ⏳</mark>" or the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label must be added.
{{< /hint >}}

---

### ITA05

If an issue/PR has been labelled with "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" and hasn't had any update in 3 days from that point, automatically close it and comment, unless the issue/PR has a "<mark style="background-color:#B60205;color:white;">Status: Long Term ⏳</mark>" - in which case, do not close it.

**Schedule:**

- Triggered every 3 hours.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 3 days.
- Has the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" and the "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" labels added.
- Does not have the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" or "<mark style="background-color:#B60205;color:white;">Status: Long Term ⏳</mark>" labels added.

**Action(s):**

- Add a reply.
- Close the issue.

{{< hint type=tip >}}
- In case the issue needs to be reopened (e.g., the author responds after the issue was closed), the "<mark style="background-color:#808080;color:white;">Status: No Recent Activity 💤</mark>" label must be removed.
{{< /hint >}}

---

### ITA24

Remind module owner(s) to start or continue working on this module if there was no activity on the Module Proposal issue for more than 3 weeks. Add "<mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark>" label.

**Schedule:**

- Triggered every 3 hours.

**Trigger criteria:**

- Is an open issue.
- Had no activity in the last 21 days.
- Has the "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>" and the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" labels added.
- Does not have the "<mark style="background-color:#B60205;color:white;">Status: Long Term ⏳</mark>" label added.

**Action(s):**

- Add a reply.
- Add the "<mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark>" label.

{{< hint type=tip >}}
- To silence this notification, provide an update every 3 weeks on the Module Proposal issue, or add the "<mark style="background-color:#B60205;color:white;">Status: Long Term ⏳</mark>" label.
{{< /hint >}}

---

<br>

## Event based automation

This chapter details all automation rules that are based on an event.

### ITA06

When a new issue or PR of any type is created add the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.

**Trigger criteria:**

- An issue or PR is opened.

**Action(s):**

- Add the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.
- Add a reply to explain the action(s).

---

### ITA08BCP

If AVM or "Azure Verified Modules" is mentioned in an uncategorized issue (i.e., one not using any template), apply the label of "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" on the issue.

**Trigger criteria:**

- An issue, issue comment, PR, or PR comment is opened, created or edited and the body or comment contains the strings of "AVM" or "Azure Verified Modules".

**Action(s):**

- Add the "<mark style="background-color:#F0FFFF;">Type: AVM 🅰️ ✌️ ⓜ️</mark>" label.

---

### ITA09

When #RR is used in an issue, add the label of "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>".

**Trigger criteria:**

- An issue comment or PR comment contains the string of "#RR".

**Action(s):**

- Add the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" label.

---

### ITA10

When #wontfix is used in an issue, mark it by using the label of "<mark style="background-color:#FFFFFF;">Status: Won't Fix 💔</mark>" and close the issue.

**Trigger criteria:**

- An issue comment or PR comment contains the string of "#RR".

**Action(s):**

- Add the "<mark style="background-color:#FFFFFF;">Status: Won't Fix 💔</mark>" label.
- Close the issue.

---

### ITA11

When a reply from anyone to an issue occurs, remove the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" label and label with "<mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark>".

**Trigger criteria:**

- Any action on an issue comment or PR comment except closing.
- Has the "<mark style="background-color:#CB6BA2;color:white;">Needs: Author Feedback 👂</mark>" label added.

**Action(s):**

- Add the "<mark style="background-color:#E99695;color:white;">Needs: Attention 👋</mark>" label.

---

### ITA12

Clean up e-mail replies to GitHub Issues for readability.

**Trigger criteria:**

- Any action on an issue comment.

**Action(s):**

- Clean email reply. This is useful when someone directly responds to an email notification from GitHub, and the email signature is included in the comment.

---

### ITA13

If the language is set to Bicep in the Module proposal, add the "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" label on the issue.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

```markdown
### Bicep or Terraform?

Bicep
```

**Action(s):**

- Add the "<mark style="background-color:#1D73B3;color:white;">Language: Bicep 💪</mark>" label.

---

### ITA14

If the language is set to Terraform in the Module proposal, add the "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>" label on the issue.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

```markdown
### Bicep or Terraform?

Terraform
```

**Action(s):**

- Add the "<mark style="background-color:#7740B6;color:white;">Language: Terraform 🌐</mark>" label.

---

### ITA15

Remove the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label from a PR, if it already has a "<mark>Type: *XYZ*</mark>" label added and is assigned to someone at the time of creating it.

**Trigger criteria:**

- A PR is opened with any of the following labels added and is assigned to someone:
  - "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>"
  - "<mark style="background-color:#0075CA;color:white;">Type: Documentation 📄</mark>"
  - "<mark style="background-color:#CFD3D7;">Type: Duplicate 🤲</mark>"
  - "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>"
  - "<mark style="background-color:#17016A;color:white;">Type: Hygiene 🧹</mark>"
  - "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>"
  - "<mark style="background-color:#CB6BA2;color:white;">Type: Question/Feedback 🙋‍♀️</mark>"
  - "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>"

**Action(s):**

- Remove the "<mark style="background-color:#FBCA04;">Needs: Triage 🔍</mark>" label.

---

### ITA16

Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label when someone is assigned to a Module Proposal.

**Trigger criteria:**

- Any action on an issue except closing.
- Has the "<mark style="background-color:#ADD8E6;">Type: New Module Proposal 💡</mark>" added.
- The issue is assigned to someone.

**Action(s):**

- Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label.

---

### ITA17

If the issue author says they want to be the module owner, assign the issue to the author and respond to them.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

  ```markdown
  ### Do you want to be the owner of this module?

  Yes
  ```

**Action(s):**

- Assign the issue to the author.
- Add the below reply and explain the action(s).

  ```markdown
  @${issueAuthor}, thanks for volunteering to be a module owner!

  **Please don't start the development just yet!**

  The AVM core team will review this module proposal and respond to you first. Thank you!
  ```

---

### ITA18

Send automatic response to the issue author if they don't want to be module owner and don't have any candidate in mind. Add the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

  ```markdown
    ### Do you want to be the owner of this module?

    No

    ### Module Owner's GitHub Username (handle)

    _No response_
  ```

**Action(s):**

- Add the "<mark style="background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>" label.
- Add the below reply and explain the action(s).

  ```markdown
  @${issueAuthor}, thanks for submitting this module proposal!
  The AVM core team will review it and will try to find a module owner.
  ```

---

### ITA19

Send automatic response to the issue author if they don't want to be module owner but have a candidate in mind. Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern...

  ```markdown
    ### Do you want to be the owner of this module?

    No
  ```

- ...AND NOT matching the below pattern.

  ```markdown
  ### Module Owner's GitHub Username (handle)

  _No response_
  ```

**Action(s):**

- Add the "<mark style="background-color:#FBEF2A;">Status: Owners Identified 🤘</mark>" label.
- Add the below reply and explain the action(s).

  ```markdown
  @${issueAuthor}, thanks for submitting this module proposal with a module owner in mind!

  **Please don't start the development just yet!**

  The AVM core team will review this module proposal and respond to you and/or the module owner first. Thank you!
  ```

---

### ITA20

If the issue type is feature request, add the "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>" label on the issue.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

  ```markdown
  ### Issue Type?

  Feature Request
  ```

**Action(s):**

- Add the "<mark style="background-color:#A2EEEF;">Type: Feature Request ➕</mark>" label.

---

### ITA21

If the issue type is bug, add the "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>" label on the issue.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

  ```markdown
  ### Issue Type?

  Bug
  ```

**Action(s):**

- Add the "<mark style="background-color:#D73A4A;color:white;">Type: Bug 🐛</mark>" label.

---

### ITA22

If the issue type is security bug, add the "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" label on the issue.

**Trigger criteria:**

- An issue is opened with its body matching the below pattern.

  ```markdown
  ### Issue Type?

  Security Bug
  ```

**Action(s):**

- Add the "<mark style="background-color:#FFFF00;">Type: Security Bug 🔒</mark>" label.

---

### ITA23

Remove the "<mark style="background-color:#EDEDED;">Status: In PR 👉</mark>" label from an issue when it's closed.

**Trigger criteria:**

- An issue is opened.

**Action(s):**

- Remove the "<mark style="background-color:#EDEDED;">Status: In PR 👉</mark>" label.

---

### ITA25

Inform module owners that they need to add the "<mark style="background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>" label to their PR if they're the sole owner of their module.

**Trigger criteria:**

- A PR is opened.

**Action(s):**

Inform module owners that they need to add the "<mark style="background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>" label to their PR if they're the sole owner of their module.

---

## Where to apply these rules?

The below table details which repositories the above rules are applied to.

### Rules applied for Schedule based automation

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
| [ITA24](#ita24)             |          ✔️         |                |                 |

### Rules applied for Event based automation

| ID                          | AVM Core repository | BRM repository | TF repositories |
|-----------------------------|:-------------------:|:--------------:|:---------------:|
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
| [ITA20](#ita20)             |                     |       ✔️       |        ✔️       |
| [ITA21](#ita21)             |                     |       ✔️       |        ✔️       |
| [ITA22](#ita22)             |                     |       ✔️       |        ✔️       |
| [ITA23](#ita23)             |          ✔️         |                |        ✔️       |
| [ITA25](#ita25)             |                    |        ✔️        |               |
