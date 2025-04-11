// VM specific parameters
param location string = resourceGroup().location
param tags object = {}
param namePrefix string = 'vm'
param vmSize string = 'Standard_B2ms'
param zones array = [1, 2, 3]
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
param lock lockType?
param adminUsername string = 'vm-admin'
// dependencies
param subnetResourceId string

var vmName = '${namePrefix}-vm'
var nicName = '${vmName}-nic'

module vm 'br/public:avm/res/compute/virtual-machine:0.13.0' = {
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
    adminUsername: adminUsername
    adminPassword: guid(vmName, 'password')
    managedIdentities: { systemAssigned: true }
    bootDiagnostics: true
    nicConfigurations: [
      {
        name: '${nicName}-v4'
        privateIPAddressVersion: 'IPv4'
        deleteOption: 'Delete'
        enableAcceleratedNetworking: false // not compatible with the SKU
        enableIPForwarding: false
        enableIPConfiguration: true
        enablePublicIPAddress: false
        subnetResourceId: subnetResourceId
      }
      {
        name: '${nicName}-v6'
        privateIPAddressVersion: 'IPv6'
        deleteOption: 'Delete'
        enableAcceleratedNetworking: false // not compatible with the SKU
        enableIPForwarding: false
        enableIPConfiguration: true
        enablePublicIPAddress: false
        subnetResourceId: subnetResourceId
      }
    ]

    tags: tags
    lock: lock
  }
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

// resource vm_nic_v4 'Microsoft.Network/networkInterfaces@2024-05-01' existing = {
//   name: '${nicName}-v4'
//   dependsOn: [
//     vm
//   ]
// }

// resource vm_nic_v6 'Microsoft.Network/networkInterfaces@2024-05-01' existing = {
//   name: '${nicName}-v6'
//   dependsOn: [
//     vm
//   ]
// }

output vmManagedIdentityPrincipalId string = vm.outputs.?systemAssignedMIPrincipalId!
// output vmPrivateIpV4 string = vm_nic_v4.properties.ipConfigurations[0].properties.privateIPAddress
// output vmPrivateIpV6 string = vm_nic_v6.properties.ipConfigurations[0].properties.privateIPAddress
