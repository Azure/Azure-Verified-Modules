---
title: Bicep - Solution Development
linktitle: Bicep
type: default
weight: 1
description: Bicep solution development for the Azure Verified Modules (AVM). It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

## Introduction

Azure Verified Modules (AVM) for Bicep are a powerful tool that leverage the Bicep domain-specific language (DSL), industry knowledge, and an Open Source community, which altogether enable developers to quickly deploy Azure resources that follow Microsoft's recommended practices for Azure.

In this tutorial, we will:

- Deploy a basic Virtual Machine architecture into Azure
- Discuss recommended practices related to Bicep template development
- Demonstrate the ease with which you can deploy resources using AVM
- Describe each of the development and deployment steps in detail as we encounter them

After completing this tutorial, you will have a working knowledge of the following:

- How to discover and add AVM modules to your Bicep template
- How to reference and use outputs across AVM modules
- Recommended practices regarding parameterization and structure of your Bicep file
- Configuration of AVM modules to meet Microsoft's Well Architected Framework (WAF) principles
- How to deploy your Bicep template into an Azure subscription from your local machine

Let's get started!

## Prerequisites

{{% include file="/content/usage/includes/bicep-prerequisites.md" %}}

Make sure you have these tools set up before proceeding.

## Solution Architecture

**Mission Statement**: Deploy a single Linux VM into Azure.

**Business Requirements**: The solution must be secure and auditable.

**Technical Requirements**: The VM must not be accessible from the internet and its logs should be easily accessible. All azure services should utilize logging tools for auditing purposes.

<img src="{{% siteparam base %}}/images/usage/solution-development/avm-virtualmachine-example1.png" alt="Azure VM Solution Architecture" style="max-width:800px;" />

## Creating Our main.bicep File

Our architecture diagram shows everything we need to add to our template to be successful in our solution deployment. But instead of attempting to build a solution template that covers everything at once, we will build out our Bicep file piece-by-piece and test our deployment as we progress. This will provide us the opportunity to discuss each step and decision we make as we proceed.

We are going to tackle the development of our Bicep template beginning with the larger pieces that are core to the functionality of our platform. These are the **backend logging services** (Log Analytics) and the **virtual network**.

Let's begin by creating our folder structure along with a `main.bicep` file. Your folder structure should be as follows:

```text
VirtualMachineAVM_Example1/
└── main.bicep
```

After you have your folder structure and `main.bicep` file, we can proceed with adding our first AVM resources!

### Log Analytics

We will start by adding a logging service to our `main.bicep` since everything else we deploy will use this service to save their logs to.

{{% notice style="tip" %}}
It's always a good idea to start your template development by adding resources that create dependencies for other downstream services. This makes it easy to reference these dependencies within your other modules as you develop them. In more a more concrete example, we are starting with Logging and Virtual Network services since all other services we deploy will depend on these.
{{% /notice %}}

The logging solution depicted in our Architecture Diagram shows we will be using a Log Analytics workspace. Let's add that to our template! Open your `main.bicep` file and add the following:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step1.bicep" lang="bicep" line_anchors="vm-step1" >}}
{{% /expand %}}

{{% notice style="note" %}}
Always click on the "Copy to clipboard" button in the top right corner of the Code sample area in order not to have the line numbers included in the copied code.
{{% /notice %}}

You now have a fully-functional Bicep template that will deploy a working Log Analytics workspace! If you would like to try it, run the following in your console:

{{% tabs title="Deploy with" groupid="scriptlanguage" %}}
  {{% tab title="PowerShell" %}}

  ```powershell
  # Log in to Azure
  Connect-AzAccount

  # Select your subscription
  Set-AzContext -SubscriptionId '<subscriptionId>'

  # Deploy a resource group
  New-AzResourceGroup -Name 'avm-bicep-vmexample1' -Location '<location>'

  # Invoke your deployment
  New-AzResourceGroupDeployment -DeploymentName 'avm-bicep-vmexample1-deployment' -ResourceGroupName 'avm-bicep-vmexample1' -TemplateFile '/<path-to>/VirtualMachineAVM_Example1/main.bicep'
  ```

  {{% /tab %}}
  {{% tab title="AZ CLI" %}}

  ```bash
  # Log in to Azure
  az login

  # Select your subscription
  az account set --subscription '<subscriptionId>'

  # Deploy a resource group
  az group create --name 'avm-bicep-vmexample1' --location '<location>'

  # Invoke your deployment
  az deployment group create --name 'avm-bicep-vmexample1-deployment' --resource-group 'avm-bicep-vmexample1' --template-file '/<path-to>/VirtualMachineAVM_Example1/main.bicep'
  ```

  {{% /tab %}}
{{% /tabs %}}

The above commands will log you in to your Azure subscription, select a subscription to use, create a resource group, then deploy the `main.bicep` template to your resource group.

AVM Makes the deployment of Azure resources incredibly easy. Many of the parameters you would normally be required to define are taken care of for you by the AVM module itself. In fact, notice how the `location` parameter is not even needed in your template---when left blank, by default, all AVM modules will deploy to the location in which your target Resource Group exists.

Now we have a Log Analytics workspace in our resource group which doesn't do a whole lot of good on its own. Let's take our template a step further by adding a Virtual Network that integrates with the Log Analytics workspace.

### Virtual Network

We will now add a Virtual Network to our `main.bicep` file. This VNet will contain subnets and network security groups (NSGs) for any of the resources we deploy that require IP addresses.

In your `main.bicep` file, add the following:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step2.bicep" lang="bicep" line_anchors="vm-step2" hl_lines="11-22" >}}
{{% /expand %}}

Again, notice how the Virtual Network AVM module requires only two things: a `name` and an `addressPrefixes` parameter. There is an additional parameter available in *most* AVM modules named `diagnosticSettings`. This parameter allows you configure your resource to send its logs to any suitable logging service. In our case, we are using a Log Analytics workspace.

Let's update our `main.bicep` file to have our VNet send all of its logging data to our Log Analytics workspace:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step3.bicep" lang="bicep" line_anchors="vm-step3" hl_lines="21-26" >}}
{{% /expand %}}

Notice how the `diagnosticsSettings` parameter needs a `workspaceResourceId`? All you need to do is add a reference to the built-in `logAnalyticsWorkspaceId` output of the logAnalyticsWorkspace AVM module. That's it! Our VNet now has integrated its logging with our Log Analytics workspace. All AVM modules come with a set of built-in `outputs` that can be easily referenced by other modules within your template.

{{% notice style="info" %}}
All AVM modules have built-in outputs which can be referenced using the `<moduleName>.outputs.<outputName>` syntax.

When using plain Bicep, many of these outputs would require multiple lines of code or knowledge of the correct object ID references to make in order to get at the desired output. AVM modules do much of this heavy-lifting for you by taking care of these complex tasks within the module itself, then exposing it to you through the module's outputs. Find out more about [Bicep Outputs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell).
{{% /notice %}}

We can't do much with a Virtual Network without subnets, so let's add a couple of subnets next. According to our Architecture, we will have two subnets: one for the Virtual Machine and one for the Bastion.

Add the following to your `main.bicep`:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step4.bicep" lang="bicep" line_anchors="vm-step-4" hl_lines="27-36" >}}
{{% /expand %}}

As you can see, we have added a `subnets` property to our virtualNetwork module. The AVM `network/virtual-network` module supports the creation of subnets directly within the module itself.

We are also using a nice function provided by Bicep, the [`cidrSubnet()`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-cidr#cidrsubnet) function. This makes it easy to declare CIDR blocks without having to calculate them on your own.

Notice how we are reusing the same CIDR block `10.0.0.0/16` in multiple location? You may also notice we are defining the same `location` in two different spots as well. We're now at a point in the development where we should leverage one of our first recommended practices: using variables!

{{% notice style="tip" %}}
Use Bicep **variables** to define values that will be constant and reused with your template; use **parameters** anywhere you may need a modifiable value.
{{% /notice %}}

Let's change our CIDR block to a variable, add a `prefix` variable, and switch `location` to a parameter with a default value, then reference those in our modules:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step5.bicep" lang="bicep" line_anchors="vm-step5" hl_lines="1 3 4 10 12 23 25 35 39" >}}
{{% /expand %}}

We now have a good basis of infrastructure to be utilized by the rest of the resources in our Architecture. We will come back to our networking in a future step once we are ready to create some Network Security Groups. For now, let's move on to other modules.

### Key Vault

Key Vaults are one of the *key* components in most Azure architectures as they create a place where you can save and reference secrets in a secure manner ("secrets" in the general sense, as opposed to the `secret` object type in Key Vaults). The Key Vault AVM module makes it very simple to store secrets generated in your template. In this tutorial, we will use one of the most secure methods of storing and retrieving secrets by leveraging this Key Vault in our Bicep template.

The first step is easy: add the Key Vault AVM module to our `main.bicep` file. In addition, let's also ensure it's hooked into our Log Analytics workspace (we will do this for every new module from here on out).

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step6.bicep" lang="bicep" line_anchors="vm-step6" hl_lines="45-58" >}}
{{% /expand %}}

You may notice the name of the Key Vault we will deploy uses the `uniqueString()` Bicep function. Key Vault names must be globally unique. We will therefore deviate from our standard naming convention thus far and make an exception for the Key Vault. Note how we are still adding a suffix to the Key Vault name so its name remains recognizable; you can use a combination of concatenating unique strings, prefixes, or suffixes to follow your own naming standard preferences.

When we generate our unique string, we will pass in the `resourceGroup().id` as the seed for the `uniqueString()` function so that every time you deploy this `main.bicep` to the same resource group, it will use the same randomly-generated name for your Key Vault (since `resourceGroup().id` will be the same).

{{% notice style="tip" %}}
Bicep has many built-in functions available. We used two here: `uniqueString()` and `resourceGroup()`. The `resourceGroup()`, `subscription()`, and `deployment()` functions are very useful when seeding `uniqueString()` or `guid()` functions. Just be cautious about name length limitations for each Azure service! Visit [this page](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions) to learn more about Bicep functions.
{{% /notice %}}

We will use this Key Vault later on, when we create a VM and need to store its password. Now that we have it, a Virtual Network, and Log Analytics prepared, we should have everything we need to deploy a Virtual Machine!

{{% notice style="info" %}}
In the future, we will update this guide to show how to generate and store a certificate in the Key Vault, then use that certificate to authenticate into the Virtual Machine.
{{% /notice %}}

### Virtual Machine

{{% notice style="warning" %}}
The AVM Virtual Machine module enables the `EncryptionAtHost` feature by default. You must enable this feature within your Azure subscription successfully deploy this example code. To do so, run the following:

{{% tabs title="Deploy with" groupid="scriptlanguage" %}}
  {{% tab title="PowerShell" %}}

  ```powershell
  # Wait a few minutes after running the command to allow it to propagate
  Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"
  ```

  {{% /tab %}}
  {{% tab title="AZ CLI" %}}

  ```bash
  az feature register --namespace Microsoft.Compute --name EncryptionAtHost

  # Propagate the change
  az provider register --namespace Microsoft.Compute
  ```

  {{% /tab %}}
{{% /tabs %}}

{{% /notice %}}

For our Virtual Machine (VM) deployment, we need to add the following to our `main.bicep` file:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" lang="bicep" line_anchors="vm-step7" hl_lines="4-6 65-70 75-116" >}}
{{% /expand %}}

The VM module is one of the more complex modules in AVM---behind the scenes, it takes care of a *lot* of heavy lifting that, without AVM, would require multiple Bicep resources to be deployed and referenced.

For example, look at the `nicConfigurations` parameter: normally, you would need to deploy a separate NIC resource, which itself also requires an IP resource, then attach them to each other, and finally, attach them all to your VM.

With the AVM VM module, the `nicConfigurations` parameter accepts an object, allowing you to create any number of NICs to attach to your VM from *within* the VM resource deployment itself. It handles all the naming, creation of other necessary dependencies, and attaches them all together, so you don't have to. The `osDisk` parameter is similar, though slightly less complex. There are many more parameters within the VM module that you can leverage if needed, that share a similar ease-of-use.

Since this is the real highlight of our `main.bicep` file, we need to take a closer look at some of the other changes that were made.

- **VM Admin Password Parameter**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="add-password-param" lang="bicep" line_anchors="vm-pw-param" >}}

  First, we added a new parameter. The value of this will be provided when the `main.bicep` template is deployed. We don't want any passwords stored as text in code; for our purposes, the safest way to do this is to prompt the end user for the password at the time of deployment.

  {{% notice style="warning" %}}
The supplied password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following: Contains an uppercase character; Contains a lowercase character; Contains a numeric digit; Contains a special character. Control characters are not allowed
  {{% /notice %}}

  Also note how we are using the `@secure()` decorator on the password parameter. This will ensure the value of the password is never displayed in any of the deployment logs or in Azure. We have also added the `@description()` decorator and started the description with "Required." It's a good habit and recommended practice to document your parameters in Bicep. This will ensure that VS Code's built-in Bicep linter can provide end-users insightful information when deploying your Bicep templates.

  {{% notice style="info" %}}
Always use the `@secure()` decorator when creating a parameter that will hold sensitive data!
  {{% /notice %}}

- **Add the VM Admin Password to Key Vault**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="add-keyvault-secret" lang="bicep" hl_lines="27-32" line_anchors="vm-keyvault-pw" >}}

  The next thing we have done is save the value of our `vmAdminPass` parameter to our Key Vault. We have done this by adding a `secrets` parameter to the Key Vault module. Adding secrets to Key Vaults is very simple when using the AVM module.

  By adding our password to the Key Vault, it will ensure that we never lose the password and that it is stored securely. As long as a user has appropriate permissions on the vault, the password can be fetched easily.

- **Reference the VM Subnet**
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step7.bicep" id="vm-subnet-reference" lang="bicep" hl_lines="9" line_anchors="vm-subnet" >}}

  Here, we reference another built-in output, this time from the AVM Virtual Network module. This example shows how to use an output that is part of an array. When the Virtual Network module creates subnets, it automatically creates a set of pre-defined outputs for them, one of which is an array that contains each subnet's `subnetResourceId`. Our VM Subnet was the second one created which is position `[1]` in the array.

  Other AVM modules may make use of arrays to store outputs. If you are unsure what type of outputs a module provides, you can always reference the [Outputs](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/README.md#Outputs) section of each module's README.md.

### Storage Account

The last major component we need to add is a Storage Account. Because this Storage Account will be used as a backend storage to hold blobs for the hypothetical application that runs on our VM, we'll also create a blob container within it using the same AVM Storage Account module.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step8.bicep" lang="bicep" hl_lines="115-137" line_anchors="vm-storageaccount" >}}
{{% /expand %}}

We now have all the major components of our Architecture diagram built!

The last steps we need to take to meet our Business and Technical requirements is to ensure our networking resources are secure and that we are using least privileged access by leveraging Role Based Access Control (RBAC). Let's get to it!

### Network Security Groups

We'll add Network Security Groups (NSGs) to both of our subnets. These act as layer 3 and layer 4 firewalls to our networking resources. At the same time, we will add appropriate Inbound and Outbound rules so they only allow necessary traffic.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step9.bicep" lang="bicep" hl_lines="56-226 45 50" line_anchors="vm-nsg" >}}
{{% /expand %}}

The NSG Rules set for the Bastion Subnet are default, [required rules](https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg#apply) that allow the Azure Bastion service to function.

For our VM Subnet, we are blocking all internet-based SSH traffic and only allowing HTTP/S traffic from the internet and SSH traffic from within our Virtual Network.

### Disable Public Access to Storage Account

Because our Storage Account is a backend resource that only our Virtual Machine should have access to, we will secure it as much as possible. We'll do this by adding a Private Endpoint to it and disable public internet access. AVM makes creating and assigning Private Endpoints to resources incredibly easy. Take a look:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step10.bicep" lang="bicep" hl_lines="52-55 322-323 332-337 341-353" line_anchors="vm-pes" >}}
{{% /expand %}}

First, we added a new Subnet to our `virtualNetwork` module to hold our Private Endpoints. It is a recommended practice to have a dedicated subnet to hold all of your Private Endpoints.

Next, we added a new `privateEndpoints` parameter---just a few lines of code--to our `storageAccount` module. This will take care of all the heavy-lifting in creating a new Private Endpoint and associating it with our VNet, attaching it to the resource, etc. This is a burdensome task if using plain Bicep and would require 2x to 5x more code to accomplish. AVM drastically simplifies the creation of Private Endpoints for just about every Azure Resource that supports them.

In addition, we've disabled all public network connectivity to our Storage Account to ensure the only traffic it can receive is over the Private Endpoint.

The last thing we have done is add a Private DNS zone and linked it to our VNet. The Private DNS zone is required so that our VM can resolve the new Private IP address that is associated with our Storage Account.

### Bastion

In order to securely access our Virtual Machine without exposing its SSH port to the public internet is to create an Azure Bastion host.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step11.bicep" lang="bicep" hl_lines="335-348" line_anchors="vm-bastion" >}}
{{% /expand %}}

All we have done is add the `bastion-host` AVM module to our template and ensured that it is associated with our Virtual Network.

{{% notice style="info" %}}
Azure Bastion requires a dedicated subnet with the name `AzureBastionSubnet`. We already created a subnet with that exact name in our `virtualNetwork` module. When this Azure Bastion host is created, it will use that subnet automatically.
{{% /notice %}}

### RBAC

To complete our solution, we have one final task: to apply RBAC restrictions on our services, namely the Key Vault and Storage Account. The idea is we explicitly allow certain serviecs to have Create, Read, Update, or Delete (CRUD) permissions. In our architecture, we only want the Virtual Machine to have this level of access.

We will accomplish this by enabling a System-assigned Managed Identity on the Virtual Machine, then grant the VM's Managed Identity appropriate permissions on the Storage Account and Key Vault.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step12.bicep" lang="bicep" hl_lines="293-295 321-327 244-250" line_anchors="vm-rbac" >}}
{{% /expand %}}

{{% notice style="info" %}}
The Azure Subscription owner will have CRUD permissions for the Storage Account but not for the Key Vault. The Key Vault requires explicit RBAC permissions assigned to a user to grant them access: [Provide access to Key Vaults using RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-portal). **Important!**: at this point you will only be able to access the Storage Account from the Bastion Host. Remember, we disabled public internet access!
{{% /notice %}}

We have successfully applied RBAC policies by using a System-assigned Managed Identity on our Virtual Machine. We then assigned that Managed Identity permissions on the Key Vault and Storage Account. Our VM can now read secrets from the Key Vault and Read, Create, or Delete blobs in our Storage Account.

Remember that in a real production environment, you would not only use RBAC to limit access to each service, but you would also apply the principle of Least Privileged Access, meaning you would only provide the exact permissions each service needs to carry out its functions. Learn more about Microsoft's [recommendations for identity and access management](https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access).

## Conclusion

In this tutorial, we've explored how to leverage Azure Verified Modules (AVM) to build a secure, well-architected solution in Azure. AVM modules significantly simplify the deployment of Azure resources by abstracting away much of the complexity involved in configuring individual resources.

Your final, deployable Bicep template file should now look like this:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\bicep\VirtualMachineAVM_Example1\steps\step12.bicep" lang="bicep" line_anchors="vm-final" >}}
{{% /expand %}}

AVM modules provide several key advantages over writing raw Bicep templates:

1. **Simplified Resource Configuration**: AVM modules handle much of the complex configuration work behind the scenes
2. **Built-in Recommended Practices**: The modules implement many of Microsoft's recommended practices by default
3. **Consistent Outputs**: Each module exposes a consistent set of outputs that can be easily referenced
4. **Reduced Boilerplate Code**: What would normally require hundreds of lines of Bicep code can be accomplished in a fraction of the space

As you continue your journey with Azure and AVM, remember that this approach can be applied to more complex architectures as well. The modular nature of AVM allows you to mix and match components to build solutions that meet your specific needs while adhering to Microsoft's Well-Architected Framework.

By using AVM modules as building blocks, you can focus more on your solution architecture and less on the intricacies of individual resource configurations, ultimately leading to faster development cycles and more reliable deployments.

## Clean up your environment

When you are ready, you can remove the infrastructure deployed in this example. Key Vaults are set to a soft-delete state so you will also need to **purge** the one we created in order to fully delete it. The following commands will remove all resources created by your deployment:

{{% tabs title="Clean up with" groupid="scriptlanguage" %}}
  {{% tab title="PowerShell" %}}

  ```powershell
  # Delete the resource group
  Remove-AzResourceGroup -Name "avm-bicep-vmexample1" -Force

  # Purge the Key Vault
  Remove-AzKeyVault -VaultName "<keyVaultName>" -Location "<location>" -InRemovedState -Force
  ```

  {{% /tab %}}
  {{% tab title="AZ CLI"%}}

  ```bash
  # Delete the resource group
  az group delete --name 'avm-bicep-vmexample1' --yes --no-wait

  # Purge the Key Vault
  az keyvault purge --name '<keyVaultName>' --no-wait
  ```

  {{% /tab %}}
{{% /tabs %}}

Congratulations, you have successfully leveraged an AVM Bicep module to deploy resources in Azure!

{{% notice style="tip" %}}
We welcome your contributions and feedback to help us improve the AVM modules and the overall experience for the community!
{{% /notice %}}
