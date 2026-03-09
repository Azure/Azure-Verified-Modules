---
title: Terraform Contribution Flow
linktitle: Contribution Flow
description: Contribution flow for Azure Verified Modules (AVM) Terraform modules — for both module owners and external contributors.
weight: 2
---

This guide covers the end-to-end contribution flow for AVM Terraform modules.
Whether you are a **module owner** or an **external contributor**, the core workflow is the same — the key differences are called out using tabs below.

{{% notice style="important" %}}
This guide **MUST** be used in conjunction with the [Terraform specifications]({{% siteparam base %}}/specs/tf/). All AVM modules must meet the requirements described in those specifications.
{{% /notice %}}

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
  C2(5 - Run pr-check and e2e tests locally)
    click C2 "#5-run-pr-check-and-e2e-tests-locally"
  D(6 - Raise or Update PR)
    click D "#6-raise-or-update-pr"
  E("7 - Approve and monitor CI tests [owner]")
    click E "#7-approve-and-monitor-ci-tests"
  F{Tests passing?}
  G(8 - Review and merge PR)
    click G "#8-review-and-merge-pr"
  H(9 - Cut a release)
    click H "#9-cut-a-release"
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

{{% notice style="note" %}}
This step is only needed if you do **not** have write access to the module repository. Module owners and invited collaborators can skip to [step 2](#2-branch).
{{% /notice %}}

A fork is your own copy of the repository under your GitHub account. It lets you make changes without needing write access to the upstream repo. Once your changes are ready, you raise a pull request from your fork back to the original repository.

{{< tabs groupid="fork-method" >}}

{{% tab title="GitHub UI" %}}

1. Navigate to the module repository in the [`Azure`](https://github.com/Azure) GitHub organization.
2. Click the **Fork** button in the top right.
3. Select your GitHub account (or organization) as the destination.
4. Click **Create fork**.
5. Clone your fork locally:

    ```bash
    git clone https://github.com/<your-username>/terraform-azurerm-avm-res-<rp>-<modulename>.git
    cd terraform-azurerm-avm-res-<rp>-<modulename>
    ```

Keep your fork in sync with the upstream repository before creating a new branch. You can do this from the GitHub UI by clicking **Sync fork** on your fork's main page, or locally:

```bash
git remote add upstream https://github.com/Azure/terraform-azurerm-avm-res-<rp>-<modulename>.git
git fetch upstream
git checkout main
git merge upstream/main
```

{{% /tab %}}

{{% tab title="GitHub CLI" %}}

Use the [GitHub CLI](https://cli.github.com/) to fork and clone in one step. This automatically configures the `upstream` remote for you:

```bash
gh repo fork Azure/terraform-azurerm-avm-res-<rp>-<modulename> --clone
cd terraform-azurerm-avm-res-<rp>-<modulename>
```

Verify the remotes are set up correctly:

```bash
git remote -v
# origin    https://github.com/<your-username>/terraform-azurerm-avm-res-<rp>-<modulename>.git (fetch)
# upstream  https://github.com/Azure/terraform-azurerm-avm-res-<rp>-<modulename>.git (fetch)
```

{{% /tab %}}

{{< /tabs >}}

---

## 2. Branch

Create a branch from `main` to work on your changes:

```bash
git checkout -b <your-branch-name>
```

If this is a **new module** and the repository does not exist yet, module owners should first follow the [Repository Creation Process]({{% siteparam base %}}/contributing/terraform/repository-setup/).

{{% notice style="note" %}}
If the module repository does not exist yet, check the [Terraform Resource Modules index]({{% siteparam base %}}/indexes/terraform/tf-resource-modules/) for the module owner's contact details (`PrimaryModuleOwnerGHHandle` column).
{{% /notice %}}

---

## 3. Implement your code change

Before writing code, review the [Terraform specifications]({{% siteparam base %}}/specs/tf/) and [composition guidelines]({{% siteparam base %}}/contributing/terraform/composition/) to ensure your contribution complies with AVM's design principles.

Once you've made your changes, stage, commit, and push them:

```bash
git add -A
git commit -m "feat: description of your change"
git push
```

---

## 4. Run avm pre-commit

Before raising a pull request, run pre-commit to update your files:

{{% notice style="important" %}}
You need [Docker](https://www.docker.com/products/docker-desktop) (or [Podman](https://podman-desktop.io/downloads)) installed and running.
{{% /notice %}}

```bash
./avm pre-commit
```

This automatically updates your code formatting, fixes styling issues, and regenerates documentation to meet AVM standards. If pre-commit made any changes, commit and push again:

```bash
git add -A
git commit -m "chore: pre-commit fixes"
git push
```

---

## 5. Run pr-check and e2e tests locally

Before raising a PR (or while iterating on one), you can run the same checks that CI will run:

```bash
./avm pr-check
```

This runs static analysis and linting locally so you can catch issues before CI does.

### Local e2e testing

You can test your examples locally by running Terraform directly in the `examples/` folders:

```bash
cd examples/default
az login
terraform init
terraform plan
terraform apply
```

Use Azure CLI (`az login`) to authenticate — no environment variables or service principals are needed for local development.

When you're done, clean up your resources:

```bash
terraform destroy
```

This is especially useful for external contributors, since only module owners can approve CI e2e test runs.

### Terraform test (optional)

We support [terraform test](https://developer.hashicorp.com/terraform/language/tests) for unit and integration testing. Golang tests are **not** supported.

- **Unit tests** — place test files in `tests/unit`. Use [mocked providers](https://developer.hashicorp.com/terraform/language/tests/mocking) to keep them fast and free of external dependencies. Run with `./avm tf-test-unit`.
- **Integration tests** — place test files in `tests/integration`. These deploy real resources and should be run locally. Run with `./avm tf-test-integration`.

---

## 6. Raise or Update PR

{{% notice style="tip" %}}
**Raise your PR early** — don't wait until everything is perfect. An early PR lets you run pr-check and e2e tests in CI and get feedback sooner. You can continue pushing commits to the same branch.
{{% /notice %}}

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

1. Navigate to the upstream repository on GitHub and click **New pull request**.
2. Set the **base repository** to the upstream AVM repo and **base branch** to `main`.
3. Set your **head repository** and **compare branch** to your fork and branch.
4. Click **Create pull request**.

{{% /tab %}}

{{% tab title="Module Owner" %}}

1. Navigate to the repository on GitHub and click **New pull request**.
2. Set the **base branch** to `main` and the **compare branch** to your branch.
3. Click **Create pull request**.

{{% /tab %}}

{{< /tabs >}}

---

## 7. Approve and monitor CI tests

{{% notice style="note" %}}
Only module owners can approve CI test runs. External contributors should ensure they have run `./avm pr-check` and tested locally before this step.
{{% /notice %}}

Once a PR is created, CI workflows are triggered automatically but require a module owner to approve the run. A centrally managed Azure test subscription is provided — no credential configuration is needed.

### What CI runs

The `pr-check.yml` workflow runs two stages:

**Linting** — static analysis including:

- **avmfix** — formatting checks.
- **terraform-docs** — documentation is up to date.
- **TFLint** — AVM spec compliance.
- **Conftest** — checks the plan for Well-Architected Framework compliance using [Conftest](https://www.conftest.dev/) and OPA.

**End-to-end tests** — deploys and validates all module examples:

1. Lists all examples in the `examples/` directory.
2. Tests each example for idempotency (`terraform apply` then `terraform plan`).
3. Destroys all resources (`terraform destroy`).

### If tests fail

Go back to step 3 — fix the issue, run `./avm pre-commit` again, push your changes, and the CI tests will re-run automatically on the same PR.

### Running e2e for external contributions

When approving a PR from an external contributor:

1. **Review the code for security** — check for any malicious code or changes to workflow files before running tests. If found, close the PR and report the contributor.
2. Create a release branch from `main` (e.g. `release/<description>`).
3. Change the PR's base branch to the release branch and merge it.
4. Create a new PR from the release branch to `main` — this triggers pr-check and e2e tests.
5. Approve the run and wait for results.
6. If tests fail, send back to the contributor to fix and repeat from step 3.

### Running e2e for your own contributions

For your own PRs, the tests trigger automatically — approve the run and wait for results.

---

## 8. Review and merge PR

Every PR must be reviewed and approved before merging.

{{% include file="/static/includes/PR-approval-guidance.md" %}}

{{< tabs groupid="persona" >}}

{{% tab title="External Contributor" %}}

- Address any review comments and push updates to your branch.
- Request a re-review once changes are made.
- The module owner will merge the PR once approved and tests pass.

{{% /tab %}}

{{% tab title="Module Owner" %}}

For a brand new module being published for the first time, get the module reviewed by the AVM Core team by following the [AVM Review Process]({{% siteparam base %}}/contributing/terraform/review/) before merging.

### Owner responsibilities

- Watch PR and issue activity for your module and respond in a timely manner as per [SNFR11]({{% siteparam base %}}/spec/SNFR11).
- Familiarize yourself with [Team Definitions & RACI]({{% siteparam base %}}/specs/shared/team-definitions/#module-owners) and [TF Issue Triage]({{% siteparam base %}}/help-support/issue-triage/).

{{% /tab %}}

{{< /tabs >}}

---

## 9. Cut a release

{{% notice style="note" %}}
This step is performed by the **module owner** only.
{{% /notice %}}

After the PR is merged to `main`, create a release via [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository):

1. Go to the **Releases** tab and click **Draft a new release**.
2. Set **Target** to the `main` branch.
3. Type a new tag (e.g. `v0.1.0` for first publish, or increment for subsequent releases). **Tags MUST include the `v` prefix.**
4. Use **Generate release notes** and credit external contributors.
5. Click **Publish release**.

### First module publish

For a brand new module, contact the AVM core team (e.g. via the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project) to request initial publication to the HashiCorp Registry. Subsequent releases are published automatically.

{{% notice style="important" %}}
Continue publishing in the `v0.x.y` range (e.g., `v0.1.0`, `v0.1.1`, `v0.2.0`) until the AVM team notifies you that `v1.0.0` is allowed.
{{% /notice %}}

---

## Common mistakes to avoid

- Search and update `TODO` comments that come from the template — remove them once addressed.
- Do not commit `terraform.lock.hcl` — it is excluded by `.gitignore`.
- Update `_header.md` and `SUPPORT.md`.
- Do not commit `terraform.tfvars` files.
