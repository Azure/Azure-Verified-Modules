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

By default, CI end-to-end tests run against a centrally managed Azure subscription. If your module requires a different environment (e.g. due to quota limits or tenant-level deployments), you can override the defaults.

1. Create a user-assigned managed identity in your target Azure environment.
2. Create GitHub federated credentials for the managed identity, using the module's GitHub organization and repository. Select entity type **environment** and set the name to `test`.
3. Assign appropriate roles to the managed identity.
4. Elevate your access via the [Open Source Portal](https://repos.opensource.microsoft.com/orgs/Azure/repos/REPOSITORY-NAME/jit).
5. Go to the repository **Settings** > **Environments** > `test` and add the following secrets:
    - `ARM_CLIENT_ID_OVERRIDE` — Client ID of the managed identity.
    - `ARM_TENANT_ID_OVERRIDE` — Tenant ID.
    - `ARM_SUBSCRIPTION_ID_OVERRIDE` — Subscription ID.

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
