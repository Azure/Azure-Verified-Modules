---
title: Terraform - Template Orchestration
linktitle: Terraform
type: default
weight: 2
description: Terraform template orchestration for the Azure Verified Modules (AVM) solution development. It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

## Introduction

Now that Terraform has been chosen as the IaC language, let's walk through the Terraform specific considerations and recommended practices on developing your solution leveraging Azure Verified Modules. We'll review some of the design trade-offs and include sample code to illustrate each discussion point.

## Planning

### Architecture

Before we begin coding, it is important to have details for what the infrastructure architecture will include. For our example, we will be building a solution that will host a simple application on a linux virtual machine (VM). This VM will require appropriate tagging to comply with our corporate standards and must send its log and metric data to a Log Analytics workspace so that the application and infrastructure support teams can properly manage the environment. It will also require outbound internet access to allow the application to properly function. A Key Vault will be included to store any secret and key artifacts and we will include a Bastion instance to allow support personnel to access the virtual machine if needed. Finally, the VM is intended to run without interaction so we will auto-generate an ssh private key and store it in the Key Vault for the rare event of someone needing to log in to it.

Based on this narrative we will create the following resources:

- A Resource Group for containing all the resources with tagging
- A random string resource for use in resources with global naming (Key Vault)
- A Log Analytics workspace for diagnostic data
- A Key Vault with:
  - RBAC to allow data access
  - Logging to the Log Analytics workspace
- A virtual network with:
  - A virtual machine subnet
  - A Bastion subnet
  - Logging to the Log Analytics workspace
- A NAT Gateway for enabling outbound internet access
  - Associated to the virtual machine subnet
  - logging to the Log Analytics workspace
- A virtual machine resource with
  - A single private IPv4 interface attached to the VM subnet
  - The Azure Monitor Agent configured to send logs to the Log Analytics workspace
  - A cloud init script to configure the virtual machine
  - A randomly generated admin account private key stored in the Key Vault
- Application insights?

**TODO: Attach a visualization of this configuration**

### Solution root module design

Since our solution template (root module) is intended to be deployed multiple times, we want to develop in a way that provides flexibility while minimizing the amount of input necessary to deploy the solution. To this end, we will create our module with a small set of variables that allow for differentiation when deploying while also populating solution-specific defaults to minimize overall input. We will also separate our content into `variables.tf`, `outputs.tf`, `terraform.tf`, and `main.tf` files to simplify future maintenance. Based on this, our filesystem will take the following structure:

- Module Directory
  - `terraform.tf` - This file holds the provider definitions and versions
  - `variables.tf` - This file contains the input variable definitions and defaults
  - `outputs.tf`   - This file contains the outputs and their descriptions for use by any external modules calling this root module
  - `main.tf`      - This file contains the core module code for creating the solutions infrastructure
  - `inputs.tfvars` - This file will contain the inputs for the instance of the module that is being deployed. Content in this file will vary from instance to instance.

In our example, we will use the following variables as inputs to allow for customization:

- prefix - this will be used to preface all of the resource naming
- virtual_network_prefixes - This will be used to ensure IP uniqueness for the deployment
- tags - the custom tags to use for each deployment
- cloud-init-script-content - the script to use for configuring the virtual machine ?

Finally, we will export the following outputs:

- resource_group_name - this will allow for finding this deployment if there are multiples
- virtual_machine_ip_address - This can be used to find and login to the vm if needed.

### Identifying AVM modules that match our solution

Now that we've determined our architecture and module configurations we need to see what AVM modules exist for use in our solution. To do this, we need to open the AVM Terraform [pattern module index](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-pattern-modules/) and check if there are any existing pattern modules that match our requirement. In this case, no pattern modules fit our need. If this was a common pattern we could open an issue on the AVM github repository to get assistance from the AVM project to create a pattern module matching our requirements. Since our architecture isn't common, we'll continue to the next step.

When a pattern module fitting our need doesn't exist for a solution, leveraging AVM resource modules to build our own solution is the next best option. Review the AVM Terraform [published resource module index](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/) for each of the resource types included in your architecture. For each AVM module, capture a link to the module to allow for a review of the documentation details on the Terraform Registry website.

{{% notice style="note" %}}
Many of the published pattern modules cover multi-resource configurations that can sometimes be interpreted as a single resource. Be sure to check the pattern index for groups of resources that may be part of your architecture and that don't exist in the resource module index. (e.g. Virtual WAN)
{{% /notice %}}

For our sample architecture we have the following AVM resource modules at our disposal:

- [Resource Group](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm/latest)
- [Log Analytics Workspace](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/latest)
- [Key Vault](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest)
- [Virtual Network](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/latest)
- [NAT Gateway](https://registry.terraform.io/modules/Azure/avm-res-network-natgateway/azurerm/latest)
- [Virtual Machine](https://registry.terraform.io/modules/Azure/avm-res-compute-virtualmachine/azurerm/latest)

## Develop the Solution Code

