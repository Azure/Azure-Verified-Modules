targetScope = 'resourceGroup'

@description('The name prefix for the resources.')
param namePrefix string

param location string
param tags object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
param lock lockType?

param addressPrefix array

var bastionSubnetAddressPrefixV4 = cidrSubnet(addressPrefix[0], 24, 0) // the first /24 subnet in the address space
var bastionSubnetAddressPrefixV6 = cidrSubnet(addressPrefix[1], 64, 0) // the first /24 subnet in the address space
var vmPubSubnetAddressPrefixV4 = cidrSubnet(addressPrefix[0], 24, 2) // the third /24 subnet in the address space
var vmPubSubnetAddressPrefixV6 = cidrSubnet(addressPrefix[1], 64, 2) // the third /24 subnet in the address space
var vmPrivSubnetAddressPrefixV4 = cidrSubnet(addressPrefix[0], 24, 3) // the fourth /24 subnet in the address space
var vmPrivSubnetAddressPrefixV6 = cidrSubnet(addressPrefix[1], 64, 3) // the fourth /24 subnet in the address space

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
        name: 'public-vms'
        addressPrefixes: [vmPubSubnetAddressPrefixV4, vmPubSubnetAddressPrefixV6]
        networkSecurityGroupResourceId: nsg_public_vms.outputs.resourceId
      }
      {
        name: 'private-vms'
        addressPrefixes: [vmPrivSubnetAddressPrefixV4, vmPrivSubnetAddressPrefixV6]
        networkSecurityGroupResourceId: nsg_private_vms.outputs.resourceId
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

module nsg_public_vms 'br/public:avm/res/network/network-security-group:0.5.1' = {
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
        name: 'AllowHTTP'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'virtualNetwork'
          destinationPortRanges: ['80']
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
      {
        name: 'Gateway-Manager'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 130
          protocol: 'Tcp'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: ['62500-65535']
        }
      }
    ]
  }
}

module nsg_private_vms 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${namePrefix}-nsg-private'
  params: {
    name: 'NSG-Private-VMs'
    location: location
    tags: tags
    securityRules: [
      {
        name: 'AllowSSH'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'virtualNetwork'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

module privateDNSZone_blob 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: '${namePrefix}-privatedns-blob'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    location: 'global'
    tags: union(tags, { UsedBy: 'VM Storage', Purpose: 'provide blob NFS storage' })
    virtualNetworkLinks: [
      {
        name: '${vnet.outputs.name}-vnetlink'
        virtualNetworkResourceId: vnet.outputs.resourceId
        tags: tags
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

@description('The resource ID of the vm subnet.')
output vmSubnetResourceId string = vnet.outputs.subnetResourceIds[1] // the second subnet is the vm subnet

output vnetName string = vnet.outputs.name

@description('The resource ID of the virtual network.')
output vnetResourceId string = vnet.outputs.resourceId

@description('The resource ID of the private DNS zone for blob storage.')
output privateDNSZoneBlobResourceId string = privateDNSZone_blob.outputs.resourceId

output vmSubnetPublicAddressPrefixV4 string = vmPubSubnetAddressPrefixV4
