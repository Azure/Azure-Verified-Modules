// VM specific parameters
param location string = resourceGroup().location
param tags object = {}
param namePrefix string = 'vm'
param vmSize string = 'Standard_D2s_v6'
param zone int = 0
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
    zone: zone
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
        storageAccountType: 'StandardSSD_ZRS'
      }
      name: '${vmName}-os-disk'
    }
    secureBootEnabled: true
    vTpmEnabled: true
    encryptionAtHost: true
    patchMode: 'AutomaticByPlatform'
    enableAutomaticUpdates: true
    enableHotpatching: true
    // TODO: change to certificates (stored in Key Vault)
    adminUsername: adminUsername
    adminPassword: guid(vmName, 'password')
    managedIdentities: { systemAssigned: true }
    bootDiagnostics: true
    nicConfigurations: [
      {
        name: '${nicName}-v4'
        privateIPAddressVersion: 'IPv4'
        deleteOption: 'Delete'
        enableAcceleratedNetworking: true
        enableIPForwarding: false
        enableIPConfiguration: true
        enablePublicIPAddress: false
        ipConfigurations: [
          {
            name: '${nicName}-ipconfig'
            privateIPAddressVersion: 'IPv4'
            deleteOption: 'Delete'
            subnetResourceId: subnetResourceId
          }
        ]
      }
    ]

    tags: tags
    lock: lock
  }
}

output vmManagedIdentityPrincipalId string = vm.outputs.?systemAssignedMIPrincipalId!
