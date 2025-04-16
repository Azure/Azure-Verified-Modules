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

## Sceanario

**Mission Statement**: I want to create a template, that deploys a single Linux VM.

**Business Requirements**: The solution must be cost-efficient and secure.

**Technical Requirements**: The VM must not be accessible from the Internet and automatically patched.

< this is a placeholder for the architecture >

Architecture: // TODO Tony to add a diagram
- Image Gallery
- VM
  - private pipv4+v6
  - maintenance schedule
  - metrics / dcr
- storage account
  - nfs for the vm
- monitoring
  - law
  - appinsights
- key vault
  - ssh key
- vnet (ipv4 for start)
  - subnets
  - nsgs
  - bastion


The Linux VM is created in a new Virtual Network respecting the Well Architected Framework. This means, I need to add NSGs to the subnet, a maintenance configuration, not public endpoints (why we will add an Azure Bastion as well) and other resources.

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
- monitoring
