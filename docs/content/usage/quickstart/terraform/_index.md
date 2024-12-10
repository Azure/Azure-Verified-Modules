---
title: Terraform Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}



## Introduction

This guide provides instructions for using an Azure Verified Module (AVM) as part of your Terraform workflow. By leveraging AVM modules, you can rapidly deploy and manage Azure infrastructure without having to write extensive code from scratch.

## Prerequisites

Before you begin, ensure you have the minimum following items on your development environment:

  - A recent version of the Terraform binaries installed. Official instructions for installing Terraform can be found on the official [Hashicorp installation page.](https://developer.hashicorp.com/terraform/install)
  - An Integrated Development Environment(IDE) application similar to Visual Studio Code for developing your module. Visual Studio Code will be used in these instructions and setup instructions for it can be found in the [product documentation here](https://code.visualstudio.com/docs/setup/setup-overview). //TODO: do we want to call out specific extensions that make using terraform easier?
  - A recent version of the Azure Command Line Interface(CLI) application. Terraform uses the Azure CLI to authenticate to Azure.  Installation instructions for the CLI can be found in the [Microsoft Learn documentation here.](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Module Discovery

There are two primary ways for locating published Terraform Azure Verified Modules. The official Terraform registry and the AVM website Terraform module index.

### Searching using the Terraform Registry

The simplest way to discover published AVM Terraform modules is to search the Terraform registry. Use the following steps to locate a specific module in the Terraform registry.

  - Use your web browser to go to the [latest version of the Terraform docs.](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
  - In the search bar at the top of the screen type **`avm`**. Optionally, append additional terms to narrow the search results. (i.e. **`avm keyvault`** for avm modules with keyvault in the name.)
  - Select **`see all`** to display the full list of published modules matching your search criteria.
  - Find the module you wish to use and select it from the search results.
  - **Please Note:** It is possible to discover other unofficial modules with avm in the name using this search method.  Look for the `Partner` tag in the module title as a way to determine if the module is part of the official set.

  ![Searching for avm on terraform registry and selecting desired module.](/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-tf-search-4-4.gif)

### Searching using the Azure Verified Modules (AVM) Website

Searching the Azure Verified Module indexes is the most complete way to discover published as well as planned modules. Use the following steps to locate a specific module on the AVM website.

  - Use your web browser to open the [AVM website at aka.ms/avm.](https://aka.ms/avm)
  - Expand the **Module Indexes** menu item and select the **Terraform** sub-menu item.
  - Select the menu item for the module type you are searching for. ([Resource](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/), [Pattern](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-pattern-modules/), or [Utility](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-utility-modules/)).  A detailed description of module classifications types can be found in the [AVM spec here.](https://azure.github.io/Azure-Verified-Modules/specs/shared/module-classifications/)
  - Select the **Published modules** link from the table of contents at the top of the page.
  - Press **ctl** + **f** to open the browsers find option. //todo: make sure this is consistent on all browsers and OS's
  - Enter a **search term** that describes the type of module you are looking for. (i.e. virtual machine)
  - **Move through the search results until you locate the desired module.**  If you are unable to find a published module, return to the table of contents and expand the **All modules** link to search both published and proposed modules.
  - After finding the desired module, select the **modules name link** to open it in the official Hashicorp Terraform registry.


## Create your new root module leveraging AVM

Now that you've located the module details, you can use the module content from the Terraform Registry to accelerate your development efforts in one of two ways. The first method is to duplicate a module example and edit it for your needs. This is useful if you're starting without any existing infrastructure and need to create supporting resources like resource groups as part of your deployment. The second method is to add the AVM module to an existing root module that already includes other resources. This method requires some knowledge of the resource(s) being deployed so that you can make choices about optional features configured within the module. Each deployment method includes a section below so that you can choose the method which fits your needs. (TODO: add links into the paragraph for each subsection so that users can jump to the desired option.)

### Creating a root module using AVM module examples

Use the following steps as a template for how to leverage examples for bootstrapping your new module. We will use the key vault resource module as an example, but in practice you may use whichever module applies to your scenario.

  - Locate and select the **Examples** drop down menu in the middle of the module page.
  - From the drop-down list select an example whose name most closely aligns with your scenario. (i.e. **default**)
  - When the example page loads, read the example description to determine if this is the desired example. If it is not, return to the module main page, and select a different example until you are satisfied that the example covers the scenario you are trying to deploy.
  - Scroll to the code block for the example and select the **Copy** button on the top right of the block to copy the content to the clipboard.
  - In your IDE (Visual Studio Code in our example), open the **main.tf** file for your new root module.
  - **Paste** the content from the clipboard into **main.tf**.
  - AVM examples frequently use naming and region selection modules to randomly generate a deployment region and unique names as well as default values for required fields. If you want to use a specific region or other custom resource values, remove the existing region and naming module calls and replace any template values with the new desired custom value.
  - Once any supporting resources such as resource groups have been modified, locate the module call for the AVM module. (i.e. **`module "keyvault"`**)
  - AVM module examples use dot notation for a relative reference that is useful during module testing. However, you will need to replace the relative reference with a source reference that points to the Terraform registry source location. In most cases, this source reference has been left as a comment in the module example to simplify replacing the existing source dot reference. Peform the following two actions to update the source:
    - Delete the existing source using a dot reference. (i.e. **`source = "../../"`**)
    - Uncomment the Terraform registry source reference by deleting the **#** sign at the start of the commented source line.  (i.e. **`source = "Azure/avm-res-keyvault-vault/azurerm"`**)
  - **Save** your main.tf file changes and then proceed to the guide section for running your module. (TODO: Add this as an inline link so the next sub section can be skipped.)

### Creating a root module by customizing the AVM module

Use the following steps as a guide for a custom implementation of an AVM Module. This instruction path assumes that you have an existing Terraform module file that you want to add the AVM module to.

  - Locate the **Provision Instructions** box on the right side of the module's registry page in your web browser.
  - Select the module template code from the code block and **Copy** it onto the clipboard.
  - Switch to your IDE and **Paste** the contents of the clipboard into your custom module .tf file. (**main.tf in our example**)
  - Return to the module's registry page in the browser and select the **Inputs** tab.
<<<<<<< HEAD
  - Review each input, and add the inputs with the desired target value to the module template. (i.e. **`name = "custom_name"`**)
  - Once you are satisfied that you've include all required inputs and any optional inputs, **Save** your file and continue to the next section.


## Implementing your module

Once module development is complete you can proceed to the implementation stage.  The following steps represent a basic Terraform workflow:

  - Open the command line and login to Azure using the Azure cli by executing the **`az login`** command. If your account has access to multiple tenants you may need to modify the command to **`az login --tenant <tenant id>`** where **`<tenant id>`** is the guid for the target tenant.
  - After logging in, select the **target subscription** from the list of subscriptions that you have access to.
  - Change directory to the directory where your completed terraform root module files reside.
  - Initialize your Terraform project by running **`terraform init`**. This command downloads the necessary modules and sets up the working directory.
  - Before applying the configuration, it is good practice to validate it to ensure there are no syntax errors by running **`terraform validate`**.
  - Run the **`terraform plan`** command to create an execution plan. This step shows what actions Terraform will take to reach the desired state defined in your configuration. Review the plan to ensure that only the desired actions are in the plan output.
  - Run **`terraform apply`** to apply the configuration and create the resources defined in your configuration file. This command will prompt you to confirm before making changes. If you are confident in your changes you can add the -auto-approve switch to bypass manual approval.  (i.e. **`terraform apply -auto-approve`**)
  - Once the install completes, validate that the infrastructure has been deployed as desired. Note that a local terraform.tfstate file and a state backup file have been created. The use of local state s is ok for small temporary configurations, but when doing production or long lived installations, the use of a remove state configuration is recommended. Remote state configuration is out of scope for this guide, but you can find details on its configuration in the [Microsoft Learn documentation.](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
  - If you need to tear down the infrastructure, use the **`terraform destroy`** command. This will remove all the resources created by your configuration.


Congratulations, you have successfully leveraged Terraform and AVM to deploy resources in Azure.


=======
  -
>>>>>>> 9062a9a6eb3419fac0e026adb406669346ab7e52


