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

CI normally uses a centrally managed identity and test subscription. To deploy examples in your own Azure tenant and subscription, you can configure a test identity and override the identity, tenant, and subscription for **end-to-end execution only**. These overrides are independent of AVM's test subscriptions. PR checks, including the Conftest Terraform plan, and integration tests continue to use the central identity and selected test subscription.

**Understand the environments first.** The managed workflow runs jobs across several GitHub Environments:

| Environment | Job | Requests Azure token |
| --- | --- | --- |
| `pr-check` | `avm pr-check` (incl. `check policy` → `terraform plan`) | Yes |
| `integration-test` | `avm test integration` | Yes |
| `examples-test` | Approval-protected example discovery | No |
| `examples-test-execution` | `avm test e2e` (one leg per example) | Yes |
| `no-approval` | Subscription selection | No |
| None | Unit tests | No |

**Steps**

1. Use a user-assigned managed identity in your target tenant with the appropriate Azure permissions on your test subscription and any required management-group scope. Use a dedicated test environment rather than granting production permissions.

1. Run this PowerShell 7 script to create a **flexible federated identity credential** for `examples-test-execution` and set all three repository override variables. It reads the identity's client and tenant IDs automatically. Variables are recommended because these IDs are non-secret configuration; repository secrets are also supported.

    The script uses [Azure CLI `az rest`](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-flexible-federated-identity-credentials#azure-cli-azure-powershell-and-terraform-providers) with the [managed identity preview API](https://learn.microsoft.com/en-us/azure/templates/microsoft.managedidentity/2025-01-31-preview/userassignedidentities/federatedidentitycredentials). It requires GitHub CLI access to manage Actions variables in the module repository, Azure CLI already authenticated to the identity's tenant, and permission to read the identity and write and read its federated identity credentials. Replace the placeholders and choose a new credential name: PUT replaces a credential with the same name, and existing override variables will be updated. The target test subscription can differ from the subscription containing the identity.

    ```powershell
    $moduleOwner = '<MODULE_OWNER>'
    $moduleRepo = '<MODULE_REPOSITORY>'
    $identitySubscriptionId = '<IDENTITY_SUBSCRIPTION_ID>'
    $identityResourceGroup = '<IDENTITY_RESOURCE_GROUP>'
    $identityName = '<USER_ASSIGNED_IDENTITY_NAME>'
    $testSubscriptionId = '<TARGET_TEST_SUBSCRIPTION_ID>'
    $credentialName = 'avm-examples-test-execution'
    $moduleRepository = "$moduleOwner/$moduleRepo"

    $repository = gh api "repos/$moduleRepository" `
      --jq '{id: .id, owner: {id: .owner.id}}' | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0 -or -not $repository.id -or -not $repository.owner.id) {
      throw 'Could not retrieve the module repository and owner IDs.'
    }

    $managedIdentity = az identity show `
      --subscription $identitySubscriptionId `
      --resource-group $identityResourceGroup `
      --name $identityName `
      --output json | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0 -or -not $managedIdentity.clientId -or -not $managedIdentity.tenantId) {
      throw 'Could not retrieve the managed identity client and tenant IDs.'
    }

    $subjectPattern = "repository_owner_id:$($repository.owner.id):repository_id:$($repository.id):environment:examples-test-execution:*"
    $workflowPattern = 'Azure/azure-verified-modules-tools/.github/workflows/terraform-module.yml@*'
    $expression = "claims['sub'] matches '$subjectPattern' and claims['job_workflow_ref'] matches '$workflowPattern' and claims['repository_id'] eq '$($repository.id)' and claims['repository_owner_id'] eq '$($repository.owner.id)'"
    $body = @{
      properties = @{
        issuer = 'https://token.actions.githubusercontent.com'
        audiences = @('api://AzureADTokenExchange')
        claimsMatchingExpression = @{ languageVersion = 1; value = $expression }
      }
    } | ConvertTo-Json -Depth 5
    $bodyPath = Join-Path (Get-Location).Path 'avm-e2e-federation.json'
    if (Test-Path -LiteralPath $bodyPath) { throw 'Choose a clean working directory; the JSON file already exists.' }
    [System.IO.File]::WriteAllText(
      $bodyPath,
      $body,
      [System.Text.UTF8Encoding]::new($false)
    )

    $rg = [uri]::EscapeDataString($identityResourceGroup)
    $identity = [uri]::EscapeDataString($identityName)
    $credential = [uri]::EscapeDataString($credentialName)
    $uri = "https://management.azure.com/subscriptions/$identitySubscriptionId/resourceGroups/$rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$identity/federatedIdentityCredentials/$($credential)?api-version=2025-01-31-preview"
    az rest --method put `
      --url $uri `
      --headers 'Content-Type=application/json' `
      --body '@avm-e2e-federation.json'
    if ($LASTEXITCODE -ne 0) { throw 'Credential creation failed.' }
    az rest --method get `
      --url $uri
    if ($LASTEXITCODE -ne 0) { throw 'Credential readback failed.' }

    $overrides = [ordered]@{
      ARM_CLIENT_ID_OVERRIDE = $managedIdentity.clientId
      ARM_TENANT_ID_OVERRIDE = $managedIdentity.tenantId
      ARM_SUBSCRIPTION_ID_OVERRIDE = $testSubscriptionId
    }
    foreach ($override in $overrides.GetEnumerator()) {
      gh variable set $override.Key `
        --repo $moduleRepository `
        --body $override.Value
      if ($LASTEXITCODE -ne 0) {
        throw "Failed to set repository variable '$($override.Key)'."
      }
    }

    gh variable list `
      --repo $moduleRepository
    if ($LASTEXITCODE -ne 0) { throw 'Could not list repository variables.' }
    ```

    Verify the returned issuer, audience, language version, and expression before using the identity. The JSON file contains configuration, not credentials; remove it when finished. The body omits `subject` because it is mutually exclusive with `claimsMatchingExpression`.

    The customized subject uses immutable owner and repository IDs and the exact execution environment. Its trailing wildcard is necessary to keep the subject comparand within Azure's 128-character limit; the separate `job_workflow_ref` clause restricts the reusable workflow to the exact Tools repository and path, wildcarding only its ref. Both immutable ID claims are also checked separately. Do not broaden the repository, environment, or workflow path. The calling workflow must still pin the reusable workflow to a full commit SHA; wildcarding the credential's ref does not relax that requirement. If authentication fails with `AADSTS700213`, compare the presented claims with this expression.

    The script sets these repository Actions variables. You can also manage them under **Settings** > **Secrets and variables** > **Actions** > **Variables**:

    - `ARM_CLIENT_ID_OVERRIDE` - client ID of the managed identity.
    - `ARM_TENANT_ID_OVERRIDE` - tenant ID of the target Azure environment.
    - `ARM_SUBSCRIPTION_ID_OVERRIDE` - ID of your target test subscription. This can differ from the subscription containing the managed identity.

    Set all three values consistently. During end-to-end execution, nonempty overrides map to the corresponding `ARM_*` variables; the subscription override takes precedence over the centrally selected subscription. PR checks and integration tests do not use these overrides.

    Do not change the repository defaults `ARM_CLIENT_ID`, `ARM_TENANT_ID`, or `TEST_SUBSCRIPTION_IDS`; these are managed by repository synchronization. Leave the shared subscription selection configured, because that job still runs before the overrides are applied. There is no `TEST_SUBSCRIPTION_IDS_OVERRIDE`.

{{% notice style="tip" %}}
The workflow merges repository variables first, then repository secrets, so a same-named override secret masks the variable. If your variables do not take effect, check for conflicting repository override secrets.
{{% /notice %}}

---

## Custom variables and secrets for end-to-end tests

Example discovery runs in the approval-protected `examples-test` environment; example execution runs in `examples-test-execution`. If execution needs additional variables or secrets:

- Add them as repository Actions variables or secrets.
- Use `TF_VAR_` for Terraform input variables. Other non-protected names are also forwarded to execution and example hooks. Secrets take precedence over same-named variables. Avoid protected runner and GitHub environment names.

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

Sync uses the default branch's root `metadata.json` for the display name and full owner list. Submit changes to those values through the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change).

A synchronization update can include module source and managed configuration. Review any requested intervention accordingly; source changes need normal validation and release handling. A metadata-only change does not require a module release.

---

## Eventual consistency

The Azure Resource Manager API can be eventually consistent. For example, data plane role assignments may not be available immediately after creation.

Use the [AzAPI provider's retry functionality](https://registry.terraform.io/providers/Azure/azapi/latest/docs) to handle eventual consistency instead of arbitrary `time_sleep` delays. The AzAPI provider supports configurable retry with `retry` blocks that can match on specific error codes, providing a more reliable and efficient approach.
