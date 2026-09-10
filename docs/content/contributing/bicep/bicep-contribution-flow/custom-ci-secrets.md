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
@description('Required. Credential supplied by the CI_MYSECRET GitHub Actions secret.')
@secure()
param mySecret string = ''

@description('Optional. Non-sensitive label used by this test.')
param deploymentLabel string = ''
```

Add the corresponding values under **Settings > Secrets and variables > Actions** in your repository, or under **Settings > Environments > avm-validation** for environment-scoped values:

| GitHub Actions name | Store as | Template parameter | Value |
| - | - | - | - |
| `CI_MYSECRET` | Secret | `mySecret` | Set privately; do not put the value in source control or logs. |
| `CI_DEPLOYMENTLABEL` | Variable | `deploymentLabel` | For example, the non-sensitive label `avm-ci`. |

Use the `CI_` prefix in GitHub; GitHub secret and variable names cannot contain hyphens. The CI strips `CI_` and matches the remaining name to an actual template parameter **case-insensitively**, so `CI_MYSECRET` matches `mySecret`. Only inputs matching parameters declared in the current test template are passed to its deployment, using the declared spelling.

Underscores in the suffix are preserved, not converted to camelCase: `CI_ADMINMEMBERSSECRET` matches `adminMembersSecret`, whereas `CI_ADMIN_MEMBERS_SECRET` matches only `admin_members_secret`.

String inputs, including secure strings, are used as supplied. For Boolean, integer, array, and object parameters (including secure objects), supply valid JSON matching the compiled template parameter type.

{{% notice style="important" title="Protect sensitive inputs" %}}

Use GitHub secrets for private values, and variables only for clearly non-sensitive configuration. Keep `@secure()` on sensitive Bicep parameters. The CI converts secure parameters to the corresponding PowerShell secure types before deployment, including when an input comes from a GitHub variable. Adding `@secure()` does not make a GitHub variable's stored value private.

{{% /notice %}}

## How it works

Workflows use the resolved GitHub `secrets` and `vars` contexts. Both repository-scoped and environment-scoped values are supported; GitHub applies its own scope precedence within each context.

If more than one source supplies the same template parameter, the precedence is:

**GitHub secret > GitHub variable > `CI-` Key Vault secret.**

The CI passes the resolved values through the PowerShell `AdditionalParameters` object to the applicable `Test-Az*Deployment` and `New-Az*Deployment` cmdlets. This is runtime deployment parameter injection, not source token substitution or a `.bicepparam` file mechanism.

## Legacy Key Vault fallback

{{% notice style="warning" title="CI Key Vault support is deprecated" %}}

`vars.CI_KEY_VAULT_NAME` remains an optional fallback for existing setups. Using it emits a visible GitHub Actions deprecation warning, and support may be removed in a future release. Use GitHub Actions secrets or variables for new setups.

{{% /notice %}}

Existing setups can retain the `CI_KEY_VAULT_NAME` repository variable, the vault, and its `CI-`-prefixed secrets. The CI identity still needs permission to list and read secrets, for example through the `Key Vault Secrets User` role. Matching Key Vault secrets are used only when no GitHub secret or variable supplies that parameter; keep the corresponding Bicep parameters secure.

### Migrate existing inputs

1. Inventory the `CI-` secrets used by your test parameters and identify every workflow that depends on the vault.
1. Map each name to a GitHub `CI_` name matching the template parameter. For example, Key Vault secret `CI-mySecret` becomes GitHub secret `CI_MYSECRET`, supplying `mySecret`.
1. Copy each value privately to the intended repository or environment scope. Default to a GitHub secret; choose a variable only after confirming the value is non-sensitive. Coordinate corresponding upstream inputs with the maintainers.
1. Confirm that all dependent workflows use the migrated inputs before removing `CI_KEY_VAULT_NAME`. Do not delete the vault or its secrets as part of this change without checking for other consumers.
