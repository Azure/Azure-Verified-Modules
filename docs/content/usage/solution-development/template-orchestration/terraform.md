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

Since our solution template (root module) is intended to be deployed multiple times, we want to develop in a way that provides flexibility while minimizing the amount of input necessary to deploy the solution. To this end, we will create our module with a small set of variables that allow for deployment differentiation while still populating solution-specific defaults to minimize input. We will also separate our content into `variables.tf`, `outputs.tf`, `terraform.tf`, and `main.tf` files to simplify future maintenance. Based on this, our filesystem will take the following structure:

- Module Directory
  - `terraform.tf` - This file holds the provider definitions and versions
  - `variables.tf` - This file contains the input variable definitions and defaults
  - `outputs.tf`   - This file contains the outputs and their descriptions for use by any external modules calling this root module
  - `main.tf`      - This file contains the core module code for creating the solutions infrastructure
  - `development.tfvars` - This file will contain the inputs for the instance of the module that is being deployed. Content in this file will vary from instance to instance.

{{% notice style="note" %}}
Terraform will merge content from any file ending in a .tf extension in the module folder to create the full module content. Because of this, using different files is not required. We encourage file separation to allow for organizing code in a way that makes it easier to maintain. While the naming structure we've used is common, there are many other valid file naming and organization options that can be used.
{{% /notice %}}

In our example, we will use the following variables as inputs to allow for customization:

- location - the location where our infrastructure will be deployed
- name_prefix - this will be used to preface all of the resource naming
- virtual_network_prefix - This will be used to ensure IP uniqueness for the deployment
- tags - the custom tags to use for each deployment
- cloud-init-script-content - the script to use for configuring the virtual machine TODO: decide if we want this complexity in the example

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

We will now code the solution one element at a time to allow us to test our deployment as we build it out.

### Creating the terraform.tf file

Let's begin with configuring the provider details necessary to build our solution. Since this is a root module, we want to include any provider and terraform version constraints for this module. We'll periodically come back and add any needed additional providers if our design includes a resource from a new provider.

Open up your development IDE (Visual studio code in our example) and create a file named `terraform.tf` in your root directory.

Add the following code to your `terraform.tf` file:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step1-terraform.tf" lang="terraform" line_anchors="sol-step1" hl_lines="1-5" >}}
{{% /expand %}}

This specifies that the required terraform binary version to run your module can be any version between 1.9 and 2.0. This is a good compromise for allowing a range of binary versions while also ensuring that versions support any required features that are used as part of the module. This can include things like newly introduced functions or support for new key words.

Since we are developing incrementally, we should validate our code. To do this we will execute the following steps:

1. Open up a terminal window if it is not already open. In some IDE's this can be done as a function of the IDE.
1. Change directory to the module directory by typing `cd` and then the path to the module. As an example, if the module directory was named `example` we would execute `cd example`.
1. Run `terraform init` to initialize your provider file.

You should now see a message indicating that `Terraform has been successfully initialized`. This indicates that our code is error free and we can continue on. If you get errors, examine the provider syntax for typos, missing quotes, or missing brackets.

### Creating a variables.tf file

Because our module is intended to be re-usable, we want to provide the capability to customize each module call with those items that will differ between them. This is done using variables to accept input into the module. We'll define those inputs in a separate file named `variables.tf`.

Go back to the IDE, and create a file named `variables.tf` in the working directory.

Add the following code to your `variables.tf` file to configure the inputs for our example:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step2-variables.tf" lang="terraform" line_anchors="sol-step2" hl_lines="1-22" >}}
{{% /expand %}}

{{% notice style="note" %}}
Note that each variable definition includes a type definition to guide module users on how to properly define an input. Also note that it is possible to set a default value. This allows module consumers to avoid setting a value if they find the default to be acceptable.
{{% /notice %}}

We should now test the new content we've created for our module. To do this, first re-run `terraform init` on your command line.  Note that nothing has changed and the initialization completes successfully. Since we now have module content, we will attempt to run the plan as the next step of the workflow.

Type `terraform plan` on your command line. Note that it now asks for us to provide a value for the `var.virtual_network_cidr` variable. This is because we don't provide a default value for that input so terraform must have a valid input before it can continue. Type `10.0.0.0/22` into the input and press `enter` to allow the plan to complete. You should now see a message indicating that `Your infrastructure matches the configuration` and that no changes are needed.

### Creating a development.tfvars file

There are multiple ways to provide input to the module we're creating. To avoid needing to manually provide testing inputs, we will create a tfvars file that can be supplied during plan and apply stages. Tfvars files are a nice way to document inputs as well as allow for deploying different versions of your module. This is useful if you have a pipeline where infrastructure code is deployed first for development, and then the same code is deployed for QA, staging, or production with different input values.

In your IDE, create a new file named `development.tfvars` in your working directory.

Now add the following content to your `development.tfvars` file.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step3-development.tf" lang="terraform" line_anchors="sol-step3" hl_lines="1-7" >}}
{{% /expand %}}

{{% notice style="note" %}}
Note that each variable has a value defined. Although only inputs without defaults are required, we include values for all of the inputs for clarity. Consider doing this in your environments so that someone looking at the tfvars files has a full picture of what values are being set.
{{% /notice %}}

Re-run the terraform apply, but this time referencing the .tfvars file. `terraform plan -var-file=development.tfvars` This time, you should get a successful completion without needing to manually provide inputs.

### Creating the main.tf file

Now that we've created the supporting files we can start building the actual infrastructure code in our main file. We will add one AVM resource module at a time so that we can test each as we implement them.

Return to your IDE and create a new file named `main.tf`

#### Add a resource group

In Azure, we need a resource group to hold any infrastructure resources we create.  This is a simple resource that typically wouldn't require an AVM module, but we'll include the AVM module so we can take advantage of the tags interface to standardize creation of our solutions tags. TODO: review this comment to see if we want to highlight the resource group and/or tags interface as they are both quite basic.

First, let's visit the terraform registry [documentation page for the resource group](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm/latest) and explore several key sections.

1. Note the `Provision Instructions` box on the right-hand side of the page. This contains the module source and version details which allows us to copy the latest version syntax without needing to type everything ourselves.
1. Now review the `Readme` tab in the middle of the page. It contains details about all required and optional inputs, resources that are created with the module, and any outputs that are defined. If you want to explore any of these items in detail, each have their own tab for review as needed.
1. Finally, in the middle of the page there is a drop down menu named `Examples` that contains functioning examples for the AVM module. These are a great way to use copy/paste to bootstrap module code and then modify it for your specific purpose.

Now that we've explored the registry content, let's add a resource group to our module.

First, copy the content from the `Provision Instructions` box into our main.tf file.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step4-main.tf" lang="terraform" line_anchors="sol-step4" hl_lines="1-3" >}}
{{% /expand %}}

Now, replace the `# insert the 2 required variables here` comment with the following code to define the module inputs. Our full module code should look like the following:

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step4-main.tf" lang="terraform" line_anchors="sol-step4" hl_lines="5-7" >}}
{{% /expand %}}

{{% notice style="note" %}}
Note how we've used the prefix variable and Terraform interpolation syntax to dynamically name the resource group. This allows for module customization and re-use. Also note that although we chose to use the default module name of avm-res-resources-resourcegroup, we could modify the name of the module if needed.
{{% /notice %}}

After saving the file, we want to test our new content.  To do this, return to the command line and first run `terraform init`. Notice how now Terraform has download the module code as well as providers that the module requires. In this case you can see the `azurerm`, `random`, and `modtm` providers were downloaded.

Let's now deploy our resource group. First, let's run a plan operation to review what will be created. Type `terraform plan -var-file=development.tfvars` and press enter to initiate the plan.

##### Add the features block

Notice that we get an error indicating that we are `Missing required argument` and that for the `azurerm` provider we need to provide a features argument. The addition of the resource group AVM resource requires that the `azurerm` provider be installed to provision resources in our module. This provier requires a features block in it's provider definition that is missing in our configuration.

Return to the `terraform.tf` file and add the following content to it. Note how the features block is currently empty. If we needed to activate any feature flags in our module we could add them here.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step5-terraform-features.tf" lang="terraform" line_anchors="sol-step5" hl_lines="7-9" >}}
{{% /expand %}}

Re-run `terraform plan -var-file=development.tfvars` now that we have updated the features block.

##### Set the subscription ID

Note that we once again get an error. This time we get one more error indicating that `subscription_id is a required provider property` for plan/apply operations. This is a change that was introduced as part of the version 4 release of the AzureRM provider. We need to supply the ID of the deployment subscription where our resources will be created.

There are multiple ways to provide terraform the subscription ID.

First, we need to get the subscription id itself. We will use the portal, but using the Azure CLI, powershell, or the resource graph are also valid.

1. Open the [Azure portal.](https://portal.azure.com)
1. Enter `Subscriptions` in the search field at the top middle of the page.
1. Select `Subscriptions` from the services menu in the search drop down
1. Select the subscription you wish to deploy to from the list of subscriptions.
1. Find the `Subscription ID` field on the overview page and click the copy button to copy it to the clipboard.

Secondly, we need to update Terraform so that it can use the subscription id. For scenario we'll use environment variables to set the values so that we don't have to re-enter them on each run. Select a command based on your operating system from the list below.

1. (Linux) - Run the following command with your subscription id. `export ARM_SUBSCRIPTION_ID=<your id here>`
1. (Windows) - Run the following command with your subscription id. `set ARM_SUBSCRIPTION_ID=<your id here>`

Finally, we should now be able to complete our plan operation by re-running `terraform plan -var-file=development.tfvars`. Note that the plan will create three resources, two for telemetry and the resource group.

##### Deploy the resource group

We can complete testing by implementing the resource group. Run `terraform apply -var-file=development.tfvars` and type `yes` and press `enter` when prompted to accept the changes. Terraform will run for a create the resource group and notify you when the `Apply complete` with a summary of the resources that were added, changed, and destroyed.

#### Add the log analytics workspace

We can now continue by adding the Log Analytics Workspace to our `main.tf` file. We will follow a workflow similar to what we did with the resource group.

1. Browse to the AVM [Log Analytics Workspace module page](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/latest) in the Terraform Registry.
1. Copy the module content from the `Provision Instructions` portion of the page into the main.tf file

Instead of manually supplying module inputs, we will instead copy content from one of the examples to minimize the amount of typing required. Navigate to the `Examples` drop down menu in the documentation and select the `default` example from the menu. In the example you will see a fully functioning example with supporting resources. Since we only care about the workspace resource from this example we can scroll to the bottom of the code block and find the `module "log_analytics_workspace"` line. Then copy the content between the brackets excluding the source since we already copied that from the provision instructions. The log analytics module content should look like the following code block. For simplicity you can also copy this directly to avoid multiple copy/paste actions.

{{% expand title="➕ Expand Code" %}}
{{< code file="\content\usage\includes\terraform\template-orchestration\steps\step5-terraform-features.tf" lang="terraform" line_anchors="sol-step5" hl_lines="7-9" >}}
{{% /expand %}}




