---
title: Bicep - Template Orchestration
linktitle: Bicep
type: default
weight: 1
description: Bicep template orchestration for the Azure Verified Modules (AVM) solution development. It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

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

**Technical Requirements**: The VM must not be accessible from the Internet and its logs should be easily accessible. All azure services should utilize logging tools for auditing purposes.

< this is a placeholder for the architecture diagram >

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

{{% notice style="tip" %}}It's always a good idea to start your template development by adding resources that create dependencies for other downstream services. This makes it easy to reference these dependencies within your other modules as you develop them. In more a more concrete example, we are starting with Logging and Virtual Network services since all other services we deploy will depend on these.{{% /notice %}}

The logging solution depicted in our Architecture Diagram shows we will be using a Log Analytics Workspace. Let's go ahead and add that to our template. Open your `main.bicep` file and add the following:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step1.bicep" lang="bicep" line_anchors="vm-step1" >}}
{{% /expand %}}

Congratulations, you now have a fully-functional bicep template that will deploy a working Log Analytics Workspace! If you would like to try it, run the following in your console:

`az deployment group create --resource-group <resource-group-name> --template-file main.bicep`

AVM Makes the deployment of Azure resources incredibly easy. Many of the parameters you would normally be required to define are taken care of for you by the AVM module itself. In fact, notice how the `location` parameter is not even needed--if left blank, by default, all AVM modules will deploy to the location in which your target Resource Group exists.

So now we have a Log Anayltics workspace in our resource group which doesn't do a whole lot of good on its own. Let's take our template a step further by adding a Virtual Network that integrates with the Log Analytics Workspace.

### Virtual Network

We will now add a Virtual Network to our `main.bicep` file. This Vnet will contain subnets and network security groups for any of the resources we deploy that require IP addresses.

In your `main.bicep` file, add the following:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step2.bicep" lang="bicep" line_anchors="vm-step2" hl_lines="11-22" >}}
{{% /expand %}}

Again, notice how the Virtual Network AVM module requires only two things: a `name` and an `addressPrefixes` parameter. This template is also fully-deployable on its own, but let's make a simple change to it first. There is an additional parameter available in *most* AVM modules named `diagnosticSettings`. This parameter allows you configure your service to send its logs to any suitable logging service. In our case, we are using a Log Analytics Workspace.

Let's update our `main.bicep` file to have our VNet send all of its logging data to our Log Analytics Workspace:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step3.bicep" lang="bicep" line_anchors="vm-step3" hl_lines="21-31" >}}
{{% /expand %}}

Notice how the `diagnosticsSettings` parameter needs a `workspaceResourceId`? All you need to do is add a reference to the built-in `logAnalyticsWorkspaceId` output of the logAnalyticsWorkspace AVM module. That's it! Our VNet now has integrated its logging with our Log Analytics Workspace. All AVM modules come with an assortment of built-in `outputs` that can be easily referenced by other modules within your template.

{{% notice style="info" %}}All AVM modules have built-in outputs which can be referenced using the `<moduleName>.outputs.<outputName>` syntax.

When using pure Bicep, many of these outputs would require multiple lines of code or knowledge of the correct object ID references to make in order to get at the desired output. AVM modules do much of this heavy-lifting for you by taking care of these complex tasks within the module itself, then exposing it to you through the module's outputs. <TODO: insert documentation on how to find module outputs here>{{% /notice %}}

We can't rightly do much with a Virtual Network without some subnets, so let's add a couple of subnets next. Per our Architecture, we will have two subnets: one for the Virtual Machine and one for the Bastion.

Add the following to your `main.bicep`:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step4.bicep" lang="bicep" line_anchors="vm-step-4" hl_lines="32-41" >}}
{{% /expand %}}

As you can see, we have added a `subnets` property to our virtualNetwork module. The AVM `network/virtual-network` module supports the creation of subnets directly within the module itself.

We are also using a nice function provided by Bicep, the `cidrSubnet()` function <TODO: add link to this function documentation>. This makes it easy to declare CIDR blocks without having to calculate them on your own.

So far so good? Hold on a minute! Notice how we are reusing the same CIDR block `10.0.0.0/16` in multiple locations? Some of the astute of you may also notice we are defining the same `location` in two different  spots as well.

We're now at a point in the development of our `main.bicep` file where should leverage one of our first best practices:

{{% notice style="tip" %}}Use Bicep **variables** to define values that will be constant and reused with your template; use **parameters** anywhere you may need a modifiable value.{{% /notice %}}

Let's change our CIDR block to a variable, add a `prefix` variable, and switch `location` to a parameter, then reference those in our modules:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step5.bicep" lang="bicep" line_anchors="vm-step5" hl_lines="1 3 4 10 12 23 25 40 44" >}}
{{% /expand %}}

We now have a good basis of infrastructure to be utilized by the rest of the resources in our Architecture. Don't worry, we will come back to our networking in a future step once we are ready to create some Network Security Groups, but for now let's move on to some other modules.

### Key Vault

KeyVaults are one of the *key* components in any good Azure architecture as they create a place where you can save and reference secrets in a secure manner. Our architecture has a KeyVault in it, but it doesn't explicitly call out what the KeyVault will be used for.

In this tutorial, we will use one of the most secure methods of storage and retrieval of secrets by leveraging this KeyVault in our bicep template. The Key Vault AVM module makes it very simple to add secrets ("secrets" in the general sense, as opposed to the actual `secret` object type in Key Vaults).

Our first step is easy: add the KeyVault AVM module to our `main.bicep` file. We won't actually use the KeyVault for anything at the moment, but we will use it later when we create a VM and need to store its password. Let's add the KeyVault module and ensure it's hooked into our Log Analytics Workspace (we will do this for every new module from here on out):

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step6.bicep" lang="bicep" line_anchors="vm-step6" hl_lines="50-77" >}}
{{% /expand %}}

You may notice the name of the KeyVault we will deploy uses the `uniqueString()` bicep function. KeyVault names must be globally unique. We will therefore deviate from our standard naming convention thus far and make an exception for the KeyVault. Note how we are still adding a suffix to the KeyVault name so its name isn't just random gibberish; you can use a combination of concatenating unique strings, prefixes, or suffixes to abide by your own naming standard preferences.

When we generate our unique string, we will pass in the `resourceGroup().id` as the seed for the `uniqueString()` function so that every time you deploy this `main.bicep` to the same resource group, it will use the same randomly-generated name for your KeyVault (since `resourceGroup().id` will be the same).

{{% notice style="tip" %}}Bicep has many built-in functions available that can help you in all sorts of ways. We actually used two here: `uniqueString()` and `resourceGroup()`. The `resourceGroup()`, `subscription()`, and `deployment()` functions are very useful when seeding `uniqueString()` or `guid()` functions. Just be cautious about name length limitations for each Azure service! <TODO: add link to bicep functions page>{{% /notice %}}

Now that we have our KeyVault, Virtual Network, and Log Analytics prepared we should have everything we need to deploy a Virtual Machine!

### Virtual Machine

For our Virtual Machine (VM) deployment, we need to add the following to our `main.bicep` file:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" lang="bicep" line_anchors="vm-step7" hl_lines="4-6 83-88 93-135" >}}
{{% /expand %}}

The VM module is one of the more detailed modules in AVM--but behind the scenes, it takes care of a *lot* of heavy lifting that, without AVM, would require multiple bicep resources to be deployed and referenced.

For example, look at the `nicConfigurations` parameter: normally you would need to deploy a separate NIC resource, which itself also requires an IP resource, then attach each of those to eachother, then attach the whole thing to your VM.

With the AVM VM module, the `nicConfigurations` parameter accepts an object, allowing you to create any number of NICs to attach to your VM from *within* the VM resource deployment itself. It handles all the naming, creation of other necessary dependencies, and attaches them all together so you don't have to. The `osDisk` parameter is similar, though slightly less complex. There are many more parameters within the VM module that you can leverage if needed, that provide a similar ease-of-use.

Since this is the real meat of our `main.bicep` file, we need to take a closer look at some of the other changes that were made.

- **VM Admin Password Parameter**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="add-password-param" lang="bicep" line_anchors="vm-pw-param" >}}

  First, we added a new parameter. The value of this will be provided when the `main.bicep` template is deployed. We don't want any passwords stored as text in code; for our purposes, the safest way to do this is to have the user who is deploying the template provide the password.

  Also note how we are using the `@secure()` decorator on this parameter. This will ensure the value of the password is never displayed in any of the deployment logs or in Azure. We have also added the `@description()` decorator and started the description with "Required". It's a good habit and best practice to document your parameters in bicep. This will ensure the built-in bicep linter can provide users good information when deploying your bicep templates.

{{% notice style="info" %}}Always use the `@secure()` decorator when creating a parameter that will hold sensitive data!{{% /notice %}}

- **Add the VM Admin Password to KeyVault**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="add-keyvault-secret" lang="bicep" hl_lines="27-32" line_anchors="vm-keyvault-pw" >}}

  The next thing we have done is saved the value of our `vmAdminPass` parameter to our key vault. We have done this by adding a `secrets` parameter to the key vault module. Adding secrets to key vaults is very simple when using the AVM module.

  By adding our password to the key vault, it will ensure that we never lose the password and that it is stored securely. As long as a user has appropriate permissions on the vault, the password can be fetched easily.

- **Reference the VM Subnet**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="vm-subnet-reference" lang="bicep" hl_lines="9" line_anchors="vm-subnet" >}}

  Here, we reference another built-in output, this time from the AVM Virtual Network module. This example shows how to use an output that is part of an array. When the Virtual Network module creates subnets, it automatically creates a set of pre-defined outputs for the subnets, one of which is an array that contains each subnet's `subnetResourceId`. Our VM Subnet was the second one created, which is position `[1]` in the array.

  Other AVM modules may make use of arrays to store outputs. If you are unsure what type of outputs a module provides, you can always reference the [Outputs](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/README.md) section of each module's README.md.

### Storage Account

The last major component we need, per our architecture diagram, is the addition of a Storage Account. This storage account will be used as a backend storage to hold blobs for the hypothetical application that runs on our VM. We'll also go ahead and create a blob container within the AVM Storage Account module itself.

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step8.bicep" lang="bicep" hl_lines="132-154" line_anchors="vm-storageaccount" >}}
{{% /expand %}}

We finally have all the major components of our Architecture diagram built--well done!

The last steps we need to take to meet our Business and Technical requirements is to ensure our networked resources are secure and that we are using least privileged access by leveraging RBAC. Let's get to it.

### Network Security Groups

We'll begin by adding Network Security Groups (NSGs) to both of our subnets. These act as a layer 3 and 4 firewall to our networked resources. At the same time, we will add appropriate Inboud and Outbound rules so they only allow necessary traffic.

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step9.bicep" lang="bicep" hl_lines="56-226 45 50" line_anchors="vm-nsg" >}}
{{% /expand %}}

The NSG Rules set for the Bastion Subnet are default, [required rules](https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg#apply) that allow the Azure Bastion service to function.

For our VM Subnet, we are blocking all internet-based SSH traffic and only allowing HTTP/S traffic from the internet and SSH traffic from within our Virtual Network.

### Disable Public Access to Storage Account

Because our Storage Account is a backend resource that only our Virtual Machine should access, we will secure it as much as possible. We'll do this by adding a Private Endpoint to it and disable public internet access. AVM makes creating and adding Private Endpoints to resources incredibly easy. Take a look:

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step10.bicep" lang="bicep" hl_lines="52-55 322-323 332-337 341-353" line_anchors="vm-pes" >}}
{{% /expand %}}

First, we added a new Subnet to our `virtualNetwork` module to hold our Private Endpoints. It is best practice to have a dedicated subnet to hold all of your Private Endpoints.

Next, we added a new `privateEndpoints` parameter--just a few lines of code--to our `storageAccount` module. This will take care of all the heavy-lifting in creating a new Private Endpoint and associating it with your VNet, attaching it to the resource, etc. This is a burdensome task if using pure bicep and would require 5x as much code to accomplish. AVM drastically simplifies the creation of Private Endpoionts for just about every Azure Resource that supports them.

In addition, we've disabled all public network connectivity to our Storage Account to ensure the only traffic it can receive is over the Private Endpoint.

The last thing we have done is add a Private DNS zone and linked it to our VNet. The Private DNS zone is required so that our VM can resolve the new Private IP address that's associated with our Storage Account.

### Bastion

In order to securely access our Virtual Machine without exposing its SSH port to the public internet is to create an Azure Bastion host.

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step11.bicep" lang="bicep" hl_lines="335-348" line_anchors="vm-bastion" >}}
{{% /expand %}}

All we have done here is add the `bastion-host` AVM module to our template and ensured it is associated with our Virtual Network.

{{% notice style="info" %}}Azure Bastion requires a dedicated subnet with the name `AzureBastionSubnet`. We already created a subnet with that exact name in our `virtualNetwork` module. When this Azure Bastion host is created, it will use that subnet automatically.{{% /notice %}}

### RBAC

To complete our solution, we have one final task: to employ RBAC restrictions on our services, namely the Key Vault and Storage Account. The idea is that *only* the services we explicitly allow should have Create, Read, Update, or Delete (CRUD) permissions. In our architecture, we only want the Virtual Machine to have this level of access.

We will accomplish this by enabling a System-assigned Managed Identity on the Virtual Machine, then grant the VM appropriate permissions on the Storage Account and Key Vault using this Managed Identity.

{{% expand title="Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step12.bicep" lang="bicep" hl_lines="293-295 321-327 244-250" line_anchors="vm-rbac" >}}
{{% /expand %}}

{{% notice style="info" %}}
The Azure Subscription owner will have CRUD permissions and more. If you have the Owner role in your subscription, you'll still be able to read the contents of the Key Vault and Storage Account. **!Important!**: at this point you will only be able to access the storage account from the Bastion Host--remember, we disabled public internet access!{{% /notice %}}

For this scenario, we have successfully applied RBAC policies by using a System-assigned Managed Identity on our Virtual Machine. We then assigned that Managed Identity permissions on the Key Vault and Storage Account. Our VM can now read secrets from the Key Vault and Read, Create, or Delete blobs in our Storage Account.

Remember that in a real production environment, you would not only use RBAC to limit access to each service, but you would also employ Least Privileged Access, meaning you would only provide the exact permissions each service needs to carry out its functions. <TODO: Link to WAF stuff on LP access?>

## Recap

## Conclusion

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
