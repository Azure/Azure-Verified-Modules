---
title: Advanced Topics & FAQ
linktitle: Advanced
description: Advanced scenarios, FAQ, and troubleshooting for AVM Terraform module contributions
weight: 5
---

This page covers advanced scenarios and frequently asked questions that go beyond the standard [contribution flow]({{% siteparam base %}}/contributing/terraform/contribution-flow/).

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

[TFLint](https://github.com/terraform-linters/tflint) checks AVM spec compliance using the [AVM custom ruleset](https://github.com/Azure/tflint-ruleset-avm).

To override a rule, create one of the following HCL files in the root of your module:

| File | Scope |
| --- | --- |
| `avm.tflint.override.hcl` | Root module |
| `avm.tflint_module.override.hcl` | Submodules |
| `avm.tflint_example.override.hcl` | Examples |

Example:

```hcl
# Disable the required resource id output rule — this is a pattern module.
rule "required_output_rmfr7" {
  enabled = false
}
```

Include a comment explaining why the rule is disabled.

---

## Excluding examples from end-to-end testing

Create a file called `.e2eignore` in the example directory. Its contents should explain why the example is excluded from tests.

---

## Global test setup and teardown

If your module requires setup/teardown across **all** examples, create:

- `examples/setup.sh` — runs before all examples.
- `examples/teardown.sh` (optional) — runs after all examples.

These scripts are authorized with the same credentials as the examples.

---

## Per-example pre and post scripts

For example-specific setup/teardown:

- `examples/<example_name>/pre.sh` — runs before the example.
- `examples/<example_name>/post.sh` (optional) — runs after the example.

These run in the context of the example directory, so relative paths work.

---

## Grept and repository governance PRs

A weekly workflow checks repository contents using [Grept](https://github.com/Azure/grept) and creates a PR if issues are found. If you see a PR titled `chore: repository governance`, review and merge it.

These PRs do not change module code, so no new release is needed.

---

## Eventual consistency

The Azure Resource Manager API can be eventually consistent. For example, data plane role assignments may not be available immediately after creation.

Use the [AzAPI provider's retry functionality](https://registry.terraform.io/providers/Azure/azapi/latest/docs) to handle eventual consistency instead of arbitrary `time_sleep` delays. The AzAPI provider supports configurable retry with `retry` blocks that can match on specific error codes, providing a more reliable and efficient approach.
