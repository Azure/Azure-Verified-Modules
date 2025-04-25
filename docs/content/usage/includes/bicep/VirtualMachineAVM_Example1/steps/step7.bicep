param location string = 'westus2'

// START add-password-param
@description('Required. A password for the VM admin user.')
@secure()
param vmAdminPass string
// END add-password-param

var addressPrefix = '10.0.0.0/16'

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-LAW'
    // Non-required parameters
    location: location
  }
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'virtualNetworkDeployment'
  params: {
    // Required parameters
    addressPrefixes: [
      addressPrefix
    ]
    name: 'VM-AVM-Ex1-vnet'
    // Non-required parameters
    location: location
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'vNetDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
      }
    ]
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 0) // first subnet in address space
      }
      {
        name: 'VMSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 1) // second subnet in address space
      }
    ]
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: 'keyVaultDeployment'
  params: {
    // Required parameters
    name: '${uniqueString(resourceGroup().id)}-kv'
    // Non-required parameters
    location: location
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
        logCategoriesAndGroups: [
          {
            category: 'AzurePolicyEvaluationDetails'
          }
          {
            category: 'AuditEvent'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'keyVaultDiagnostics'
      }
    ]
    // START add-keyvault-secret
    secrets: [
      {
        name: 'vmAdminPassword'
        value: vmAdminPass
      }
    ]
    // END add-keyvault-secret
  }
}



module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.13.1' = {
  name: 'linuxVirtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    adminPassword: vmAdminPass
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: 'VM-AVM-Ex1-vm1'
    // START vm-subnet-reference
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              name: 'pip-01'
            }
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1].id // VMSubnet
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    // END vm-subnet-reference
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_B2s_v2'
    zone: 0
    // Non-required parameters
    location: location
  }
}
