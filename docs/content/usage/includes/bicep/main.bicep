targetScope = 'subscription'

@description('Tags for the resources. Specify a value for `Environment` as `Production` or `Development` to configure the resource lock automatically.')
param tags object

@description('Public SSH key for the Discourse VM.')
param vmSshPublicKey string

param zones array = [1]

param namePrefix string = 'AVM'

param enableBackup bool = false

@description('The address prefixes for the virtual network. Add an IPV4 and an IPv6 address prefix.')
param addressPrefix array = ['10.222.0.0/16', 'fd00:3333:4830::/48']

var resourceLocation = 'GermanyWestCentral'
var governanceResourceGroupName = 'Governance-RG'
var networkingResourceGroupName = 'Networking-RG'
var vmResourceGroupName = 'VMs-RG'
var resourceLock = tags.Environment == 'Production' ? { name: 'DoNotDelete', kind: 'CanNotDelete' } : null

// ------------------ Resource Groups -----------------

module rg_governance 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-rg-governance'
  params: {
    name: governanceResourceGroupName
    location: resourceLocation
    tags: tags
    lock: resourceLock
  }
}

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

// ------------------ Modules -----------------

module governance './governance.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-Governance-Module'
  scope: resourceGroup(governanceResourceGroupName)
  params: {
    namePrefix: namePrefix
    location: resourceLocation
    tags: tags
    lock: resourceLock
    enableBackup: enableBackup
  }
  dependsOn: [
    rg_governance
    networking
  ]
}

module networking './networking.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-Networking-Module'
  scope: resourceGroup(networkingResourceGroupName)
  params: {
    namePrefix: namePrefix
    location: resourceLocation
    addressPrefix: addressPrefix
    // zones: zones
    tags: tags
    lock: resourceLock
  }
  dependsOn: [
    rg_networking
  ]
}

module vm1 'modules/VM.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-DockerHost-Module'
  scope: resourceGroup(vmResourceGroupName)
  params: {
    sshPublicKey: vmSshPublicKey
    zones: zones
    subnetResourceId: networking.outputs.vmSubnetResourceId
    actionGroupResourceId: governance.outputs.actionGroupResourceId
    dcrResourceId: governance.outputs.dataCollectionRuleResourceId
    recoveryVaultName: governance.outputs.?recoveryVaultName
    recoveryVaultResourceGroupName: governanceResourceGroupName
    diskBackupPolicyName: governance.outputs.?diskBackupPolicyName
    privateDNSZoneBlobResourceId: networking.outputs.privateDNSZoneBlobResourceId
    tags: tags
    lock: resourceLock
  }
  dependsOn: [
    rg_vms
  ]
}
