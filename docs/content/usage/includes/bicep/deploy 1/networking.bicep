param namePrefix string
param location string
param tags object = {}
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
param lock lockType?
param addressPrefix string

var bastionSubnetAddressPrefixV4 = cidrSubnet(addressPrefix, 24, 0) // first subnet in address space
var vmSubnetAddressPrefixV4 = cidrSubnet(addressPrefix, 24, 1) // second subnet in address space

module vnet 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: '${namePrefix}-vnet'
  params: {
    name: '${namePrefix}-vnet'
    location: location
    lock: lock
    addressPrefixes: [addressPrefix]
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefix: bastionSubnetAddressPrefixV4
        networkSecurityGroupResourceId: nsg_bastion.outputs.resourceId
      }
      {
        name: 'vms'
        addressPrefix: vmSubnetAddressPrefixV4
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
    name: 'NSG-VMs'
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
