---
title: Owner Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

This section describes the contribution flow for module owners who are responsible for creating and maintaining Bicep Modules.

{{< toc >}}

{{< hint type=important >}}

This contribution flow is for **Module Owners** only.

As a **Bicep Module Owner** you need to be aware of the [AVM Contribution Process Overview](/Azure-Verified-Modules/contributing/process/), [Shared Specifications](/Azure-Verified-Modules/specs/shared/) (including [Interfaces](/Azure-Verified-Modules/specs/shared/interfaces/)) and [Bicep-specific](/Azure-Verified-Modules/specs/bicep/) specifications as these need to be followed during pull request reviews for the modules you own. The purpose of this **Owner Contribution Flow** is to simplify and list the most important activities of an owner and to help you understand your responsibilities as an owner.

{{< /hint >}}

{{< hint type=note >}}

Additional internal content for **ongoing module maintenance** available for Microsoft FTEs, [here](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/472/Module-maintenance-tasks).

{{< /hint >}}

---

## 1. Owner Activities and Responsibilities

Familiarise yourself with the responsibilities as **Module Owner** outlined in [Team Definitions & RACI](/Azure-Verified-Modules/specs/shared/team-definitions/#module-owners) and [Module Owner Responsibilities](/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/#module-owner-responsibilities) in the [BRM Issue Triage](/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/).

1. Create GitHub teams as outlined in [SNFR20](/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) and add respective parent teams:

Segments:

- `avm-res-<RP>-<modulename>-module-owners-bicep`
- `avm-res-<RP>-<modulename>-module-contributors-bicep`

Examples:

- `avm-res-compute-virtualmachine-module-owners-bicep` and added `avm-technical-reviewers-bicep` as parent.
- `avm-res-compute-virtualmachine-module-contributors-bicep` and added `avm-module-contributors-bicep` as parent.

If a secondary owner is required, add the secondary owner to the `avm-res-<RP>-<modulename>-module-owners-bicep` team.

Only fulltime Microsoft employees can be added at this time.

{{< hint type=info >}}

Once the teams have been created the AVM Core Team will review the team name and parent team membership for accuracy. A notification will automatically be sent to the AVM Core Team to inform them that their review needs to be completed.
{{< /hint >}}

2. Add teams to `CODEOWNERS` file as outlined in [SNFR20](/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only).
3. Ensure your module has been tested before raising a PR. You can do this your own or in another module contributor's environment - if any. Also, once a PR is raised, a GitHub workflow pipeline is required to be run successfully before the PR can be merged. This is to ensure that the module is working as expected and is compliant with the AVM specifications.
{{< hint type=note >}}

If you're the **sole owner of the module**, the **AVM core team must review and approve the PR**. To indicate that your PR needs the core team's attention, **apply the** "<mark style="background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>" **label on it!**

{{< /hint >}}
4. Ensure that the module(s) you own are compliant with the AVM specifications and are working as expected. While all specifications are to be followed, pay special attention to the following ones as in these, the `Owner` is mentioned explicitly:
| ID | Specification |
|---------------|-----------------------|
| [SFR1](/Azure-Verified-Modules/specs/shared/#id-sfr1---category-composition---preview-services) | Composition - Preview Services |
| [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing) | Testing - E2E Testing |
| [SNFR3](/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-compliance-tests) | Testing - AVM Compliance Tests |
| [SNFR8](/Azure-Verified-Modules/specs/shared/#id-snfr8---category-contributionsupport---module-owners-github) | Contribution/Support - Module Owner(s) GitHub |
| [SNFR11](/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times) | Contribution/Support - Issues Response Times |
| [SNFR12](/Azure-Verified-Modules/specs/shared/#id-snfr12---category-contributionsupport---versions-supported) | Contribution/Support - Versions Supported |
| [SNFR17](/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) | Release - Semantic Versioning |
| [SNFR20](/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) | Contribution/Support - GitHub Teams Only |
| [SNFR21](/Azure-Verified-Modules/specs/shared/#id-snfr21---category-publishing---cross-language-collaboration) | Publishing - Cross Language Collaboration |
| [SNFR24](/Azure-Verified-Modules/specs/shared/#id-snfr24---category-testing---testing-child-extension--interface-resources) | Testing - Testing Child, Extension & Interface Resources |
| [SNFR25](/Azure-Verified-Modules/specs/shared/#id-snfr25---category-composition---resource-naming) | Composition - Resource Naming |
| [RMNFR3](/Azure-Verified-Modules/specs/shared/#id-rmnfr3---category-composition---rp-collaboration) | Composition - RP Collaboration |
| [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) | Composition - AVM Consistent Feature & Extension Resources Value Add |
| [RMFR7](/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs) | Outputs - Minimum Required Outputs |

5. Watch Pull Request (PR) activity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository (Bicep Registry Modules repository - where all Bicep AVM modules are published) and ensure that PRs are reviewed and merged in a timely manner as outlined in [SNFR11](/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times).
6. Watch AVM module issue and AVM question/feedback activity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository.

---

## 2. Module Handover Activities

Under certain circumstances, you may find yourself unable to continue as the module owner. In such cases, it is advisable to designate a new module owner. The following steps outline this transition:

- Leave a comment on the original module proposal, indicating that you'd like to hand the ownership over to somebody else. Mention the person who originally helped triage the issue or the `@Azure/avm-core-team-technical-bicep` team. You must wait for someone from the AVM Core Team to respond first, as the module index must be updated before you can continue handing over the ownership.
- Add the new owner's GitHub account as a "maintainer" on your modules GitHub teams.
- Remove your GitHub account from your module's GitHub teams.

If a new module owner cannot be identified then the module will need to be "Orphaned". Please follow the step outlined [when-a-module-becomes-orphaned](/Azure-Verified-Modules/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned).

---

## 3. Adopting an Orphaned Module

When adopting an orphaned module the [when-a-new-owner-is-identified](/Azure-Verified-Modules/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified) steps must be followed.

---

## 4. GitHub Notification Settings

As a module owner, it's important that you receive notifications when any of your AVM modules experience activity or when you or any groups you belong to are explicitly mentioned (using the @ operator). This document describes how to configure your GitHub and Email settings to ensure you receive email notifications for these types of scenarios within GitHub.

### Enable Global GitHub Notifications

Visit the [GitHub Notifications Settings Page](https://github.com/settings/notifications) while logged in with your GitHub account.

<img src="/Azure-Verified-Modules/img/contribution/gh_notifications_page.png" alt="GitHub Notifications Settings Page." width=100%>

1. Ensure your **Default Notifications Email** address is set to the email address you intend to use.
2. (Optional) If you would like to automatically watch repositories that you are active in, ensure **Automatically watch repositories** is set to "On."
3. (**Required**) If you would like to automatically subscribe to team-level notifications whenever you join a new team, ensure **Automatically watch teams** is set to "On."
4. (**Required**) To receive notifications whenever a change is made to a repository or conversation that you are **Watching**, ensure the **Notify Me** setting has at least **Email** enabled.
5. (**Required**)To receive notifications whenever you or a group you belong to are @mentioned, ensure the **Notify Me** setting has at least **Email** enabled.

### Watch a Repository

Optionally, you may consider "watching" (following most or all activities in) an entire repository. The primary repository that owners should **watch** is the **Bicep-Registry-Modules** (BRM) repository. Notifications from this repository will notify you of issues concerning your module and any direct or team @mentions. It is important that you **read and react** to these messages.

To watch the BRM repository, visit [Bicep-Registry-Modules](https://github.com/Azure/bicep-registry-modules), click the **Watch** button in the top-right of the page, then select **Participating and @mentions.** Optionally, if you would like to be notified for *all activity* within the repository, you can select **All Activity.**

{{< hint type=note >}}

Enabling **All Activity** will result in *a lot* of notifications! If you choose to go this route, you should set up filters within your email client. See [Configure Email Inbox Notification Filters](#configure-email-inbox-notification-filters).

{{< /hint >}}

<img src="/Azure-Verified-Modules/img/contribution/gh_watch.png" alt="GitHub Notifications Page." width=100%>

### Configure Email Inbox Notification Filters

GitHub uses a unique email address sender for each type of notification it sends. This allows us to set up filters within our email client to sort our inboxes depending on the type of notifications that was sent. The table below lists all of the relevant email addresses that may be useful for filtering notifications from GitHub.

{{< hint type=info >}}

GitHub will use the following email addresses to Cc you if you're subscribed to a conversation. The second Cc email address matches the notification reason.

{{< /hint >}}

| Type of Notification | GitHub Email Address | Notification Reason |
| --- | --- | --- |
| @Mentions | <mention@noreply.github.com> | You were mentioned on an issue or pull request. |
| @Team Mention | <team_mention@noreply.github.com> | A team you belong to was mentioned on an issue or pull request |
| Subscribed | <subscribed@noreply.github.com> | There was an update in a repository you're watching. |
| Assign | <assign@noreply.github.com> | You were assigned to an issue or pull request. |
| Comment | <comment@noreply.github.com> | You commented on an issue or pull request. |

For a full list of GitHub notification types, see [Filtering Email Notifications](https://docs.github.com/en/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/configuring-notifications#filtering-email-notifications).

---

## 5. Contribution Checklist

This checklist can be used in the development of AVM Bicep Modules.

1. Before beginning any work a new module a valid [Issue: New AVM Module Proposal](https://github.com/Azure/Azure-Verified-Modules/issues/new?assignees=&labels=Type%3A+New+Module+Proposal+%3Abulb%3A%2CNeeds%3A+Triage+%3Amag%3A&projects=Azure%2F529&template=module_proposal.yml&title=%5BModule+Proposal%5D%3A+%60MODULE_NAME_BETWEEN_BACKTICKS%60) needs to be created. Instructions for creating the module proposal are outlined in the issue template. Pay particular attention to the questions and associated links to fill out the proposal accurately. Please do not start work on your proposed module until you receive a notification that your proposal has been accepted.
2. Fork the bicep-registry-modules [BRM](https://github.com/Azure/bicep-registry-modules) repository. If you use an existing fork, ensure it's up to date with origin/BRM.

    - Ensure all workflows are [disabled by default](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) once you forked the BRM repo, to prevent any accidental deployments into your Azure test environment resulted by an automated deployment.

3. Create a new branch from your forked repository to develop your module.
4. If you're working on a new module you have to create its corresponding workflow file (see [here](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution)).

    - In order to run your e2e tests in your fork, this workflow file has to be put into the `main` branch first, so it can be run against your feature branch (GitHub Workflows can only be run on feature branches when they are already present in the main branch).
    - Since all workflows are disabled by default you have to enable your module's specific GitHub [workflow](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) to run your e2e tests.

5. [Implement your contribution](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution).
6. [Create, update, and run tests](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#5-createupdate-and-run-tests).

    - In addition to testing your module via GitHub pipeline, you can also [test-locally](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/). The following helper script facilitates local testing.

    {{< expand "➕ Local Test Helper Script" "expand/collapse" >}}

    {{< include file="/static/scripts/sample-localtest-helper.ps1" language="powershell" options="linenos=false" >}}

    {{< /expand >}}

7. Create a PR and reference the status badge of your pipeline run - [see here](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry).
{{< hint type=note >}}

If you're the **sole owner of the module**, the **AVM core team must review and approve the PR**. To indicate that your PR needs the core team's attention, **apply the** "<mark style="background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>" **label on it!**

{{< /hint >}}

8. After a pull request has been created, it is important to update the [AVM module proposal](https://aka.ms/AVM/ModuleProposals) issue associated with your module, with a link to the pull request you created in BRM and mention the person who helped triage your module or the `@Azure/avm-core-team-technical-bicep` team.
9. Once your BRM pull request has been approved and merged into main update the [AVM module proposal](https://aka.ms/AVM/ModuleProposals) issue associated with your module, with a **Merged** comment and mention the person who helped triage your module, or the `@Azure/avm-core-team-technical-bicep` team.
