---
title: Custom CI Secrets
description: Custom CI Secrets in the Bicep Modules of the Azure Verified Modules (AVM) program
---

When working on a module, and more specifically its e2e deployment validation test cases, it may be necessary to leverage tenant-specific information such as:

- Entra-ID-provided Enterprise Application object ids (e.g., Backup Management Service, Azure Databricks, etc.)
- (sensitive) principal credentials (e.g., a custom service principal's application id and secret)

The challenge with the former is that the value would be different from the contributor's test tenant compared to the Upstream AVM one. This requires the contributor to temporarily change the value to their own tenant's value during the contribution's creation & testing, and for the reviewer to make sure the value is changed back before merging a PR in.
The challenge with the later is more critical as it would require the contributor to store sensitive information in source control and as such publish it.

To mitigate this challenge, the AVM CI provides you with the feature to store any such information in a custom Azure Key Vault and automatically pass it into your test cases in a dynamic & secure way.

{{% notice style="important" %}}

Since all modules must pass the tests in the AVM environment, it is important that you inform the maintainers when you add a new custom secret. The same secret must then also be set up in the upstream environment **before** the pull request is merged.

To make this matter not too complicated, we would like to ask you to emphasize this requirement in the description of your PR, for example by adding a text similar to:

```txt
- [ ] @avm-core-team-technical-bicep TODO: Add custom secret 'mySecret' to AVM CI
```

{{% /notice %}}

## Example use case

Let's assume you need a tenant-specific value like the object id of Azure's _Backup Management Service_ Enterprise Application for one of your tests. As you want to avoid hardcoding and consequently changing its value each time you want to contribute from your Fork to the main AVM repository, you want to instead have it be automatically pulled into your test cases.

To do so, you create a new parameter in your test case's `main.test.bicep` file that you call, for example,

```bicep
@secure()
param backupManagementServiceEnterpriseApplicationObjectId string = ''

```

assuming that it would be provided with the correct value by the AVM CI. You consequently reference it in your test case as you would with any other Bicep parameter.

Next, you create a new secret of the same name with a prefix `CI-` in a previously created Azure Key Vault of your test subscription (e.g., `CI-backupManagementServiceEnterpriseApplicationObjectId`). Its value would be the object id the Enterprise Application has in the tenant of your test subscription.

Assuming that also the `CI_KEY_VAULT_NAME` GitHub Repository variable is configured correctly, you can now run your test pipeline and observe how the CI automatically pulls the secret and passes it into your test cases, IF, they have a parameter with a matching name.

## Setup

### Pre-Requisites

To use this feature, there are really only three prerequisites:

1. Create an Azure Key Vault in your test subscription
1. Grant the principal you use for testing in the CI at least _`Key Vault Secrets User'_ permissions on that Key Vault to enable it to pull secrets from it
1. Configure the name of that Key Vault as a 'Repository variable' `CI_KEY_VAULT_NAME` in your Fork.

The above will enable the CI to identify your Key Vault, look for matching secrets in it, and pull their values as needed.

![RequiredGitHubVariable]({{% siteparam base %}}/images/contribution/secrets/kvltSecret-ghSetting.png "Required GitHub variable")

### Configuring a secret

Building upon the prerequisites you only have to implement two actions per value to dynamically populate them during deployment validation:

1. Create a `@secure()` parameter in your test file (`main.test.bicep`) that you want to populate and use it as you see fit.

  For example:

  ```bicep
  @description('Required. My parameter\'s description. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-MySecret\'.')
  @secure()
  param mySecret string = ''
  ```

  {{% notice style="important" %}}

  It is mandatory to declare the parameter as `secure()` as Key Vault secrets will be pulled and passed into the deployment as `SecureString` values.

  Also, it **must** have an empty default to be compatible with the PSRule scans that require a value for all parameters.
  {{% /notice %}}

1. Configure a secret of the same name, but with a `CI-` prefix and corresponding value in the Azure Key Vault you set up as per the prerequisites.

  ![ExampleSecretsInKeyVault]({{% siteparam base %}}/images/contribution/secrets/kvltSecret-exampleSecrets.png "Example secrets in Key Vault")

## How it works

Assuming you completed both the [prerequisites](#pre-requisites) & [setup](#configuring-a-secret) steps and triggered your module's workflow, the CI will perform the following actions:

1. When approaching the deployment validation steps, the workflow will lookup the `CI_KEY_VAULT_NAME` repository variable
1. If it has a value, it will subsequently pull all available secret references (not their values!) from that Key Vault, filtered down to only the secrets that match the `CI-` prefix
1. It will then loop through these secret references and check if any match a parameter in the targeted `test.main.bicep` of the same name, but without the `CI-` prefix
1. Only for a match, the workflow with then pull the secret from the Key Vault and pass its value as a `SecureString` as a parameter into the template deployment.

When reviewing the log during or after a run, you can see each matching and pulled secret is/was added as part of the `AdditionalParameters` object as seen in the following:

![ExamplePipelineLog]({{% siteparam base %}}/images/contribution/secrets/kvltSecret-pipelineLog.png "Example pipeline log")

## Background: Why not simply use GitHub secrets?

When reviewing the above, you may wonder why an Azure Key Vault was used as opposed to simple GitHub secrets.

While the simplicity of GitHub secrets would be preferred, it unfortunately turned out that they would not provide us with the level of flexibility we need for our purposes.

Most notably, GitHub secrets are not automatically available in referenced GitHub actions. Instead, you have to declare every secret you want to use explicitly in the workflow's template, requiring the contributor to update both the module's workflow template as well as test files each time a new value would be added.
This characteristic is not only unfortunate for our use case, but is also a lot more likely to lead to mistakes.

Further, with the use of OIDC via Managed Identities, the hurdle to bootstrap & populate an Azure Key Vault is significantly lowered.
