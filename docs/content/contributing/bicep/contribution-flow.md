---
title: Bicep Contribution Flow
linktitle: Contribution Flow
description: Contribution flow for AVM Bicep modules, for Microsoft FTEs, module owners, and external contributors.
weight: 2
aliases:
  - /contributing/bicep/bicep-contribution-flow/
  - /contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/
  - /contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/
  - /contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/
---

This guide covers the end-to-end contribution flow for AVM Bicep modules. Whether you are a **module owner** or an **external contributor**, the core workflow is the same; the key differences are called out using tabs below.

## Prerequisites

Follow the [Bicep prerequisites]({{% siteparam base %}}/contributing/bicep/prerequisites/) to install Git, PowerShell, and `Avm.Authoring`. Review the [Bicep specifications]({{% siteparam base %}}/specs/bcp/) and [composition guidance]({{% siteparam base %}}/contributing/bicep/composition/).

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

External contributors without upstream write access can contribute from a fork. You do not need to configure GitHub Actions, Azure credentials, or secrets in your fork for upstream PR checks.

{{% /tab %}}

{{% tab title="Module Owner" %}}

Module owners and other Microsoft FTEs contribute through branches in the upstream [Bicep registry repository](https://github.com/Azure/bicep-registry-modules), not forks. Module owners must obtain the [AVM Module Contributors access package](https://aka.ms/avm/id/access-package/module-contributor); see [owner responsibilities]({{% siteparam base %}}/contributing/bicep/advanced/#module-owner-responsibilities).

{{% /tab %}}

{{< /tabs >}}

## Overview

{{< mermaid zoom="false" >}}

---
config:
  nodeSpacing: 20
  rankSpacing: 20
  diagramPadding: 50
  padding: 5
  flowchart:
    wrappingWidth: 300
    padding: 5
  layout: elk
  elk:
    mergeEdges: true
    nodePlacementStrategy: LINEAR_SEGMENTS
---

flowchart TD
  Z("1 - Fork [optional]")
    click Z "#1-fork-optional"
  A(2 - Branch)
    click A "#2-branch"
  B(3 - Implement your code change)
    click B "#3-implement-your-code-change"
  C(4 - Run avm pre-commit)
    click C "#4-run-avm-pre-commit"
  C2(5 - Run pr-check and test tiers locally)
    click C2 "#5-run-pr-check-and-test-tiers-locally"
  D(6 - Raise or Update PR)
    click D "#6-raise-or-update-pr"
  E("7 - Approve and monitor CI tests [owner]")
    click E "#7-approve-and-monitor-ci-tests"
  F{Tests passing?}
  G(8 - Review and merge PR)
    click G "#8-review-and-merge-pr"
  H(9 - Automated release)
    click H "#9-automated-release"
  Z --> A
  A --> B
  B --> C
  C --> C2
  C2 --> D
  D --> E
  E --> F
  F -->|no| B
  F -->|yes| G
  G --> H

{{< /mermaid >}}

---

## 1. Fork [optional]

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

Fork [Azure/bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) on GitHub and clone your fork, or use the GitHub CLI:

```powershell
gh repo fork Azure/bicep-registry-modules --clone
cd bicep-registry-modules
```

Keep your fork synchronized with upstream `main` before creating a branch.

{{% /tab %}}

{{% tab title="Module Owner" %}}

Skip this step and clone the upstream repository:

```powershell
git clone https://github.com/Azure/bicep-registry-modules.git
cd bicep-registry-modules
```

{{% /tab %}}

{{< /tabs >}}

## 2. Branch

Create a branch from the latest upstream `main` in your upstream checkout or synchronized fork:

```powershell
git checkout -b <your-branch-name>
```

## 3. Implement your code change

Follow the [composition guidance]({{% siteparam base %}}/contributing/bicep/composition/) and update the module's source, changelog, and applicable tests. A new module requires an [approved proposal](https://aka.ms/AVM/ModuleProposals) before work starts.

### Initialize a new module once

For an approved resource module, run this from the repository root, replacing the path with the approved module path:

```powershell
$modulePath = 'avm/res/<provider>/<module>'
avm init `
  -Ecosystem bicep `
  -ModuleType resource `
  -Path $modulePath
```

Use the approved module type for a pattern or utility module. The command prompts for missing approved metadata in an interactive terminal and scaffolds missing source, metadata, version, changelog, and test files without overwriting existing files. For unattended use, provide required metadata with `-InputObject`. For an approved proposal without source, use the [metadata-only process]({{% siteparam base %}}/contributing/module-metadata/#create-only-metadata-for-an-approved-bicep-proposal).

To initialize a child, set `$childPath` to its approved path and run:

```powershell
$childPath = 'avm/res/<provider>/<module>/<child>'
avm init `
  -Ecosystem bicep `
  -ModuleType resource `
  -Path $childPath `
  -ChildModule
```

Children inherit root ownership; see the [metadata rules]({{% siteparam base %}}/contributing/module-metadata/) and [child publishing guide]({{% siteparam base %}}/contributing/bicep/child-module-publishing/).

## 4. Run avm pre-commit

Run the AVM commands in steps 4–5 from the module directory. AVM infers the ecosystem and module path from the current location; use explicit targeting options only to work on a different module.

### Update generated files after editing

Before regenerating an existing README with hand-written Notes, [copy its Notes into a `README.notes.md` sidecar]({{% siteparam base %}}/contributing/bicep/advanced/#generated-readmes-and-notes) if it has no sidecar. Do the same for each affected child README; the generator does not copy Notes from existing READMEs.

```powershell
avm pre-commit
```

This validates metadata, formats and checks Bicep, compiles `main.json`, and generates `README.md` for the module and its children. Review and commit the changes, and rerun after subsequent edits. Do not run it on a metadata-only proposal before its source exists. See [Advanced Topics & FAQ]({{% siteparam base %}}/contributing/bicep/advanced/#generated-readmes-and-notes) for `avm docs` and existing Notes sections.

<span id="5-run-checks-and-tests-locally"></span>

## 5. Run pr-check and test tiers locally

After committing generated changes, run the PR checks with a clean working tree:

```powershell
avm pr-check
```

`avm pr-check` validates the module and checks generated-file drift; it does not replace the shared PR checks or run deployment tests.

The following test tiers are optional local checks and run separately from `avm pr-check`.

### Unit testing

Run authored Pester unit tests, including child modules:

```powershell
avm test unit -Recurse
```

A missing unit suite is reported as skipped, not passed.

### Local e2e testing

To list available deployment tests without Azure access:

```powershell
avm test e2e -Recurse -List
```

To run deployment tests locally, sign in to Azure PowerShell and Azure CLI with the same account, tenant, cloud, and subscription. The command uses Azure CLI to deploy and validate Bicep templates and checks that its identity matches the Azure PowerShell context. The subscription and tenant default to the active Azure PowerShell context; pass `-SubscriptionId` and `-TenantId` only when selecting a different target.

```powershell
avm test e2e -Location '<location>' -ResourceGroupPrefix 'avmtest' -Recurse
```

Deployment tests can create, update, and remove Azure resources, incur costs, and register required providers or features. Additional inputs depend on the test and deployment scope; see the [e2e command reference](https://github.com/Azure/azure-verified-modules-tools/blob/main/docs/reference/Invoke-AvmTestE2e.md).

## 6. Raise or Update PR

Push your branch and open a PR targeting upstream `main`. Follow the PR template and provide a meaningful title and description. For a new module, link the PR on its proposal issue and notify its triager or `@Azure/azure-verified-modules-tooling-contributors`; after merge, update the issue with a **Merged** comment and notify them again.

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

Create the PR from your fork's branch to `main` in `Azure/bicep-registry-modules`.

{{% /tab %}}

{{% tab title="Module Owner" %}}

Create the PR from your upstream branch to `main`.

{{% /tab %}}

{{< /tabs >}}

## 7. Approve and monitor CI tests

After the updated workflow is rolled out, PR validation and applicable unit and integration tests run automatically. Review their results and update your branch if checks fail. No fork workflow setup is required. If a test needs environment-specific inputs, coordinate [custom CI parameters]({{% siteparam base %}}/contributing/bicep/advanced/#custom-ci-parameters) with maintainers.

Open a PR early and use these checks while iterating. When the contribution is ready for deployment tests, request an e2e label; delaying those tests avoids unnecessary cloud costs and runtime.

An authorized maintainer must apply at least one of these labels to a same-repository PR to run its automatic e2e tests:

- `PR: Run Required E2E Tests` runs the applicable required scenarios for the module class. Resource modules require `defaults` and `waf-aligned`; pattern and utility modules require `defaults` only. A WAF-aligned scenario is optional for pattern and utility modules.
- `PR: Run All E2E Tests` runs the required scenarios and all optional scenarios.

Every selected scenario must pass the single `Report check status` merge gate. Missing required scenarios produce a warning, but existing required scenarios cannot be ignored to bypass checks. Required scenario names and semantics are defined in [BCPRMNFR1]({{% siteparam base %}}/spec/BCPRMNFR1) and [SNFR2]({{% siteparam base %}}/spec/SNFR2). Manual dispatch is a separate operator path; merge queues are not supported.

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

Labels do not give a fork PR access to credentials. An authorized FTE must perform the [release-branch handoff](#running-e2e-for-external-contributions) so the same-repository follow-up PR can run authenticated e2e tests and satisfy the merge gate.

{{% /tab %}}

{{% tab title="Module Owner" %}}

For an upstream PR, apply the label for the required scenarios or the label that also includes optional scenarios. Keep a label on the PR for automatic e2e testing on subsequent updates.

{{% /tab %}}

{{< /tabs >}}

### Running e2e for external contributions

Immediately before the handoff, an FTE must review the source code, dependencies, and workflow changes for security at the exact current PR head. Review the new head again if it changes. Authenticate the GitHub CLI (`gh`) as an authorized FTE with upstream access, then run:

```powershell
avm release-branch `
  --repository Azure/bicep-registry-modules `
  --pull-request 123
```

The command cannot verify which commit was reviewed. It captures the current head and stops if it changes during the handoff. It creates a release branch from `main`, retargets and merges the fork PR into that branch, opens a follow-up PR to `main`, and labels it `PR: Run Required E2E Tests`. An authorized maintainer may instead use `PR: Run All E2E Tests` to include optional scenarios. Restrict write access to the release branch and review any later changes before E2E testing or merging the follow-up PR. Use `--whatif` to preview; the command does not bypass repository protections.

If the handoff fails, inspect the fork PR and release branch before recovering manually; do not blindly rerun it. If E2E tests fail after a successful handoff, the original fork PR has been merged. Open a new fork PR containing the original changes and fixes, review its current head, and perform a new handoff. Inspect the existing follow-up PR and release branch before proceeding.

## 8. Review and merge PR

Address review feedback and request a re-review after updates. Authors cannot approve their own PRs.

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

Address review comments, update your branch, and request a re-review. An eligible repository team member merges the PR when required approvals and checks pass.

{{% /tab %}}

{{% tab title="Module Owner" %}}

A new module requires AVM core team review before merging. For ordinary changes, any eligible BRM repository team member may approve and merge under repository rules. Changes to `metadata.json` require [metadata code-owner review]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change).

{{% /tab %}}

{{< /tabs >}}

<span id="9-module-release"></span>

## 9. Automated release

After merge, the [module release workflow](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/release.yml) runs on pushes to `main` and can also be started manually. It discovers pending releases, checks the changelog, and creates scoped release tags. Module owners must verify both the release workflow and subsequent publication to the public Bicep registry; tag creation alone does not prove publication. [Metadata-only changes]({{% siteparam base %}}/contributing/module-metadata/) must not trigger a module release.
