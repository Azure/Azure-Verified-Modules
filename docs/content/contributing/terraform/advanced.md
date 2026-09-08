---
title: Advanced Topics & FAQ
linktitle: Advanced
description: Advanced scenarios, FAQ, and troubleshooting for AVM Terraform module contributions
weight: 5
---

This page covers advanced scenarios and frequently asked questions that go beyond the standard [contribution flow]({{% siteparam base %}}/contributing/terraform/contribution-flow/).

---

## Offline and air-gapped module mirroring

The [offline sync utility](https://github.com/Azure/Azure-Verified-Modules/tree/main/utilities/terraform/offline-sync) mirrors AVM Terraform modules and rewrites registry dependencies as git references for offline or air-gapped environments.

> [!WARNING]
> This utility is an example for advanced users familiar with PowerShell, Git, and Terraform module management. It is provided as-is and is not supported for production use.

---

## Using a custom Azure test subscription

By default, CI runs against a centrally managed Azure subscription. If your module needs a different environment (quota limits, tenant-level deployments, dedicated tenant), you can override the defaults.

**Understand the environments first.** The managed workflow runs jobs across several GitHub Environments:

| Environment | Job | Requests Azure token |
| --- | --- | --- |
| `pr-check` | `avm pr-check` (incl. `check policy` → `terraform plan`) | Yes |
| `integration-test` | `avm test integration` | Yes |
| `examples-test` | `avm test e2e` (one leg per example) | Yes |
| `no-approval` | subscription selection, unit tests, example discovery | No |

**Steps**

1. Create a user-assigned managed identity in your target Azure environment.

1. **Create one federated credential per Azure-authenticated environment** (`pr-check`, `integration-test`, and `examples-test`). The managed identity's federated credentials require an exact subject match, so a single credential cannot cover multiple environments. Use the **Other issuer** (custom) option rather than the "GitHub Actions deploying Azure resources" wizard, because the wizard emits `repo:ORG/REPO:environment:NAME`, which does **not** match what these workflows present.

    - **Issuer:** `https://token.actions.githubusercontent.com`
    - **Audience:** `api://AzureADTokenExchange`
    - **Subject** (one credential each, substituting the environment name):

      ```text
      repository_owner_id:<OWNER_ID>:repository_id:<REPO_ID>:environment:pr-check:job_workflow_ref:Azure/azure-verified-modules-tools/.github/workflows/terraform-module.yml@refs/heads/main
      repository_owner_id:<OWNER_ID>:repository_id:<REPO_ID>:environment:integration-test:job_workflow_ref:Azure/azure-verified-modules-tools/.github/workflows/terraform-module.yml@refs/heads/main
      repository_owner_id:<OWNER_ID>:repository_id:<REPO_ID>:environment:examples-test:job_workflow_ref:Azure/azure-verified-modules-tools/.github/workflows/terraform-module.yml@refs/heads/main
      ```

    {{% notice style="note" %}}
The repository's centrally managed OIDC configuration includes immutable owner/repository **IDs** and a `job_workflow_ref` segment identifying the *reusable* workflow. If authentication fails with `AADSTS700213`, compare the subject in the error message with the federated credential for that environment.
    {{% /notice %}}

    Find your IDs with:

    ```powershell
    gh api 'repos/<ORG>/<REPO>' --jq '{repository_id: .id, repository_owner_id: .owner.id}'
    ```

1. Assign appropriate Azure roles to the managed identity on the target subscription (and at management-group scope for pattern modules that assign policy or create role assignments).

1. **Add repository Actions variables** (**Settings** > **Secrets and variables** > **Actions** > **Variables** > **New repository variable**). These IDs are non-secret configuration. Module owners can manage repository variables; environment-scoped configuration is managed by the AVM core team.

    - `ARM_CLIENT_ID_OVERRIDE` - client ID of the managed identity.
    - `ARM_TENANT_ID_OVERRIDE` - tenant ID of the target Azure environment.
    - `ARM_SUBSCRIPTION_ID_OVERRIDE` - ID of the target Azure subscription.

    Set all three values for the same target Azure environment. The workflow maps nonempty overrides to the corresponding `ARM_*` variables in each Azure-authenticated job. `ARM_SUBSCRIPTION_ID_OVERRIDE` takes precedence over the centrally selected subscription, so all example legs use your subscription instead of distributing deployments across the shared pool.

    Do not change the repository defaults `ARM_CLIENT_ID`, `ARM_TENANT_ID`, or `TEST_SUBSCRIPTION_IDS`; these are managed by repository synchronization. Leave the shared subscription selection configured, because that job still runs before the overrides are applied. There is no `TEST_SUBSCRIPTION_IDS_OVERRIDE`.

{{% notice style="tip" %}}
`ARM_*_OVERRIDE` remains supported. The workflow merges variables first, then secrets, so a same-named override secret (including an environment secret) masks the variable. If your variables do not take effect, check for conflicting repository override secrets and ask the AVM core team to check for conflicting environment-scoped overrides.
{{% /notice %}}

---

## Custom variables and secrets for end-to-end tests

The `test` environment in each module repository has approvals and secrets configured for e2e tests. If you need additional variables or secrets:

- Add them to the `test` environment in your repository settings.
- They **must** be prefixed with `TF_VAR_` — other prefixes will be ignored.

---

## OPA (Conftest) policy exceptions

Conftest checks the plan for compliance with the Well-Architected Framework using [OPA policies](https://github.com/Azure/policy-library-avm).

If you get policy failures that need an exception, create a `.rego` file in the `exceptions` sub-directory of the relevant example:

```rego
package Azure_Proactive_Resiliency_Library_v2
import rego.v1
exception contains rules if {
  rules = ["configure_aks_default_node_pool_zones"]
}
```

---

## TFLint rule overrides

[TFLint](https://github.com/terraform-linters/tflint) checks AVM spec compliance using the [AVM custom ruleset](https://github.com/Azure/tflint-ruleset-avm). See the [AVM TFLint rules guide]({{% siteparam base %}}/contributing/terraform/tflint-rules/) for every enabled AVM rule, its applicability, exact disable block, and override precedence.

To override a rule, create one of the following HCL files in the root of your module:

| File | Scope |
| --- | --- |
| `avm.tflint.override.hcl` | Root module |
| `avm.tflint_module.override.hcl` | Submodules |
| `avm.tflint_example.override.hcl` | Examples |
| `modules/<name>/avm.tflint.override.hcl` | One direct submodule |
| `examples/<name>/avm.tflint.override.hcl` | One direct example |

Example:

```hcl
# Disable the required resource id output rule — this is a pattern module.
rule "avm_output_resource_id_required" {
  enabled = false
}
```

Include a comment explaining why the rule is disabled.

The target-directory override takes precedence over the matching repository-wide scope override and applies only to that direct submodule or example. AVM permits only `modules/*` and `examples/*` Terraform roots; nested module or example roots are prohibited and rejected by `Avm.Authoring` convention validation. Use a target override instead of weakening an all-submodule or all-example override.

---

## Excluding examples from end-to-end testing

Create a file called `.e2eignore` in the example directory. Its contents should explain why the example is excluded from tests.

---

## Global test setup and teardown

`Avm.Authoring` has no global setup or teardown hook. It does not execute or reject the legacy files:

- `examples/setup.sh`
- `examples/teardown.sh`

Move required setup and cleanup into idempotent per-example `pre.ps1` and `post.ps1` hooks. Coordinate removal of legacy global scripts with the repository's centrally managed CI workflow migration because older workflows can still invoke them.

---

## Per-example pre and post scripts

For example-specific setup/teardown:

- `examples/<example_name>/pre.ps1` (optional) — runs before Terraform commands for the example.
- `examples/<example_name>/post.ps1` (optional) — always runs after the example, including after a pre-hook or initialization failure.

Shell equivalents are rejected. Each PowerShell hook runs in an isolated process; see [Lifecycle hooks]({{% siteparam base %}}/contributing/terraform/contribution-flow/#lifecycle-hooks) for `.env`, path, and error-handling guidance.

---

## Repository synchronization PRs

[Repository sync](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/repository-sync) regularly compares each module repository with the shared [managed files](https://github.com/Azure/azure-verified-modules-managed-files) and opens a PR when updates are available. These PRs are normally merged automatically. Module owners will be informed about one-off PRs that require intervention.

These PRs do not change module code, so no new release is needed.

---

## Eventual consistency

The Azure Resource Manager API can be eventually consistent. For example, data plane role assignments may not be available immediately after creation.

Use the [AzAPI provider's retry functionality](https://registry.terraform.io/providers/Azure/azapi/latest/docs) to handle eventual consistency instead of arbitrary `time_sleep` delays. The AzAPI provider supports configurable retry with `retry` blocks that can match on specific error codes, providing a more reliable and efficient approach.
