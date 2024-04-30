---
title: Known Issues
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Unfortunately there will be times where issues are out of the AVM core team and module owners/contributor's control and the issue may be something that has to be lived with for a longer duration than anyone would like, for example changes that are due to the way the Azure platform or a resource behaves or a IaC language issue.

This page will detail any of the known issues that consumers may come across when using AVM modules and provide links to learn more about them and where to get involved in discussions on these known issues with the rest of the community.

{{< hint type=important >}}

Please raise any issues with an AVM module should be raised on the repo they are hosted on, not the AVM Central (`Azure/Azure-Verified-Modules`) repo!

Although, if you think a known issue is missing from this page please create an issue on the AVM Central (`Azure/Azure-Verified-Modules`) repo.

*It's not an issue if you raise in the wrong place, we will transfer it to it's correct home 👍*

{{< /hint >}}

## Bicep

### Bicep what-if compatibility with modules

[Bicep/ARM What-If](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-what-if) has a known issue today where it short-circuits whenever a runtime function is used in a nested template. And due to the way [Bicep modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules) work, all module declarations in a Bicep file end up as a resulting nested template deployment in the underlying generated ARM template, thereby invoking this known issue.

{{< hint type=note icon=gdoc_github title="GitHub Issue for Further Information & Discussion" >}}

[`Azure/arm-template-whatif #157` - Resources in nested template not shown if reference is used in the parameter values](https://github.com/Azure/arm-template-whatif/issues/157)

{{< /hint >}}

The good news is that very recently the ARM/Bicep Product Group announced on the issue that they are still working and making progress in this space and hope to have some ETAs on it being available in the near future; see the comment [here](https://github.com/Azure/arm-template-whatif/issues/157#issuecomment-2083179814)

So whilst this isn't an AVM issue, we understand that consumers of AVM Bicep modules may want to use what-if and are running into this known issue. Please keep adding your support to the issue mentioned above (`Azure/arm-template-whatif #157`), as the Product Group are actively engaging in the discussion there 👍

{{< hint type=note icon=gdoc_github title="Other Related GitHub Issues" >}}

- [`Azure/Azure-Verified-Modules #797` - [AVM Question/Feedback]: Output of what-if (if any) can't be trusted](https://github.com/Azure/Azure-Verified-Modules/issues/797)

{{< /hint >}}

## Terraform

Currently there are no known issues for AVM Terraform modules 🥳


