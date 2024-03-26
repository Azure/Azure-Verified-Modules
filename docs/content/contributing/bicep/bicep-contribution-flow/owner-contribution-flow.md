---
title: Owner Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

This section describes the contribution flow for module owners who are responsible for creating and maintaining Bicep Modules.

{{< toc >}}

<br>

{{< hint type=important >}}

This contribution flow is for **Module Owners** only.

As a **Bicep Module Owner** you need to be aware of the [AVM Contribution Process Overview](https://azure.github.io/Azure-Verified-Modules/contributing/process/), [Shared Specifications](https://azure.github.io/Azure-Verified-Modules/specs/shared/) (including [Interfaces](https://azure.github.io/Azure-Verified-Modules/specs/shared/interfaces/)) and [Bicep-specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) specifications as these need to be considered during pull request reviews for the modules you own. The purpose of this **Owner Contribution Flow** is to simplify and list all activities as an owner and to help you understand your responsibilities as an owner.

{{< /hint >}}

<br>

---

<br>

### 1. Owner Activities and Responsibilities

<!-- TODO: Rephrase sections if required -->
Familiarise yourself with the responsibilities as **Module Owner** outlined in [Team Definitions & RACI](https://azure.github.io/Azure-Verified-Modules/specs/shared/team-definitions/#module-owners) and [Module Owner Responsibilities](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/#module-owner-responsibilities) in the [BRM Issue Triage](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/).

1. Create GitHub teams as outlined in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) and add respective parent teams:

Segments:

- `avm-res-<RP>-<modulename>-module-owners-bicep`
- `avm-res-<RP>-<modulename>-module-contributors-bicep`

Examples:

- `avm-res-compute-virtualmachine-module-owners-bicep` and added `avm-technical-reviewers-bicep` as parent.
- `avm-res-compute-virtualmachine-module-contributors-bicep` and added `avm-module-contributors-bicep` as parent.

If a secondary owner is required, add the secondary owner to the `avm-res-<RP>-<modulename>-module-contributors-bicep` team.

[!NOTE]
Only fulltime Microsoft employees can be added at this time.

{{< hint type=info >}}

Once the teams have been created the AVM Core Team will review the team name and parent team membership for accuracy. A notification will automatically be sent to the AVM Core Team to notify them that their review needs to be completed.

{{< /hint >}}

1. Add teams to `CODEOWNERS` file as outlined in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only).

2. Make sure your module has been tested before raising a PR. This can happen in your or in another module contributor's own environment - if any. Also, because once a PR is raised, a GitHib workflow pipeline is required to be run successfully before the PR can be merged. This is to ensure that the module is working as expected and is compliant with the AVM specifications.

3. Ensure that the module(s) you own are compliant with the AVM specifications and are working as expected. The following specifications are to be considered and where `Owner` is mentioned explicitly:

| ID | Specification
|---------------|-----------------------|
| [SFR1](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-sfr1---category-composition---preview-services) | Composition - Preview Services |
| [SNFR2](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing) | Testing - E2E Testing |
| [SNFR3](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-compliance-tests) | Testing - AVM Compliance Tests |
| [SNFR8](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr8---category-contributionsupport---module-owners-github) | Contribution/Support - Module Owner(s) GitHub |
| [SNFR11](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times) | Contribution/Support - Issues Reponse Times |
| [SNFR12](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr12---category-contributionsupport---versions-supported) | Contribution/Support - Versions Supported |
| [SNFR17](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) | Release - Semantic Versioning |
| [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) | Contribution/Support - GitHub Teams Only |
| [SNFR21](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr21---category-publishing---cross-language-collaboration) | Publishing - Cross Language Collaboration |
| [SNFR24](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr24---category-testing---testing-child-extension--interface-resources) | Testing - Testing Child, Extension & Interface Resources |
| [SNFR25](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr25---category-composition---resource-naming) | Composition - Resource Naming |
| [RMNFR3](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmnfr3---category-composition---rp-collaboration) | Composition - RP Collaboration |
| [RMFR4](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) | Composition - AVM Consistent Feature & Extension Resources Value Add |
| [RMFR7](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs) | Outputs - Minimum Required Outputs |

4. Watch Pull Request (PR) activity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository (Bicep Registry Modules repository - where all Bicep AVM modules are published) and ensure that PRs are reviewed and merged in a timely manner as outlined in [SNFR11](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times).

5. Watch AVM module issue and AVM question/feedback acitvity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository.

<br>

---

<br>

### 2. Module Handover Activities

In certain circumstances, you may find yourself unable to continue as the module owner. In such cases, it is advisable to designate a new module owner. The following steps outline this transition:

- Add the new owner's GitHub account as a "maintainer" on your modules GitHub teams.
- Remove your GitHub account from on your modules GitHub teams.

If a new module owner cannot be identified then the module will need to be "Orphaned". Please follow the step outlined [when-a-module-becomes-orphaned](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned).


<br>

---

<br>

### 3. Adopting an Orphaned Module

When adopting an orphaned module the [when-a-new-owner-is-identified](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified) steps are followed.

<br>

---

<br>

### 4. GitHub Notification Settings

As a module owner, it's important that you receive notifications when any of your AVM modules experience activity or when you or any groups you belong to are explicitly mentioned (using the @ operator). This document describes how to configure your GitHub and Email settings to ensure you receive email notifications for these types of scenarios within GitHub.

#### Enable Global GitHub Notifications

Visit the [GitHub Notifcations Settings Page](https://github.com/settings/notifications) while logged in with your GitHub account.

<img src="/Azure-Verified-Modules/img/contribution/gh_notifications_page.png" alt="GitHub Notifications Settings Page." width=100%>

1. Ensure your **Default Notifications Email** address is set to the email address you intend to use.
2. (Optional) If you would like to automatically watch repositories that you are active in, ensure **Automatically watch repositories** is set to "On."
3. (**Required**) If you would like to automatically subscribe to team-level notifications whenever you join a new team, ensnure **Automatically watch teams** is set to "On."
4. To receive notifications whenever a change is made to a repository or conversation that you are **Watching**, ensure the **Notify Me** setting has at least **Email** enabled.
5. To receive notifications whenever you or a group you belong to are @mentioned, ensure the **Notify Me** setting has at least **Email** enabled.

#### Watch a Repository

**Watching** a repository means you will be notified any time you are @mentioned or whenever a conversation you are participating in is updated.

The primary repository that owners should **watch** is the **Bicep-Registry-Modules** (BRM) repsository. Notifications from this repository will notify you of issues concerning your module and any @mentions and @Team Mentions. It is important that you **read and react** to these messages.

To watch the BRM repository, visit [Bicep-Registry-Modules](https://github.com/Azure/bicep-registry-modules), click the **Watch** button in the top-right of the page, then select **Participating and @mentions.** Optionally, if you would like to be notified for *all activity* within the repository, you can select **All Activity.**

{{< hint type=note >}}

Enabling **All Activity** will result in *a lot* of notifications! If you choose to go this route, you should set up filters within your email client. See [Configure Email Inbox Notification Filters](#configure-email-inbox-notification-filters).

{{< /hint >}}

#### Configure Email Inbox Notification Filters

GitHub uses a unique email address sender for each type of notification it sends. This allows us to set up filters within our email client to sort our inboxes depending on the type of notifications that was sent. The table below lists all of the relevant email addresses that may be useful for filtering notifications from GitHub.

{{< hint type=info >}}

GitHub will use the following email addresses to Cc you if you're subscribed to a conversation. The second Cc email address matches the notification reason.

{{< /hint >}}

| Type of Notification | GitHub Email Address | Notification Reason |
|-|-|-|
| @Mentions | mention@noreply.github.com | You were mentioned on an issue or pull request. |
| @Team Mention | team_mention@noreply.github.com | A team you belong to was mentioned on an issue or pull request |
| Subscribed | subscribed@noreply.github.com | There was an update in a repository you're watching. |
| Assign | assign@noreply.github.com | You were assigned to an issue or pull request. |
| Comment | comment@noreply.github.com | You commented on an issue or pull request. |

For a full list of GitHub notification types, see [Filtering Email Notifications](https://docs.github.com/en/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/configuring-notifications#filtering-email-notifications).

<br>

---

<br>

### 5. Contribution Checklist

This checklist can be used by anyone (author/contributor/owner) developing AVM Bicep Modules.

1. Before begining any work a new module a valid [Issue: New AVM Module Proposal](https://github.com/Azure/Azure-Verified-Modules/issues/new?assignees=&labels=Type%3A+New+Module+Proposal+%3Abulb%3A%2CNeeds%3A+Triage+%3Amag%3A&projects=Azure%2F529&template=module_proposal.yml&title=%5BModule+Proposal%5D%3A+%60MODULE_NAME_BETWEEN_BACKTICKS%60) needs to be created. Instructions for creating the module proposal are outlined in the issue template. Pay particular attention to the questions and associated links to fill out the proposal acurately. Please do not start work on your proposed module until you receive a notification that your proposal has been accepted.

2. Fork bicep-registry-modules [BRM](https://github.com/Azure/bicep-registry-modules), if you use an existing fork, ensure it's up to date with origin/BRM.

   - Make sure all workflows are [disabled by default](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) once you forked the BRM repo, to prevent any accidental deployments into your Azure test environment resulted by an automated deployment.

3. Create a new branch from your forked repository to develop your module.

4. If you created a new module you have to create its corresponding workflow file (see [here](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution)).
   - In order to run your e2e tests in your fork, this workflow file has to be put into `main` first so it can be run against your feature branch (GitHub Workflow appear by default and can run on feature branches only when they are present in main).
   - Since all workflows are disabled by default you have to enable your module's specific GitHub [workflow](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) to run your e2e tests.

5. [Implement your contribution](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution)

6. [Createupdate-and-run-tests](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#5-createupdate-and-run-tests)

7. Create PR and reference the status badge of your pipeline run see [here](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry).
