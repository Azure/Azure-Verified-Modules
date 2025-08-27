---
title: Known Issues
description: Known Issues for the Azure Verified Modules (AVM) program
---

Unfortunately, there will be times where issues are out of the AVM core team and module owners/contributor's control and the issue may be something that has to be lived with for a longer than ideal duration - for example, in case of changes that are due to the way the Azure platform, or a resource behaves, or because of an IaC language issue.

This page will detail any of the known issues that consumers may come across when using AVM modules and provide links to learn more about them and where to get involved in discussions on these known issues with the rest of the community.

{{% notice style="important" %}}

Issues related to an AVM module must be raised on the repo they are hosted on, not the AVM Central (`Azure/Azure-Verified-Modules`) repo!

Although, if you think a known issue is missing from this page please create an issue on the AVM Central [`Azure/Azure-Verified-Modules`](https://github.com/Azure/Azure-Verified-Modules/issues/new/choose) repo.

*If you accidentally raise an issue in the wrong place, we will transfer it to its correct home. 👍*

{{% /notice %}}

## Bicep

### Bicep what-if compatibility with modules

[Bicep/ARM What-If](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-what-if) has a known issue today where it short-circuits whenever a runtime function is used in a nested template. And due to the way [Bicep modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules) work, all module declarations in a Bicep file end up as a resulting nested template deployment in the underlying generated ARM template, thereby invoking this known issue.

{{% notice style="note" title="GitHub Issue for Further Information & Discussion" icon="fa-brands fa-github" %}}

[`Azure/arm-template-whatif #157` - Resources in nested template not shown if reference is used in the parameter values](https://github.com/Azure/arm-template-whatif/issues/157)

{{% /notice %}}

The ARM/Bicep Product Group has recently announced on the issue that they are making progress in this space and are aiming provide a closer ETA in the near future; see the comment [here](https://github.com/Azure/arm-template-whatif/issues/157#issuecomment-2083179814).

While this isn't an AVM issue, we understand that consumers of AVM Bicep modules may want to use `what-if` and are running into this known issue. Please keep adding your support to the issue mentioned above (`Azure/arm-template-whatif #157`), as the Product Group are actively engaging in the discussion there. 👍

{{% notice style="note" title="Other Related GitHub Issues" icon="fa-brands fa-github" %}}

- [`Azure/Azure-Verified-Modules #797` - [AVM Question/Feedback]: Output of what-if (if any) can't be trusted](https://github.com/Azure/Azure-Verified-Modules/issues/797)

{{% /notice %}}

### 4MB limitation

A well-known limitation of ARM and in extension Bicep is its template size constraint of 4MB (which roughly translates to the size of the compiled ARM template). While there is not anything one can do to change this limit there are actions you can take to reduce your template's size and make it less likely to run into this issue.

In the following we provide you with a list of options you should be aware of:

<details>
<summary>Use loops for multi-instance deployments</summary>

If you deploy multiple instances of the same module (e.g., DNS entries) you should invoke the module using a loop once, as opposed to separate references to the same module. The reason comes down the way that ARM interprets these references: Each reference of a module is restored to its full ARM size. That means, if you invoke the same module 3 separate time, you will find that this module's template is added 3 times as a nested deployment. If you use a loop instead, the reference is only added once and invoked as many times as your loop as entries.

For example, you should refactor the code
```bicep
targetScope = 'subscription'

@description('The principal to assign the roles to.')
param principalId string

module testDeployment1 'br/public:avm/res/authorization/role-assignment/sub-scope:0.1.0' = {
  params: {
    principalId: principalId
    roleDefinitionIdOrName: 'Contributor'
  }
}
module testDeployment2 'br/public:avm/res/authorization/role-assignment/sub-scope:0.1.0' = {
  params: {
    principalId: principalId
    roleDefinitionIdOrName: 'Role Based Access Control Administrator'
  }
}
```
to
```bicep
targetScope = 'subscription'

@description('The principal to assign the roles to.')
param principalId string

var rolesToAssign = [
  'Contributor'
  'Role Based Access Control Administrator'
]

module testDeployment 'br/public:avm/res/authorization/role-assignment/sub-scope:0.1.0' = [
  for role in rolesToAssign: {
    params: {
      principalId: principalId
      roleDefinitionIdOrName: role
    }
  }
]
```
instead. I this particular example, the compiled JSON for first example has a size of `18kb`, the second using a loop `10kb`.

</details>


<details>
<summary>Only use AVM if you benefit from its features</summary>

Using AVM modules can come with a lot of advantages compared to a native resource deployment. This can be as simple as being a 'module' deployment, enabling you to deploy to multiple scopes at once in the same template, all the way to encapsulating entire solution into a single invocation and hence drastically reducing the complexity of your own template.

However, they also come with certain limitations. For one, that you're dependent on the module providing you all the features you need, but moreover, that the very same features are always part of the module, whether you use them or not, hence contributing to your solution template's size.

With this in mind, our recommendation is to only use AVM modules if you use any of its features, hence justifying the contribution to your template's size.

Recommendations
- Only use the `br/public:avm/res/resources/resource-group` resource if you deploy resource groups with role assignments
- Only use the `br/public/avm/res|ptn/authorization/(...)` modules if you benefit from their scope flexibility
- When facing challenges with the template size, start replacing individual module references with their native counter-part under consideration of the size-reduction (considering large modules like API-Management, Storage Account, etc.) and the complexity of re-implementing the required features yourself. The good news: You can cherry-pick the parts of the AVM template you need.

</details>

<details>
<summary>Split the solution template</summary>
</details>

## Terraform

Currently there are no known issues for AVM Terraform modules. 🥳
