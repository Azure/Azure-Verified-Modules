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

The Linux VM is created in a new Virtual Network respecting the Well Architected Framework. This means, I need to add NSGs to the subnet, a maintenance configuration, not public endpoints (why we will add an Azure Bastion as well) and other resources.

## Developing the template

Before we start to create the template, let's quickly check if you dev-environment is setup with everything we need:

// TODO link/copy from the Quickstart https://azure.github.io/Azure-Verified-Modules/usage/quickstart/bicep/#prerequisites

*Don't forget to add the *bicepconfig.json* file, which supports with warnings for outdated AVM versions.*

I decided to not putt all code into one big bicep file, but to build it modular with multiple files.

- main.bicep
  - modules
    - VM.bicep
- networking.bicep

{{% notice style="info" %}}
We'll skip comments to improve the readability, but strongly suggest working with comments and descriptions for your template.
{{% /notice %}}

We start with a minimal configuration, and extend the templates over time.

### The Virtual Machine

Codeing. Finally. I start with the VM.bicep file, add parameters and later create the main.bicep file that calls the VM template. I like to add default values for parameters.

{{% expand title="modules/VM.bicep" %}}

```bicep
// VM specific parameters
param location string = resourceGroup().location
param tags object = {}
param namePrefix string = 'vm'
param vmSize string = 'Standard_B2ms'
param zones array
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
param lock lockType?
// dependencies
param subnetResourceId string

var vmName = '${namePrefix}-vm'

module vm 'br/public:avm/res/compute/virtual-machine:0.12.3' = {
  name: '${uniqueString(deployment().name, location)}-${vmName}'
  params: {
    name: vmName
    location: location
    zone: 0
    vmSize: vmSize
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-jammy'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    osType: 'Linux'
    osDisk: {
      diskSizeGB: 30
      deleteOption: 'Detach' // don't delete the disk when the VM is deleted
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      name: '${vmName}-os-disk'
    }
    secureBootEnabled: true
    vTpmEnabled: true
    encryptionAtHost: true
    patchMode: 'AutomaticByPlatform'
    enableAutomaticUpdates: true
    enableHotpatching: true
    managedIdentities: { systemAssigned: true }
    bootDiagnostics: true
    nicConfigurations: [
      {
        name: '${vmName}-nic'
        publicIPAddressVersion: 'IPv6'
        privateIPAddressVersion: 'IPv6'
        deleteOption: 'Delete'
        enableAcceleratedNetworking: false // not compatible with the SKU
        enableIPForwarding: false
        enableIPConfiguration: true
        enablePublicIPAddress: true
        ipConfigurations: [
          {
            name: '${vmName}-ipconfig-v4'
            subnetResourceId: subnetResourceId
            pipConfiguration: {
              publicIPAddressResourceId: vm_pip_v4.outputs.resourceId
            }
          }
          {
            name: '${vmName}-ipconfig-v6'
            publicIPAddressVersion: 'IPv6'
            privateIPAddressVersion: 'IPv6'
            subnetResourceId: subnetResourceId
            pipConfiguration: {
              publicIPAddressResourceId: vm_pip_v6.outputs.resourceId
            }
          }
        ]
      }
    ]
  }
  tags: tags
  lock: lock
}

module vm_pip_v4 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: '${vmName}-pip-v4'
  params: {
    name: '${vmName}-pip-v4'
    location: location
    zones: zones
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    tags: tags
  }
}

module vm_pip_v6 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: '${vmName}-pip-v6'
  params: {
    name: '${vmName}-pip-v6'
    location: location
    zones: zones
    publicIPAddressVersion: 'IPv6'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    tags: tags
  }
}

output vmManagedIdentityPrincipalId string = vm.outputs.?systemAssignedMIPrincipalId!
output vmPrivateIpV4 string = vm_nic.properties.ipConfigurations[0].properties.privateIPAddress
output vmPrivateIpV6 string = vm_nic.properties.ipConfigurations[1].properties.privateIPAddress
```

{{% /expand %}}

Right. For the VM, we need dependencies like the network. Let's add that as well.

### Virtual Network

Since we want to support IPV4 and IPV6 in this template, let's just add both (obviously, you can skip either).

Now here we see, that the template is quickly getting bigger and bigger. Let alone the NSGs, defining all rules taking more than 150 lines.

{{% expand title="networking.bicep" %}}

```bicep
param namePrefix string
param location string
param tags object = {}
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
param lock lockType?
param addressPrefix array

var bastionSubnetAddressPrefixV4 = cidrSubnet(addressPrefix[0], 24, 0) // first subnet in address space
var bastionSubnetAddressPrefixV6 = cidrSubnet(addressPrefix[1], 64, 0) // first subnet in address space
var vmSubnetAddressPrefixV4 = cidrSubnet(addressPrefix[0], 24, 1) // second subnet in address space
var vmSubnetAddressPrefixV6 = cidrSubnet(addressPrefix[1], 64, 1) // second subnet in address space

module vnet 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: '${namePrefix}-vnet'
  params: {
    name: '${namePrefix}-vnet'
    location: location
    lock: lock
    addressPrefixes: addressPrefix
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefixes: [bastionSubnetAddressPrefixV4, bastionSubnetAddressPrefixV6]
        networkSecurityGroupResourceId: nsg_bastion.outputs.resourceId
      }
      {
        name: 'vms'
        addressPrefixes: [vmSubnetAddressPrefixV4, vmSubnetAddressPrefixV6]
        networkSecurityGroupResourceId: nsg_vms.outputs.resourceId
      }
    ]
  }
}

module nsg_bastion 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${namePrefix}-nsg-bastion'
  params: {
    name: 'NSG-Bastion'
    location: location
    tags: tags
    securityRules: [
      {
        name: 'AllowHttpsInbound'
        properties: {
          priority: 120
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          priority: 130
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          priority: 140
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          priority: 150
          protocol: '*'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowSshOutbound'
        properties: {
          priority: 100
          protocol: '*'
          access: 'Allow'
          direction: 'Outbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '22'
            '3389'
          ]
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Outbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureCloud'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          priority: 120
          protocol: '*'
          access: 'Allow'
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowHttpOutbound'
        properties: {
          priority: 130
          protocol: '*'
          access: 'Allow'
          direction: 'Outbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '80'
        }
      }
    ]
  }
}

module nsg_vms 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${namePrefix}-nsg-web'
  params: {
    name: 'NSG-Web-VMs'
    location: location
    tags: tags
    securityRules: [
      {
        name: 'AllowSSH' // we are using Azure Bastion, so we don't need to allow SSH from the Internet
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'virtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'virtualNetwork'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'virtualNetwork'
          destinationPortRanges: ['443']
        }
      }
    ]
  }
}

// developer SKU doesn't require a public IP address and subnet
module bastion 'br/public:avm/res/network/bastion-host:0.6.1' = {
  name: '${namePrefix}-bastion'
  params: {
    name: '${namePrefix}-bastion'
    virtualNetworkResourceId: vnet.outputs.resourceId
    skuName: 'Developer'
    location: location
    tags: tags
  }
}

output vnetName string = vnet.outputs.name
output vnetResourceId string = vnet.outputs.resourceId
output vmSubnetResourceId string = vnet.outputs.subnetResourceIds[1] // the second subnet is the vm subnet
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
