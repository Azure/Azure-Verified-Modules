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
    name: '${prefix}-law'
    // Non-required parameters
    location: location
  }
}

module natGwPublicIp 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: 'natGwPublicIpDeployment'
  params: {
    // Required parameters
    name: '${prefix}-natgwpip'
    // Non-required parameters
    location: location
    diagnosticSettings: [
      {
        name: 'natGwPublicIpDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

module natGateway 'br/public:avm/res/network/nat-gateway:1.2.2' = {
  name: 'natGatewayDeployment'
  params: {
    // Required parameters
    name: '${prefix}-natgw'
    zone: 1
    // Non-required parameters
    publicIpResourceIds: [
      natGwPublicIp.outputs.resourceId
    ]
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
        name: 'VMSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 0) // first subnet in address space
        natGatewayResourceId: natGateway.outputs.resourceId
        networkSecurityGroupResourceId: nsgVM.outputs.resourceId
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
    enablePurgeProtection: false // disable purge protection for this example so we can more easily delete it
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
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] // VMSubnet
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
