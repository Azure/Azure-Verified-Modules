---
title: Custom CI Parameters
description: Custom CI parameters from GitHub Actions secrets and variables for Azure Verified Modules (AVM) Bicep tests
---

Use GitHub Actions secrets or variables to supply environment-specific inputs to your `main.test.bicep` end-to-end tests, such as tenant-specific object IDs or credentials. This avoids hardcoding values that differ between your fork and the upstream AVM test environment. Never commit private values to test files.

These are additional template inputs, not Azure login credentials. Continue using OIDC with the `avm-validation` environment and its `VALIDATE_CLIENT_ID`, `VALIDATE_TENANT_ID`, and `VALIDATE_SUBSCRIPTION_ID` secrets, as described in [Authentication secrets]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#312-authentication-secrets).

{{% notice style="important" title="Forks and upstream validation" %}}

Configure values separately in your fork: upstream repository and environment secrets are not inherited. This feature does not bypass GitHub's restrictions on secret availability for workflows triggered by contributions from forks.

When adding a required input, ask the maintainers to configure the corresponding GitHub secret or variable in the upstream environment before merging your contribution. Share the parameter name and purpose, never its private value.

{{% /notice %}}

## Setup

Declare the parameters in your `main.test.bicep` file and reference them as normal Bicep parameters. Keep an empty default for these string inputs so PSRule scans have a value for every parameter.

For example:

```bicep
@description('Required. Credential supplied by the CI_MY_SECRET GitHub Actions secret.')
@secure()
param mySecret string = ''

@description('Optional. Non-sensitive label used by this test.')
param deploymentLabel string = ''
```

Add the corresponding values under **Settings > Secrets and variables > Actions** in your repository, or under **Settings > Environments > avm-validation** for environment-scoped values:

| GitHub Actions name | Store as | Template parameter | Value |
| - | - | - | - |
| `CI_MY_SECRET` | Secret | `mySecret` | Set privately; do not put the value in source control or logs. |
| `CI_DEPLOYMENT_LABEL` | Variable | `deploymentLabel` | For example, the non-sensitive label `avm-ci`. |

GitHub secret and variable names cannot contain hyphens. Prefer readable `CI_` names for usual camelCase parameters; reserve `CI__` for literal parameter names, including underscores.

With `CI_`, the CI strips the single prefix and removes **all suffix underscores** before matching. With `CI__`, it strips the double prefix and **preserves suffix underscores**. Both modes match actual declared test parameters case-insensitively and pass their canonical Bicep spelling. Only matching parameters are supplied.

These are alternative spellings; choose one name for each input:

| GitHub Actions name | Matching template parameter |
| - | - |
| `CI_ADMIN_MEMBERS_SECRET` | `adminMembersSecret` |
| `CI_ADMINMEMBERSSECRET` | `adminMembersSecret` |
| `CI__ADMIN_MEMBERS_SECRET` | `admin_members_secret`, not `adminMembersSecret` |
| `CI__ADMINMEMBERSSECRET` | `adminMembersSecret` |
| `CI___NAME` | `_name` |

**Reserved name:** `CI_KEY_VAULT_NAME` remains the existing vault selector and is excluded from template input mapping. To supply a test parameter named `keyVaultName`, use `CI__KEYVAULTNAME`.

String inputs, including secure strings, are used as supplied. For Boolean, integer, array, and object parameters (including secure objects), supply valid JSON matching the compiled template parameter type.

{{% notice style="important" title="Protect sensitive inputs" %}}

Use GitHub secrets for private values, and variables only for clearly non-sensitive configuration. Keep `@secure()` on sensitive Bicep parameters. The CI converts secure strings to PowerShell `SecureString` values and parses secure objects into dictionaries, preserving the template's ARM `secureObject` declaration. This also applies to inputs from GitHub variables. Neither `@secure()` nor these conversions make a GitHub variable's stored value private.

{{% /notice %}}

## How it works

Workflows use the resolved GitHub `secrets` and `vars` contexts. Both repository-scoped and environment-scoped values are supported; GitHub applies its own scope precedence within each context. Use the same GitHub spelling across scopes when overriding an input so GitHub can apply that scope precedence to the override.

After name resolution, values for the same template parameter are selected in this order:

**`CI_` secret > `CI__` secret > `CI_` variable > `CI__` variable > `CI-` Key Vault secret.**

Source priority comes first: a `CI__` secret still beats a `CI_` variable. Within one source category (secrets or variables), `CI_` wins over `CI__` when both resolve to the same parameter; for example, secret `CI_FOO` beats secret `CI__FOO` for `foo`.

Multiple aliases for the same parameter within a source category's winning prefix remain ambiguous and fail. For example, secrets `CI_ADMIN_MEMBERS_SECRET` and `CI_ADMINMEMBERSSECRET` both resolve to `adminMembersSecret` through `CI_`; neither has priority over the other.

Names resolving to different declared parameters remain independent: `CI_ADMIN_MEMBERS_SECRET` supplies `adminMembersSecret`, while `CI__ADMIN_MEMBERS_SECRET` supplies `admin_members_secret`.

A configured empty winning value, including a `CI_` value, still wins and does not trigger fallback to a lower-priority prefix or source.

The CI passes the resolved values through the PowerShell `AdditionalParameters` object to the applicable `Test-Az*Deployment` and `New-Az*Deployment` cmdlets. This is runtime deployment parameter injection, not source token substitution or a `.bicepparam` file mechanism.

## Legacy Key Vault fallback

{{% notice style="warning" title="CI Key Vault support is deprecated" %}}

`vars.CI_KEY_VAULT_NAME` remains an optional fallback for existing setups. Using it emits a visible GitHub Actions deprecation warning, and support may be removed in a future release. Use GitHub Actions secrets or variables for new setups.

{{% /notice %}}

Existing setups can retain the `CI_KEY_VAULT_NAME` repository variable, the vault, and its `CI-`-prefixed secrets. The legacy `CI-` suffix is matched literally and case-insensitively, unchanged by the GitHub naming rules. The CI identity still needs permission to list and read secrets, for example through the `Key Vault Secrets User` role. Matching Key Vault secrets are used only when no GitHub secret or variable supplies that parameter; keep the corresponding Bicep parameters secure.

### Migrate existing inputs

1. Inventory the `CI-` secrets used by your test parameters and identify every workflow that depends on the vault. Prefer the [preview-only migration helper](#preview-with-the-migration-helper) for this inventory.
1. Map each source name to a readable GitHub `CI_` name, or a `CI__` name for literal underscores or a reserved-name conflict. For example, Key Vault secret `CI-mySecret` becomes GitHub secret `CI_MY_SECRET`, supplying `mySecret`.
1. Copy each value privately to the intended repository or environment scope. Default to a GitHub secret; choose a variable only after confirming the value is non-sensitive. Coordinate corresponding upstream inputs with the maintainers.
1. Confirm that all dependent workflows use the migrated inputs before removing `CI_KEY_VAULT_NAME`. Do not delete the vault or its secrets as part of this change without checking for other consumers.

#### Preview with the migration helper

{{% notice style="warning" title="Support is not released yet" %}}

The GitHub CI parameter support and migration helper are part of [Azure/bicep-registry-modules#7339](https://github.com/Azure/bicep-registry-modules/pull/7339). Wait until the implementation is available in your checkout and dependent workflows before applying a migration.

{{% /notice %}}

The `Copy-CIKeyVaultSecretsToGitHub` helper requires PowerShell 7.2 or later, an authenticated `Az.KeyVault` session, and the GitHub CLI authenticated to `github.com`. From a `bicep-registry-modules` checkout containing the helper, replace the placeholders and preview selected inputs:

```powershell
. .\utilities\tools\Copy-CIKeyVaultSecretsToGitHub.ps1
Copy-CIKeyVaultSecretsToGitHub -VaultName '<vault-name>' -Repository '<owner>/<repo>' `
  -Environment 'avm-validation' `
  -SecretName 'CI-mySecret', 'CI-deploymentLabel' `
  -VariableName 'CI_DEPLOYMENT_LABEL'
```

For new entries, the helper generates readable names from camelCase and acronyms: `CI-mySecret` becomes `CI_MY_SECRET`, `CI-deploymentLabel` becomes `CI_DEPLOYMENT_LABEL`, and `CI-managedHSMResourceId` becomes `CI_MANAGED_HSM_RESOURCE_ID`. Literal underscores or reserved-name conflicts use `CI__` spelling.

Without `-Apply`, the helper lists names and metadata only: it does not read secret values or change GitHub settings. `-SecretName` is a literal, case-insensitive allowlist of source `CI-` names; omitting it selects all `CI-` entries. `-VariableName` accepts either `CI_` or `CI__` aliases that resolve to selected source parameters explicitly confirmed as non-sensitive; all other values remain secrets. Prefer the planned readable output names, as in the example. Omit `-Environment` to target repository scope.

Review the preview and obtain explicit operator approval before adding `-Apply` to copy values. When selecting an existing destination entry of the same kind for a parameter, the helper also prefers `CI_` over `CI__`. It skips the winning entry by default and reuses and overwrites only that entry when `-Overwrite` is explicitly specified. Any losing `CI__` alias is left unchanged, not deleted. Ambiguity within the winning prefix and opposite-kind matches for the same parameter are blocked.

The helper never deletes entries and sends version-pinned values through standard input, not command arguments or files. Complete the workflow confirmation above before removing `CI_KEY_VAULT_NAME`.
