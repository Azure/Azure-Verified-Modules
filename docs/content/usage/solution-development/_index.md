---
title: Solution Development
linktitle: Solution Development
type: default
weight: 3
description: Advanced Solution Development guidance for the Azure Verified Modules (AVM) program. It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.
---

This section provides advanced guidance for developing solutions using Azure Verified Modules (AVM). It covers the technical decisions and concepts that are important for building and deploying Azure solutions using AVM modules.


## Planning your solution

When implementing infrastructure there are multiple options for Azure deployments. In this article we assume that a decision has been made to implement your Infrastructure as Code (IAC). This is best suited to allowing programmatic declarative control of the target infrastructure and is ideal for projects that require repeatability and idempotency.

### Choosing an Infrastructure as Code language

There are many language choices when implementing your solution using Infrastructure as Code in Azure. The Azure Verified Module project currently supports Bicep and Terraform and you can use the following comparison to help select between the option that best suits your requirements.

#### Reasons to choose Bicep

Bicep is the Microsoft 1st party offering for IAC deployments. It includes preview and GA support for all Azure Services and allows for modular composition of resources. The use of simplified syntax makes infrastructure code development intuitive and the use of the Bicep extension for VSCode provides Intellisense and syntax validation to assist with code creation. Finally, Bicep is well suited for infrastructure projects and teams that don’t require management of other cloud platforms or services outside of Azure. For a more detailed read on reasons to choose Bicep, [read this article](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) from the Bicep documentaton.

#### Reasons to choose Terraform

Hashicorp’s Terraform is an extensible 3rd party platform that can be used across multiple cloud and on-premises platforms using multiple provider plugins. It has widespread adoption due to its simplified human-readable configuration files, common functionality, and the ability to allow a project to span multiple provider spaces.

In Azure, support is provided through two primary providers called AzureRM and AzAPI respectively. The default provider for many Azure use cases is AzureRM which is co-developed between Microsoft and Hashicorp. It includes support for GA features and can have some amount of feature delay. AzAPI is developed exclusively by Microsoft and supports all preview and GA features while being more complex to use due to the more direct interaction with the Azure APIs. While it is possible to use both providers in a single project as needed, the best practice is to standardize on a single provider as much as is reasonable.

Projects typically choose Terraform when they bridge multiple cloud infrastructure platforms or when the development team has previous experience coding with Terraform. Modern Integrated Development Environments (IDE) such as Visual Studio Code include extension support for Terraform features as well as additional Azure specific extensions. These extensions enable syntax validation and highlighting as well as code formatting and HCP platform integration for Hashicorp Cloud customers.

### Architecture design

Before starting the process of codifying infrastructure, it is important to develop a detailed architecture of what will be created.  This should include details for:

1.	Organizational elements such as management groups, subscriptions, and resource groups as well as any tagging and Role Based Access (RBAC) configurations for each.
1.	Infrastructure services that will be created along with key configuration details like sku values, network CIDR range sizes, or other solution specific configuration.
1.	Any relationship between services that will be codified as part of the deployment.
1.	Identify inputs to your solution for designs that are intended to be used as templates

For our simple example we’ve created the following architecture diagram as our starting point.

TODO: link architecture image and details

### Sourcing content for deployment

Once the architecture is agreed upon, it is time to plan the development of your infrastructure code. There are several key decision points that should be considered during this phase.

#### Content creation methods

The two primary methods used to create your solutions module are:

1.	Using base resources from scratch or
1.	Leveraging pre-created modules such as those in the AVM library to minimize the time to value during development.

The trade-off between the two options is primarily around control vs. speed. AVM works to provide the best of both options by providing modules with opinionated and best practice defaults while allowing for more detailed configuration as needed. For our sample exercise we’ll be using AVM modules to demonstrate building the example solution.

#### AVM module type considerations

When using AVM modules for your solution, there is an additional choice that should be considered. The AVM library includes both pattern and resource module types. If your architecture includes or follows a well-known pattern then a pattern module may be the right option for you. If you determine this is the case, then search the pattern module index for your chosen language(TODO: Add link ) to see if an option exists for your use.  Otherwise, using resource modules (TODO: Add link) from the library will be your best option.

In cases where an AVM resource or pattern module isn’t available for use, review the Bicep or Terraform provider documentation to identify how to augment AVM modules with standalone resources. If time allows, You can also request the creation of a pattern or resource module by creating an issue on the AVM github repository(TODO: include link) if you feel that additional resource or pattern modules would be useful.

#### Module source considerations

Once the decision has been made to use AVM modules to help accelerate solution development, a decision about where those modules will be sourced from is the next key decision point. A detailed exploration of the different sourcing options can be found in the Module Sourcing section of the Concepts page (TODO: Add link here). Take a moment to review the options discussed there.

For our solution we will leverage the Public Registry option by sourcing AVM modules directly from the respective Terraform and Bicep public registries. This will avoid the need to fork copies of the modules for private use.



