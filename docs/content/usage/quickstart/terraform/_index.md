---
title: Terraform Quickstart
geekdocNav: true
geekdocAlign: left
geekdocToC: 2
geekdocAnchor: true
---

{{< toc >}}

## Introduction

This guide provides instructions for using an Azure Verified Module (AVM) as part of your Terraform workflow. By leveraging AVM modules, you can rapidly deploy and manage Azure infrastructure without having to write extensive code from scratch.

In this guide, we'll deploy a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) resource and generate and store key.

This article is written for a typical "infra-dev" user (cloud infrastructure professional) who is new to Azure Verified Modules and wants to learn how to deploy a module the easiest possible way using AVM. The user has a basic understanding of Azure and Terraform.

If you first need to learn Terraform, you can start by trying a [tutorial](https://developer.hashicorp.com/terraform/tutorials/azure-get-started) on the HashiCorp website or studying the [detailed documentation.](https://developer.hashicorp.com/terraform/docs)

## Prerequisites

For the best experience, you will need:

- [Visual Studio Code (VS Code)](https://code.visualstudio.com/docs/setup/setup-overview) to develop your solution.
- [Terraform CLI](https://developer.hashicorp.com/terraform/install) to deploy your Terraform modules. Make sure you have a recent version installed.
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) to authenticate to Azure.
- [Azure Subscription](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) to deploy your resources.

Before you begin, ensure you have the these tools installed in your development environment.

## Module Discovery

### Find your module

With our scenario in mind, we need to deploy a Key Vault resource and some of its child resources - e.g., a key. Let's find the AVM module that will help us achieve this.

There are two primary ways for locating published Terraform Azure Verified Modules:

- Searching the [official Terraform registry](https://registry.terraform.io/), and
- Browsing the[AVM Terraform module index](https://aka.ms/avm/moduleindex/terraform).

#### Use the Terraform Registry

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-tf-qs-discovery-1080-10.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

The simplest way to discover published AVM Terraform modules is to search the Terraform registry. As shown in the video above, use the following steps to locate a specific module in the Terraform registry.

- Use your web browser to go to the [HashiCorp Terraform Registry](https://registry.terraform.io/)
- In the search bar at the top of the screen type **avm**. Optionally, append additional search terms to narrow the search results. (e.g., **avm keyvault** for AVM modules with keyvault in the name.)
- Select **see all** to display the full list of published modules matching your search criteria.
- Find the module you wish to use and select it from the search results.
  {{< hint >}} It is possible to discover other unofficial modules with **avm** in the name using this search method. Look for the **`Partner`** tag in the module title as a way to determine if the module is part of the official set. {{< /hint >}}

#### Use the AVM Terraform Module Index

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/module-index_tf_res_1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Searching the Azure Verified Module indexes is the most complete way to discover published as well as planned and proposed modules. As shown in the video above, use the following steps to locate a specific module on the AVM website:

- Use your web browser to open the AVM website at [https://aka.ms/avm](https://aka.ms/avm).
- Expand the **Module Indexes** menu item and select the **Terraform** sub-menu item.
- Select the menu item for the module type you are searching for: [Resource](/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/), [Pattern](/Azure-Verified-Modules/indexes/terraform/tf-pattern-modules/), or [Utility](/Azure-Verified-Modules/indexes/terraform/tf-utility-modules/).
  {{< hint >}}Since the Key Vault module used as an example in this guide is published as an AVM resource module, it can be found under the [resource modules](/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/) section in the AVM Terraform module index.{{< /hint >}}
- A detailed description of each module classification type can be found under the related section [here](/Azure-Verified-Modules/specs/shared/module-classifications/).
- Select the **Published modules** link from the table of contents at the top of the page.
- Use the in-page search feature of your browser (in most Windows browsers you can access it using the `CTRL` + `F` keyboard shortcut).
- Enter a **search term** to find the module you are looking for - e.g., Key Vault.
- **Move through the search results until you locate the desired module.** If you are unable to find a published module, return to the table of contents and expand the **All modules** link to search both published and proposed modules - i.e., modules that are planned, likely in development but not published yet.
- After finding the desired module, click on the **module's name**. This link will lead you to the official Hashicorp Terraform registry page for the module where you can find the module's documentation and examples.

### Module details and examples

Once you have identified the AVM module in the Terraform Registry you can find detailed information about the module’s functionality, components, input parameters, outputs and more. The documentation also provides comprehensive usage examples, covering various scenarios and configurations.

Explore the Key Vault module’s documentation and usage examples to understand its functionality, input variables, and outputs.

  - Note the **Examples** drop-down list and explore each example
  - Review the **Readme** tab to see module provider minimums, a list of resources and data sources used by the module, a nicely formatted version of the inputs and outputs, and a reference to any submodules that may be called.
  - Explore the [**Inputs**](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest?tab=inputs) tab and observe how each input has a detailed description and a type definition for you to use when adding input values to your module configuration.
  - Explore the [**Outputs**](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest?tab=outputs) tab and review each of the outputs that are exported by the AVM module for use by other modules in your deployment.
  - Finally, review the [**Resources**](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest?tab=resources) tab to get a better understanding of the resources defined in the module.

In our example, we want to deploy a secret in a new Key Vault instance without needing to provide other parameters. The AVM Key Vault resource module provides these capabilities, and does so with security and reliability being core principles. The default settings of the module also apply the recommendations of the Well Architected Framework where possible and appropriate.

Note how the [**create-key**](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest/examples/create-key) example seems to do what we want to achieve.

## Create your new template using AVM

Now that you've located the module details, you can use the module content from the Terraform Registry to accelerate your development efforts in one of two ways:

1. Option 1: [Create a root module using AVM module examples](#option-1-create-a-root-module-using-avm-module-examples): duplicate a module example and edit it for your needs. This is useful if you're starting without any existing infrastructure and need to create supporting resources like resource groups as part of your deployment.
1. Option 2: [Create a root module by updating the AVM module input values](#option-2-create-a-root-module-by-changing-the-avm-module-input-values): add the AVM module to an existing root module that already includes other resources. This method requires some knowledge of the resource(s) being deployed so that you can make choices about optional features configured within the module.

Each deployment method includes a section below so that you can choose the method which best fits your needs.

### Option 1: Create a root module using AVM module examples

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-tf-qs-example-copy-1080-10.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Use the following steps as a template for how to leverage examples for bootstrapping your new module. We will use the key vault resource module as an example, but in practice you may use whichever module applies to your scenario.

- Locate and select the **Examples** drop down menu in the middle of the module page.
- From the drop-down list select an example whose name most closely aligns with your scenario - e.g., **create-key**.
- When the example page loads, read the example description to determine if this is the desired example. If it is not, return to the module main page, and select a different example until you are satisfied that the example covers the scenario you are trying to deploy. If you are unable to find a suitable example, leverage the last two steps in the [option 2](#option-2-create-a-root-module-by-changing-the-avm-module-input-values) instructions to modify the inputs of the selected example to match your requirements.
- Scroll to the code block for the example and select the **Copy** button on the top right of the block to copy the content to the clipboard.

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-tf-qs-example-vscode-1080-10.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

- In your IDE - Visual Studio Code in our example - open the **main.tf** file for your new root module.
- **Paste** the content from the clipboard into **main.tf**.
- AVM examples frequently use naming and/or region selection Terraform modules to generate deployment region and/or naming values as well as any default values for required fields. If you want to use a specific region or other custom resource values, remove the existing region and naming module calls and replace example input values with the new desired custom input values.
- Once supporting resources such as resource groups have been modified, locate the module call for the AVM module - i.e., **`module "keyvault"`**.
- AVM module examples use dot notation for a relative reference that is useful during module testing. However, you will need to replace the relative reference with a source reference that points to the Terraform registry source location. In most cases, this source reference has been left as a comment in the module example to simplify replacing the existing source dot reference. Peform the following two actions to update the source:
  - Delete the existing source definition that uses a dot reference - i.e., **`source = "../../"`**.
  - Uncomment the Terraform registry source reference by deleting the **#** sign at the start of the commented source line - i.e., **`source = "Azure/avm-res-keyvault-vault/azurerm"`**.
- AVM module examples use a variable to enable or disable the telemetry collection. Update the **`enable_telemetry`** input value to **true** or **false**. -e.g. **`enable_telemetry = true`**
- **Save** your `main.tf` file changes and then proceed to the guide section for running your module.

### Option 2: Create a root module by changing the AVM module input values

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-tf-qs-custom-full-1080-10.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Use the following steps as a guide for a custom implementation of an AVM Module. This instruction path assumes that you have an existing Terraform module file that you want to add the AVM module to.

- Locate the **Provision Instructions** box on the right side of the module's registry page in your web browser.
- Select the module template code from the code block and **Copy** it onto the clipboard.
- Switch to your IDE and **Paste** the contents of the clipboard into your custom module's .tf file - **`main.tf`** in our example.
- Return to the module's registry page in the browser and select the **Inputs** tab.
- Review each input, and add the inputs with the desired target value to the module template - i.e., **`name = "custom_name"`**.
- Once you are satisfied that you've include all required inputs and any optional inputs, **Save** your file and continue to the next section.
  {{< hint >}} For the Azure Key Vaults, the name must be globally unique. When you deploy the key vault, ensure you select a name that is alphanumeric, twenty-four characters or less, and unique enough to ensure no one else has used the name for their key vault. If the name has been used previously, you will get an error. {{< /hint >}}

## Deploy your module

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/terraform/avm-qs-tf-commands-1080-10.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Once module development is complete you can proceed to the deployment stage. The following steps represent a basic Terraform workflow:

- Open the command line and login to Azure using the Azure cli
  ```terraform
  az login
  ```
- If your account has access to multiple tenants you may need to modify the command to **`az login --tenant <tenant id>`** where **`<tenant id>`** is the guid for the target tenant.
- After logging in, select the **target subscription** from the list of subscriptions that you have access to.
- Change directory to the directory where your completed terraform root module files reside.

{{< hint >}} Some modules depend on the AzureRM 4.0 provider which mandates that a subscription id is configured for the provider. If you receive an error indicating that **`subscription_id is a required provider property`** then you will need to set a subscription id value for the provider. For unix based systems (linux or mac) you can configure this by running **`export ARM_SUBSCRIPTION_ID=<your subscription guid>`**. On Microsoft Windows, you can perform the same operation by running **`set ARM_SUBSCRIPTION_ID="<your subscription guid>"`** from the Windows command prompt or by running **`$env:ARM_SUBSCRIPTION_ID="<your subscription guid>"`** from a powershell prompt. Replace **"<your subscription id">** with your Azure subscription's unique id value in each command.  {{< /hint >}}

- Initialize your Terraform project. This command downloads the necessary modules and sets up the working directory.
  ```terraform
  terraform init
  ```
- Before applying the configuration, it is good practice to validate it to ensure there are no syntax errors.
  ```terraform
  terraform validate
  ```
- Create a deployment plan. This step shows what actions Terraform will take to reach the desired state defined in your configuration.
  ```terraform
  terraform plan
  ```
- Review the plan to ensure that only the desired actions are in the plan output.
- Apply the configuration and create the resources defined in your configuration file. This command will prompt you to confirm the deployment prior to making changes. Type **yes** to apply the module's infrastructure.
  ```terraform
  terraform apply
  ```

{{< hint >}}If you are confident in your changes you can add the `-auto-approve` switch to bypass manual approval: `terraform apply -auto-approve`{{< /hint >}}

- Once the deployment completes, validate that the infrastructure is configured as desired.

{{< hint >}}A local `terraform.tfstate` file and a state backup file have been created during the deployment. The use of local state is acceptable for small temporary configurations, but production or long-lived installations should use a remote state configuration where possible. Configuring remote state is out of scope for this guide, but you can find details on using an Azure storage account for this purpose in the [Microsoft Learn documentation](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli).{{< /hint >}}

## Clean up your environment

When you are read you can remove the infrastructure deployed in this example. The following command will remove all resources created by your configuration:

```terraform
terraform destroy
```
{{< hint >}}Most key vault deployment examples activate soft-delete functionality as a best practice. The terraform destroy command will remove the key vault resource but does not purge a soft-deleted vault. You may encounter errors if you attempt to re-depoy a key vault with the same name during the soft-delete retention window.{{< /hint >}}

Congratulations, you have successfully leveraged Terraform and AVM to deploy resources in Azure!

{{< hint >}}
We welcome your contributions and feedback to help us improve the AVM modules and the overall experience for the community.
{{< /hint >}}
