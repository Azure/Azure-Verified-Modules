---
title: Telemetry
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Microsoft uses the approach detailed in this section to identify the deployments of the AVM Modules. Microsoft collects this information to provide the best experiences with their products and to operate their business. Telemetry data is captured through the built-in mechanisms of the Azure platform; therefore, it never leaves the platform, providing only Microsoft with access. Deployments are identified through a specific GUID (Globally Unique ID), indicating that the code originated from AVM. The data is collected and governed by Microsoft's privacy policies, located at the [Trust Center](https://www.microsoft.com/trust-center).

Telemetry collected as described here does not provide Microsoft with insights into the resources deployed, their configuration or any customer data stored in or processed by Azure resources deployed by using code from AVM. Microsoft does not track the usage/consumption of individual resources using telemetry described here.

{{< hint type=note >}}

While telemetry gathered as described here is only accessible by Microsoft, Customers have access to the exact same deployment information on the Azure portal, under the Deployments section of the corresponding scope (Resource Group, Subscription, etc.).

See [View deployment history with Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history?tabs=azure-portal) for further information on how.

{{< /hint >}}

<br>

## Technical Details

As detailed in [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) each AVM module contains a `avmTelemetry` deployment, which creates a deployment such as `46d3xbcp.res.compute-virtualmachine.1-2-3.eum3` (for Bicep) or `46d3xgtf.res.compute-virtualmachine.1-2-3.eum3` (for Terraform).

<br>

## Opting Out

Albeit telemetry described in this section is optional, the implementation follows an opt-out logic, as most commercial software solutions, this project also requires continuously demonstrating evidence of usage, hence the AVM core team recommends leaving the telemetry setting on its default, enabled configuration.

This resource enables the AVM core team to query the number of deployments of a given module from Azure - and as such, get insights into its adoption.

To opt out you can set the parameters/variables listed below to `false` in the AVM module:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

<br>

## Telemetry vs Customer Usage Attribution

Though similar in principles, this approach is not to be confused and does not conflict with the usage of CUA IDs that are used to track [Azure customer usage attribution](https://learn.microsoft.com/partner-center/marketplace/azure-partner-customer-usage-attribution) of Azure marketplace solutions (partner solutions). The GUID-based telemetry approach described here can coexist and can be used side-by-side with CUA IDs. If you have any partner or customer scenarios that require the addition of CUA IDs, you can customize the AVM modules by adding the required CUA ID deployment while keeping the built-in telemetry solution.

{{< hint type=tip >}}

If you're a partner and want to build a solution that tracks customer usage attribution (using a CUA ID), we recommend implementing it on the consuming template's level (i.e., the multi-module solution, such as workload/application) and apply the required naming format `'pid-'` (without the suffix).

{{< /hint >}}
