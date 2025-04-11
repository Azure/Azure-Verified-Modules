targetScope = 'subscription'

param resourceLocation string = 'GermanyWestCentral'
param namePrefix string = 'avm-demo'
param tags object = {environment: 'Demo', owner: 'AVM Team'}
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
param resourceLock lockType?
@description('The address prefixes for the virtual network. Add an IPV4 and an IPv6 address prefix.')
param addressPrefixes array = ['10.222.0.0/16', 'fd00:3333:4830::/48']

var networkingResourceGroupName = '${namePrefix}-Networking-RG'
var vmResourceGroupName = '${namePrefix}-VMs-RG'

module rg_networking 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-rg-networking'
  params: {
    name: networkingResourceGroupName
    location: resourceLocation
    tags: tags
    lock: resourceLock
  }
}

module rg_vms 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-rg-vms'
  params: {
    name: vmResourceGroupName
    location: resourceLocation
    tags: tags
    lock: resourceLock
  }
}

module networking 'networking.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-networking'
  scope: resourceGroup(networkingResourceGroupName)
  params: {
    location: resourceLocation
    namePrefix: namePrefix
    addressPrefix: addressPrefixes
  }
  dependsOn: [
    rg_networking
  ]
}

module vm 'modules/VM.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-virtual-machine'
  scope: resourceGroup(vmResourceGroupName)
  params: {
    location: resourceLocation
    namePrefix: namePrefix
    tags: tags
    subnetResourceId: networking.outputs.vmSubnetResourceId
  }
  dependsOn: [
    rg_vms
  ]
}
