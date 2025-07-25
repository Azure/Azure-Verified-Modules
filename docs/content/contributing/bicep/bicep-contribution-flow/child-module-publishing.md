---
title: Child Module Publishing
description: How to set up a child module for publishing so that it can be directly referenced from the Bicep public registry
---

Child resources are resources that exist only within the scope of another resource. For example, a virtual network subnet cannot exist without a virtual network. The subnet is a child resource of the virtual network.

In the context of AVM, particularly AVM Bicep resource modules, child modules are modules deploying child resources. They are implemented within the scope of their corresponding parent resource modules. For example, the module `avm/res/network/virtual-network/subnet` deploys a virtual network subnet and is a child module of its parent virtual network module `avm/res/network/virtual-network`.

By default, child modules are not published to the public bicep registry independently from their top-level parents. They need to be explicitly enabled for publishing to be directly referenced from the registry.

This page covers step-by-step guidelines to publish a bicep child module.

{{% notice style="important" %}}

The child module publishing process is currently in a pilot/preview phase. This means it may not be as smooth as expected.

The core team is currently working on additional automation, with the goal of improving efficiency in addressing child module publishing requests.

{{% /notice %}}

{{% notice style="note" %}}

Child module publishing currently only applies to resource modules.

Supporting child module publishing for other module categories, such as pattern and utility modules, is not planned at this time.

{{% /notice %}}

## Quick guide

TLDR



## Prerequisites

Before jumping into the implementation, make sure the following prerequisites are in place:

### Bicep Child Module Proposal issue

Ensure there is an AVM issue open already, proposing the child module to be published. If not, please create one using the [Bicep Child Module Proposal issue template](https://github.com/Azure/Azure-Verified-Modules/issues/new?template=4_module_proposal_bicep_child.yml).

{{% notice style="note" %}}

Please understand the difference between publishing an existing child module and extending a parent module with a not yet implemented child module functionality.

The Bicep Child Module Proposal issue intends to cover the former, so the intended child module must already exist in the [BRM (Bicep Registry Modules)](https://aka.ms/BRM) repository source code.

{{% /notice %}}

### Telemetry ID prefix assigned

Follow the below steps to check the child module telemetry ID prefix.

{{% notice style="note" %}}

If the Bicep Child Module Proposal issue was just created, please allow a few days for the telemetry ID prefix to be assigned before reaching out.

{{% /notice %}}

1. Download the Bicep resource module index source CSV file from [here]({{% siteparam base %}}/module-indexes/BicepResourceModules.csv).
1. Check the child module name in the `ModuleName` field.
1. Verify if the corresponding value exists in the `TelemetryIdPrefix` field. Note down the value as you will need it in the implementation phase.
1. If not found, please reach out to the core team, mentioning the `@Azure/avm-core-team-technical-bicep` via the Bicep Child Module Proposal issue.

### Module registered in the MAR-file

Ensure that the child module is registered in the [MAR-file](https://github.com/microsoft/mcr/blob/main/teams/bicep/bicep.yml).
If not, please reach out to the core team, mentioning the `@Azure/avm-core-team-technical-bicep` via the Bicep Child Module Proposal issue.

{{% notice style="note" %}}

The MAR-file can only be accessed by Microsoft FTEs. If you are missing access, please reach out to the parent module owner for help.

{{% /notice %}}

## Implementation

everyone's contribution is welcome. you can implement via the following steps

- until pilot phase make sure child module name listed in the allowed list, if not add, keeping alphab order
- add version.json at 0.1
- add changelog initial version
- update parent changelog, example
- update child module main with
    - telemetry
    - enable telemetry parameter
-

## Verify the publishing

### Ref PRs

You can reference the follwing pull requests proposing a child module for publishing

ref one direct child
ref one indirect child

#### notes - delete

Until they are being published directly they can however be consumed via their top-level parents.

For example, using a storage account module allows to also deploy file shares and blob containers. If the file share child module is also directly published, it is possible, in addition, to directly consume the file share child module from the registry



There is no . At this time publishing child modules happens on demand

but can only be consumed via their top level parents.

For example, without being published explicitly, a sql server database can be created via its parent, but cannot be referenced via the registry on its own


{{% notice style="note" %}}

Understand the difference between publishing an existing child module and extending a parent module with a not yet implemented child module functionality.

This page details the process covering the former.

{{% /notice %}}


Before covering the step by step process to enable a bicep child module for publishing, it is important to note that publishing an existing child module is different than extending a parent module with a not yet existing child module functionality.

In the former case, we are looking at code already existing in the brm repo, and already consumable via the registry, but only via its top-level parent module.

In the latter case instead, we are looking at a missing functionality for

If looking for the latter, i.e. extending a module functionality, you must instead open a feature request in the BRM repo


