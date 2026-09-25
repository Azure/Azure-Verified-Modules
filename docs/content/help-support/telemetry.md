---
title: Telemetry
description: Telemetry description for the Azure Verified Modules (AVM) program
---

Microsoft uses the approach detailed in this section to identify the deployments of the AVM Modules. Microsoft collects this information to provide the best experiences with their products and to operate their business. Telemetry data is captured through the built-in mechanisms of the Azure platform; therefore, it never leaves the platform, providing only Microsoft with access. Deployments are identified by an AVM-specific prefix in their names. The data is collected and governed by Microsoft's privacy policies, located at the [Trust Center](https://www.microsoft.com/trust-center).

Telemetry collected as described here does not provide Microsoft with insights into the resources deployed, their configuration or any customer data stored in or processed by Azure resources deployed by using code from AVM. Microsoft does not track the usage/consumption of individual resources using telemetry described here.

{{% notice style="note" %}}

Telemetry gathered as described here is only accessible by Microsoft. Bicep customers can view the deployment in the Azure portal under Deployments at its corresponding scope (resource group, subscription, etc.). Terraform customers can view the generated deployment at the active subscription scope and inspect the exact values sent in `main.telemetry.tf`.

See [View deployment history with Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history?tabs=azure-portal) for further information on how.

{{% /notice %}}

## Technical Details

As detailed in [SFR3]({{% siteparam base %}}/spec/SFR3), an instrumented Bicep module creates an `avmTelemetry` deployment such as `46d3xbcp.res.compute-virtualmachine.1-2-3.eum3`. An instrumented Terraform module creates an empty, subscription-scoped deployment through the generated `azapi_resource.telemetry`. Its name contains the fixed `46d3xtrf` metadata prefix, the full installed version (or `0-0-0`), a one-letter source type (`t`, `o`, `g`, or `x`), and a stable four-character instance suffix. The name, not resource tags, carries the reporting data. A changing empty-template output causes a deployment write on each normal apply without changing the name; no raw source path or tier is sent.

Terraform's optional `telemetry_location` input controls where the subscription deployment record is stored. When the module declares `var.location`, the input defaults to `null` and the deployment uses `var.location` unless overridden. Otherwise the input defaults to `westus2`. Set it explicitly when the deployment must use another region, including sovereign clouds where `westus2` is unavailable. With telemetry enabled, the identity needs `Microsoft.Resources/deployments/read`, `Microsoft.Resources/deployments/write`, and `Microsoft.Resources/deployments/delete` at the subscription scope.

## Opting Out

Albeit telemetry described in this section is optional, the implementation follows an opt-out logic, as most commercial software solutions, this project also requires continuously demonstrating evidence of usage, hence the AVM core team recommends leaving the telemetry setting on its default, enabled configuration.

This resource enables the AVM core team to query the number of deployments of a given module from Azure - and as such, get insights into its adoption.

To opt out you can set the parameters/variables listed below to `false` in the AVM module:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

## Telemetry vs Customer Usage Attribution

Though similar in principles, this approach is not to be confused and does not conflict with the usage of CUA IDs that are used to track [Azure customer usage attribution](https://learn.microsoft.com/partner-center/marketplace/azure-partner-customer-usage-attribution) of Azure marketplace solutions (partner solutions). AVM deployment telemetry can coexist with CUA IDs. If you have any partner or customer scenarios that require the addition of CUA IDs, you can customize the AVM modules by adding the required CUA ID deployment while keeping the built-in telemetry solution.

{{% notice style="tip" %}}

If you're a partner and want to build a solution that tracks customer usage attribution (using a CUA ID), we recommend implementing it on the consuming template's level (i.e., the multi-module solution, such as workload/application) and apply the required naming format `'pid-'` (without the suffix).

{{% /notice %}}
