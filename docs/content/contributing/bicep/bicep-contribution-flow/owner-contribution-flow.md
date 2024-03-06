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

As a **Bicep Module Owner** you need to be aware of the [AVM Contribution Process Overview](https://azure.github.io/Azure-Verified-Modules/contributing/process/), [Shared Specifications](https://azure.github.io/Azure-Verified-Modules/specs/shared/) (including [Interfaces](https://azure.github.io/Azure-Verified-Modules/specs/shared/interfaces/)) and [Bicep-specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) specifications as as these need to be considered during pull request reviews for the modules you own. The purpose of this **Owner Contribution Flow** is to simplify and list all activities as an owner and to help you understand your responsibilities as an owner.

{{< /hint >}}

<br>

---

<br>

### 1. Owner Activities and Responsibilities

<!-- TODO: Rephrase sections if required -->
Familiarise yourself with the responsibilities as **Module Owner** outlined in [Team Definitions & RACI](https://azure.github.io/Azure-Verified-Modules/specs/shared/team-definitions/#module-owners) and [Module Owner Responsibilities](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/#module-owner-responsibilities) in the [BRM Issue Triage](https://azure.github.io/Azure-Verified-Modules/help-support/issue-triage/brm-issue-triage/).

1. Create GitHub teams as outlined in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) and add respective parent teams:

Segments:

- `@Azure/avm-res-<RP>-<modulename>-module-owners-bicep`
- `@Azure/avm-res-<RP>-<modulename>-module-contributors-bicep`

Examples:

- `@Azure/avm-res-compute-virtualmachine-module-owners-bicep` and added `@Azure/avm-technical-reviewers-bicep` as parent.
- `@Azure/avm-res-compute-virtualmachine-module-contributors-bicep` and added `@Azure/avm-module-contributors-bicep` as parent.

If a secondary owner is required, add the secondary owner to the `@Azure/avm-res-<RP>-<modulename>-module-owners-bicep` team.

{{< hint type=info >}}

Once you added the parent teams it needs to be approved by the AVM team to ensure team name and parent team membership is correct.

{{< /hint >}}

2. Add teams to `CODEOWNERS` file as outlined in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only).

3. Watch Pull Request (PR) activity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository (Bicep Registry Modules repository - where all Bicep AVM modules are published) and ensure that PRs are reviewed and merged in a timely manner as outlined in [SNFR11](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times).

{{< hint type=info >}}

Make sure module authors/contributors tested their module in their environment before raising a PR. Also because once a PR is raised a GitHib workflow pipeline is required to be run successfully before the PR can be merged. This is to ensure that the module is working as expected and is compliant with the AVM specifications.

{{< /hint >}}

4. Watch AVM module issue and AVM question/feedback acitvity for your module(s) in the [BRM](https://github.com/Azure/bicep-registry-modules) repository.

5. Ensure that the module(s) you own are compliant with the AVM specifications and are working as expected. Following specifications are to be considered and where `Owner` is mentioned explicitly:

| ID | Specification |
|---------------|-----------------------|
| [SFR1](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-sfr1---category-composition---preview-services) | Category: Composition - Preview Services |
| [SNFR2](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing) | Category: Testing - E2E Testing |
| [SNFR3](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-compliance-tests) | Category: Testing - AVM Compliance Tests |
| [SNFR8](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr8---category-contributionsupport---module-owners-github) | Category: Contribution/Support - Module Owner(s) GitHub |
| [SNFR11](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times) | Category: Contribution/Support - Issues Reponse Times |
| [SNFR12](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr12---category-contributionsupport---versions-supported) | Category: Contribution/Support - Versions Supported |
| [SNFR17](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) | Category: Release - Semantic Versioning |
| [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) | Category: Contribution/Support - GitHub Teams Only |
| [SNFR21](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr21---category-publishing---cross-language-collaboration) | Category: Publishing - Cross Language Collaboration |
| [SNFR24](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr24---category-testing---testing-child-extension--interface-resources) | Category: Testing - Testing Child, Extension & Interface Resources |
| [SNFR25](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr25---category-composition---resource-naming) | Category: Composition - Resource Naming |
| [RMNFR3](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmnfr3---category-composition---rp-collaboration) | Category: Composition - RP Collaboration |
| [RMFR4](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) | Category: Composition - AVM Consistent Feature & Extension Resources Value Add |
| [RMFR7](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs) | Category: Outputs - Minimum Required Outputs |

<br>

---

<br>

### 2. Module Handover Activities

<!-- TODO: Rephrase if required -->
1. Add new owner as maintainer and remove any other individual including yourself
2. In case primary owner leaves, switches roles or abandons the repo and the corresponding team then the parent team doesn't have the permissions to gain back access and a ticket with GitHub support needs to be created (but the team can still be removed from the repo since avm-core-team has permissions on it)

<br>

---

<br>

### 3. Orphaned Module Handover Activities

<!-- TODO: Rephrase if required -->
1. Add new owner as maintainer and remove any other individual.
2. Remove `ORPHANED.md` from the root directory of the Module.

<br>

---

<br>

### 4. GitHub Notification Settings

As a module owner, it's important that you receive notifications when any of your AVM modules experience activity or when you or any groups you belong to are explicitly mentioned (using the @ operator). This document describes how to configure your GitHub and Email settings to ensure you receive email notifications for these types of scenarios within GitHub.

#### Enable Global GitHub Notifications

Visit the [GitHub Notifcations Settings Page](https://github.com/settings/notifications) while logged in with your AVM account.

<img src="/Azure-Verified-Modules/img/contribution/gh_notifications_page.png" alt="GitHub Notifications Settings Page." width=100%>

1. Ensure your **Default Notifications Email** address is set to the email address you intend to use.
2. (Optional) If you would like to automatically watch repositories that you are active in, ensure **Automatically watch repositories** is set to "On."
3. (Required) If you would like to automatically subscribe to team-level notifications whenever you join a new team, ensnure **Automatically watch teams** is set to "On."
4. To receive notifications whenever a change is made to a repository or conversation that you are **Watching**, ensure the **Notify Me** setting has at least **Email** enabled.
5. To receive notifications whenever you or a group you belong to are @mentioned, ensure the **Notify Me** setting has at least **Email** enabled.

#### Watch a Repository

To receive notifications within a repository, you must be **Watching** that repository. When you are **watching** a repository, you will be notified any time you are @mentioned or whenever a conversation you are participating in is updated.

To watch the AVM repository, visit the [AVM repo's main page](https://github.com/Azure/bicep-registry-modules), click the **Watch** button in the top-right of the page, then select **Participating and @mentions.** Optionally, if you would like to be notified for *all activity* within the repository, you can select **All Activity.**

<img src="/Azure-Verified-Modules/img/contribution/gh_watch.png" alt="GitHub Notifications Page." width=100%>


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

<!-- TODO:
- I added this section here because I don't know if ths should be under Owner or a separated secion under Bicep Contribution Flow
- This section definitely needs to be rephrased or moved to a different section
-->
This checklist can be used by anyone (author/contributor/owner) developing AVM Bicep Modules.

1. You agreed in your issue to start developing your AVM module.
2. Define your module name assets which you can also find [here](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/BicepResourceModules.csv):
- [Naming convention](https://azure.github.io/Azure-Verified-Modules/specs/shared/#terraform-resource-module-naming):  `avm-res-<resource provider>-<ARM resource type>`
- Module name: `avm-res-dev-center-devcenter`
- Module folder: `avm/res/dev-center/devcenter`
- TelemetryIdPrefix: `46d3xbcp.res.devcenter-devcenter`
1. Fork bicep-registry-modules [BRM](https://github.com/Azure/bicep-registry-modules), if you use an existing fork, make sure it's up to date with origin/BRM.
- Make sure all workflows are [disabled by default](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) once you forked BRM, to prevent accidental runs in your Azure test environment. Since all workflows are disabled by default you have to enable it manually for running your e2e test.
- It is best practice to create a branch even when working in a fork, it is not recommended to directly push commits into main.
- If you create a new module you have to create its corresponding workflow file (see [here](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution)). In order to run your e2e tests in your fork, this workflow file has to be put into `main` first so it can be run against your feature branch (GitHub Workflow appear by default and can run on feature branches only when they are present in main).
- If you update/fix an existing module you don't have to do this because the corresponding workflow already exists in `main`.
1. Implement your contribution
- New module: Copy an existing module or start from scratch
- Migrate module: Copy module from CARML
- Adjust code according to specs.
1. Run Set-AVMModule.ps1
2. Run Test-ModuleLocally.ps1
3. Use Helper script (see code below).
4. Run e2e/test pipeline in your fork branch
5. Create PR and reference the status badge of your pipeline run see [here](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry).


```powershell
# Start pwsh if not started yet

#pwsh

# Set default directory
$folder = "<your directory>/bicep-registry-modules"

# Dot source functions

. $folder/avm/utilities/tools/Set-AVMModule.ps1
. $folder/avm/utilities/tools/Test-ModuleLocally.ps1

# Variables

$modules = @(
    # "service-fabric/cluster",
    "network/private-endpoint"
)

# Generate Readme

foreach ($module in $modules) {
    Write-Output "Generating ReadMe for module $module"
    Set-AVMModule -ModuleFolderPath "$folder/avm/res/$module" -Recurse

    # Set up test settings

    $testcases = "waf-aligned", "max", "defaults"

    $TestModuleLocallyInput = @{
        TemplateFilePath           = "$folder/avm/res/$module/main.bicep"
        ModuleTestFilePath         = "$folder/avm/res/$module/tests/e2e/max/main.test.bicep"
        PesterTest                 = $true
        ValidationTest             = $false
        DeploymentTest             = $false
        ValidateOrDeployParameters = @{
            Location         = '<your location>'
            SubscriptionId   = '<your subscriptionId>'
            RemoveDeployment = $true
        }
        AdditionalTokens           = @{
            namePrefix = '<your prefix>'
            TenantId   = '<your tenantId>'
        }
    }

    # Run tests

    foreach ($testcase in $testcases) {
        Write-Output "Running test case $testcase on module $module"
        $TestModuleLocallyInput.ModuleTestFilePath = "$folder/avm/res/$module/tests/e2e/$testcase/main.test.bicep"
        Test-ModuleLocally @TestModuleLocallyInput
    }
}
```
