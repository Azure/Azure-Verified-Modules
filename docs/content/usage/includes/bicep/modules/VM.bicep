param location string = resourceGroup().location
param namePrefix string = 'vm'
param vmSize string = 'Standard_B2ms'
param zones array
param subnetResourceId string
param dcrResourceId string
param tags object
param actionGroupResourceId string
param adminUsername string = 'vm-admin'
param sshPublicKey string
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
param lock lockType?
param privateDNSZoneBlobResourceId string
param recoveryVaultName string?
param recoveryVaultResourceGroupName string?
param diskBackupPolicyName string?

var vmName = '${namePrefix}-vm'

module vm 'br/public:avm/res/compute/virtual-machine:0.13.0' = {
  name: '${uniqueString(deployment().name, location)}-${vmName}'
  params: {
    name: vmName
    location: location
    zone: zones[0]
    zones: zones
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
    maintenanceConfigurationResourceId: maintenanceConfiguration.id
    adminUsername: adminUsername
    disablePasswordAuthentication: true
    publicKeys: [
      {
        keyData: sshPublicKey
        path: '/home/${adminUsername}/.ssh/authorized_keys'
      }
    ]
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
    backupPolicyName: diskBackupPolicyName
    backupVaultName: recoveryVaultName
    backupVaultResourceGroup: recoveryVaultResourceGroupName
    extensionMonitoringAgentConfig: {
      dataCollectionRuleAssociations: [
        {
          dataCollectionRuleResourceId: dcrResourceId
          name: 'SendMetricsToLAW'
        }
      ]
      enabled: true
      tags: tags
    }
    tags: tags
    lock: lock
  }
}

module vm_pip_v4 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: '${vmName}-pip-v4'
  params: {
    name: '${vmName}-pip-v4'
    dnsSettings: {
      domainNameLabel: toLower(vmName)
      domainNameLabelScope: 'NoReuse'
      // fqdn: '${toLower(vmName)}.${location}.cloudapp.azure.com'
    }
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
    dnsSettings: {
      domainNameLabel: toLower(vmName)
      domainNameLabelScope: 'NoReuse'
      // fqdn: '${toLower(vmName)}.${location}.cloudapp.azure.com'
    }
    location: location
    zones: zones
    publicIPAddressVersion: 'IPv6'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    tags: tags
  }
}

module vm_alert '../modules/vm_metric_alerts.bicep' = {
  name: '${vmName}-metric-alert'
  params: {
    vmName: vm.outputs.name
    vmResourceId: vm.outputs.resourceId
    actionGroupResourceId: actionGroupResourceId
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' existing = {
  name: vmName
  dependsOn: [
    vm
  ]
}

// shall we add a health probe to the VM?
resource extension_health_probe 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = {
  name: 'HealthProbe-${vmName}'
  location: location
  parent: virtualMachine
  properties: {
    publisher: 'Microsoft.ManagedServices'
    type: 'ApplicationHealthLinux'
    enableAutomaticUpgrade: true
    autoUpgradeMinorVersion: true
    typeHandlerVersion: '1.0'
    settings: {
      protocol: 'https'
      requestPath: '/'
      intervalInSeconds: 60
      numberOfProbes: 2
    }
  }
}

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: '${vmName}-maintenance-configuration'
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2025-01-01 00:00'
      duration: '03:55'
      timeZone: 'W. Europe Standard Time'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

// storage account with NFS support
module storage 'br/public:avm/res/storage/storage-account:0.19.0' = {
  name: '${vmName}-storage'
  params: {
    name: uniqueString('${vmName}storage', resourceGroup().id, subscription().subscriptionId)
    location: location
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Disabled'
    requireInfrastructureEncryption: true
    enableHierarchicalNamespace: true
    enableNfsV3: true
    tags: union(tags, { UsedBy: 'Docker Host VM', Purpose: 'NFS Storage' })
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: subnetResourceId
        resourceGroupResourceId: resourceGroup().id
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDNSZoneBlobResourceId
            }
          ]
        }
        tags: tags
        lock: null
      }
    ]
    roleAssignments: [
      {
        principalType: 'ServicePrincipal'
        principalId: vm.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ]
    blobServices: {
      lastAccessTimeTrackingPolicyEnabled: true
      // can be used as NFS shares
      containers: [
        {
          name: 'vmstorage'
          publicAccess: 'None'
        }
        {
          name: 'vmbackup'
          publicAccess: 'None'
        }
      ]
    }
    networkAcls: {
      bypass: 'AzureServices'
        defaultAction: 'Deny'
        virtualNetworkRules: [
          {
            action: 'Allow'
            id: subnetResourceId
          }
        ]
        ipRules: [
          {
            action: 'Allow'
            value: vm_pip_v4.outputs.ipAddress
          }
        ]
    }
  }
}

resource vm_nic 'Microsoft.Network/networkInterfaces@2024-05-01'  existing = {
  name: '${vmName}-nic'
  dependsOn: [
    vm
  ]
}

@description('The resource ID of the virtual machine.')
output vmResourceId string = vm.outputs.resourceId

@description('The resource ID of the storage account.')
output storageAccountResourceId string = storage.outputs.resourceId

@description('The resource ID of the maintenance configuration.')
output maintenanceConfigurationResourceId string = maintenanceConfiguration.id

output vmPrivateIpV4 string = vm_nic.properties.ipConfigurations[0].properties.privateIPAddress
// output vmPrivateIpV6 string = vm_nic.properties.ipConfigurations[1].properties.privateIPAddress

output vmManagedIdentityPrincipalId string = vm.outputs.?systemAssignedMIPrincipalId!
