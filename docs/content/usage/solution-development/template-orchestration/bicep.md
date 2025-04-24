---
title: Bicep - Template Orchestration
linktitle: Bicep
type: default
weight: 1
description: Bicep template orchestration for the Azure Verified Modules (AVM) solution development. It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

## TOC

- Intro and Architecture Diagram
  - What I want to do
- Starting
  - Prerequisites
  - Additional helpers like bicepconfig.json
  - create the VM
  - describe what you need to add to the VM
  - Iterate for additional services
    - modules
- 80/20
  - parameters vs. variables vs. hard-coded
  - modules
  - testing
  - naming
  - passing in resources
  - VNet peering
  - permissions (passing in account ids for RBAC)

## Introduction

Azure Verified Modules (AVM) for Bicep are a powerful tool that leverage the Bicep DSL, industry knowledge, and an Open Source community, which all together enable developers to quickly deploy Azure resources that follow Microsoft's cloud best practices.

In this tutorial, we will:

- Deploy a basic Virtual Machine architecture into Azure
- Discuss best-practices relating to Bicep template development
- Demonstrate the ease with which you can deploy resources using AVM
- Describe in detail, each of the development and deployment steps as we encounter them

After completing this tutorial, you will have a working knowledge of the following:

- How to discover and add AVM modules to your bicep template
- How to reference and use outputs across AVM modules
- Best-practices regarding parameteriation and structure of your bicep file
- Configuration of AVM modules to meet Microsoft's Well Architected Framework (WAF) principals
- How to deploy your bicep template into an Azure subscription from your local machine

The methodology we use in this tutorial will introduce you to various concepts in a step-by-step manner. You'll notice after each section, we will run a deployment of the template and view our results in Azure. This will allow us to start with simple concepts and build up to a full-fledged deployment. It will also allow you to easily pick up where you leave off if you need to take a break.

Let's get started!

## Prerequisites

TODO: insert prereqs here or link to another page? Also include how to authenticate into az cli so we don't have to repeat that during the tutorials

## Solution Architecture

**Mission Statement**: Deploy a single Linux VM into Azure.

**Business Requirements**: The solution must be secure and auditable.

**Technical Requirements**: The VM must not be accessible from the Internet, should be automatically patched, and and its logs should be easily accessible. Azure services should utilize logging tools for auditing purposes.

< this is a placeholder for the architecture >

Architecture: // TODO Tony to add a diagram

- monitoring
  - law
  - appinsights
- vnet (ipv4 for start)
  - subnets
  - nsgs
  - bastion
- Image Gallery
- VM
  - private pipv4+v6
  - maintenance schedule
  - metrics / dcr
- storage account
  - nfs for the vm
- key vault
  - ssh key

## Creating Our main.bicep File

Our architecture diagram shows everything we need to add to our template to be successful in our solution deployment. But instead of attempting to build a template that covers everything at once, we will build out our bicep template piece-by-piece and test our deployment as we progress. This will provide us the opportunity to discuss each step and decision we make as we proceed.

We are going to tackle the development of our bicep template beginning with the larger pieces that are core to the functionality of our platform. These are the **backend logging services** and the **virtual network**.

Let's begin by creating our folder structure along with a `main.bicep` file. Your folder structure should be as follows:

```text
VirtualMachineAVM_Example1/
└── main.bicep
```

After you have your folder structure and `main.bicep` file, we can proceed with adding our first AVM resources!

### Logging Services

We will start by adding a logging service to our `main.bicep` since everything else we deploy will use this service to save their logs to.

{{% notice style="tip" %}}It's always a good idea to start your template development by adding resources that create dependencies for other downstream services. This makes it easy to reference these dependencies within your other modules as you develop them.{{% /notice %}}

The logging solution depicted in our Architecture Diagram shows we will be using a Log Analytics Workspace. Let's go ahead and add that to our template. Open your `main.bicep` file and add the following:

```bicep
{{% include file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step1.bicep" %}}
```

Congratulations, you now have a fully-functional bicep template that will deploy a working Log Analytics Workspace! If you would like to try it, run the following in your console:

`az deployment group create --resource-group <resource-group-name> --template-file main.bicep`

AVM Makes the deployment of Azure resources incredibly easy. Many of the parameters you would normally be required to define are taken care of for you by the AVM module itself. In fact, notice how the `location` parameter is not even needed--if left blank, by default, all AVM modules will deploy to the location in which your target Resource Group exists.

So now we have a Log Anayltics workspace in our resource group which doesn't do a whole lot of good on its own. Let's take our template a step further by adding a Virtual Network that integrates with the Log Analytics Workspace.

### Virtual Network

We will now add a Virtual Network to our `main.bicep` file. This Vnet will contain subnets and network security groups for any of the resources we deploy that require IP addresses.

In your `main.bicep` file, add the following:

```bicep
{{% include file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step2.bicep" %}}
```

Again, notice how the Virtual Network AVM module requires only two things: a `name` and an `addressPrefixes` parameter. This template is also fully-deployable on its own, but let's make a simple change to it first. There is an additional parameter available in *most* AVM modules named `diagnosticSettings`. This parameter allows you configure your service to send its logs to any suitable logging service. In our case, we are using a Log Analytics Workspace.

Let's update our `main.bicep` file to have our VNet send all of its logging data to our Log Analytics Workspace:

```bicep
{{% include file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step3.bicep" %}}
```

Notice how the `diagnosticsSettings` parameter needs a `workspaceResourceId`? All you need to do is add a reference to the built-in `logAnalyticsWorkspaceId` output of the logAnalyticsWorkspace AVM module. That's it! Our VNet now has integrated its logging with our Log Analytics Workspace. All AVM modules come with an assortment of built-in `outputs` that can be easily referenced by other modules within your template.

{{% notice style="info" %}}All AVM modules have built-in outputs which can be referenced using the `<moduleName>.outputs.<outputName>` syntax.

When using pure Bicep, many of these outputs would require multiple lines of code or knowledge of the correct object ID references to make in order to get at the desired output. AVM modules do much of this heavy-lifting for you by taking care of these complex tasks within the module itself, then exposing it to you through the module's outputs. <TODO: insert documentation on how to find module outputs here>{{% /notice %}}

We can't rightly do much with a Virtual Network without some subnets, so let's add a couple of subnets next. Per our Architecture, we will have two subnets: one for the Virtual Machine and one for the Bastion.

Add the following to your `main.bicep`:

```bicep
{{% include file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step4.bicep" %}}
```

As you can see, we have added a `subnets` property to our virtualNetwork module. The AVM `network/virtual-network` module supports the creation of subnets directly within the module itself.

We are also using a nice function provided by Bicep, the `cidrSubnet()` function <TODO: add link to this function documentation>. This makes it easy to declare CIDR blocks without having to calculate them on your own.

So far so good? Hold on a minute! Notice how we are reusing the same CIDR block `10.0.0.0/16` in multiple locations? Some of the astute of you may also notice we are defining the same `location` in two different  spots as well.

We're now at a point in the development of our `main.bicep` file where should leverage one of our first best practices:

{{% notice style="tip" %}}Use Bicep **variables** to define values that will be constant and reused with your template; use **parameters** anywhere you may need a modifiable value.{{% /notice %}}

Let's change our CIDR block to a variable and our location to a parameter, then reference those in our modules:

```bicep
{{% include file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step5.bicep" %}}
```

We now have a good basis of infrastructure to be utilized by the rest of the resources in our Architecture. Don't worry, we will come back to our networking in a future step once we are ready to create some Network Security Groups, but for now let's move on to some other modules.

### Key Vault

<!-- The Linux VM is created in a new Virtual Network respecting the Well Architected Framework. This means, I need to add NSGs to the subnet, a maintenance configuration, not public endpoints (why we will add an Azure Bastion as well) and other resources.

## Developing the template

Before we start to create the template, let's quickly check if you dev-environment is setup with everything we need:

// TODO link/copy from the Quickstart https://azure.github.io/Azure-Verified-Modules/usage/quickstart/bicep/#prerequisites

*Don't forget to add the *bicepconfig.json* file, which supports with warnings for outdated AVM versions.*

I decided to not put all code into one big bicep file, but to build it modular with multiple files.

// TODO for the website, show code blocks for e.g. VM. Then, for the usage, all codeblocks are added to a single bicep file.

{{% notice style="info" %}}
We'll skip comments to improve the readability, but strongly suggest working with comments and descriptions for your template.
{{% /notice %}}

We start with a minimal configuration, and extend the templates over time.

### The Virtual Machine

Codeing. Finally. I start with the VM.bicep file, add parameters and later create the main.bicep file that calls the VM template. I like to add default values for parameters.

{{% expand title="VM" %}}

```bicep
{{% include file="/content/usage/includes/bicep/deploy 1/VM.bicep" %}}
```

{{% /expand %}}

Right. For the VM, we need dependencies like the network. Let's add that as well.

### Virtual Network

Since we want to support IPV4 and IPV6 in this template, let's just add both (obviously, you can skip either).

Now here we see the template is quickly getting bigger and bigger. Let alone the NSGs, defining all rules taking more than 150 lines.

{{% expand title="networking.bicep" %}}

```bicep
{{% include file="/content/usage/includes/bicep/deploy 1/networking.bicep" %}}
```

{{% /expand %}}

You might have noticed that we have created an existing resource 'vm_nic'. The module for deploying the virtual machine does not supply the generated IP adresses, which we want to provide as output parameter. Therefore, a plain Bicep resource references the network interface of new VM and allows us to grab the IPs.

### Bringing it together

Deploying resources, requires a scope where the resouces will be deployed to. Often, it is necessary to change the scope for further deployments. E.g. resource groups are deployed to a subscription, whereas a VM is deployed into a resource group.

The two already existing bicep templates need to be orchestrated by a caller, which we'll call main.bicep. Also, we want the services to be deployed into separate resource groups.

{{% expand title="main.bicep" %}}

```bicep
{{% include file="/content/usage/includes/bicep/deploy 1/main.bicep" %}}
```

{{% /expand %}}

**Optimizations:**

For simplicity, we didn't make everything as configurable/automated as possible. Some of them are:

- use the environment tag to not delete the Disk/NIC with the VM in a production environment


// TODO - this needs to be covered

Missing:

- maintenance configuration
- key access
- Backup?
- monitoring -->
