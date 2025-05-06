param location string = 'westus2'

@description('Required. A password for the VM admin user.')
@secure()
param vmAdminPass string

var addressPrefix = '10.0.0.0/16'
var prefix = 'VM-AVM-Ex1'

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: '${prefix}-LAW'
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
    name: '${prefix}-vnet'
    // Non-required parameters
    location: location
    diagnosticSettings: [
      {
        name: 'vNetDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 0) // first subnet in address space
        networkSecurityGroupResourceId: nsgBastion.outputs.resourceId
      }
      {
        name: 'VMSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 1) // second subnet in address space
        networkSecurityGroupResourceId: nsgVM.outputs.resourceId
      }
    ]
  }
}

module nsgBastion 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsgBastionDeployment'
  params: {
    name: '${prefix}-nsg-bastion'
    location: location
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

module nsgVM 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsgVmDeployment'
  params: {
    name: '${prefix}-NSG-VM'
    location: location
    securityRules: [
      {
        name: 'DenySSHInternet' // We are using Azure Bastion so we don't need to allow SSH from the Internet
        properties: {
          access: 'Deny'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowBastionSSH'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'virtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowHTTPS' // Our hypothetical VM application will run on a webserver so let's allow HTTP/S
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'virtualNetwork'
          destinationPortRanges: ['80,443']
        }
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
        name: 'keyVaultDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    secrets: [
      {
        name: 'vmAdminPassword'
        value: vmAdminPass
      }
    ]
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
    name: '${prefix}-vm1'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              name: 'pip-01'
            }
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1] // VMSubnet
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
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

module storageAccount 'br/public:avm/res/storage/storage-account:0.19.0' = {
  name: 'storageAccountDeployment'
  params: {
    // Required parameters
    name: '${uniqueString(resourceGroup().id)}sa'
    // Non-required parameters
    location: location
    skuName: 'Standard_LRS'
    diagnosticSettings: [
      {
        name: 'storageAccountDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    blobServices: {
      containers: [
        {
          name: 'vmstorage'
          publicAccess: 'None'
        }
      ]
    }
  }
}
