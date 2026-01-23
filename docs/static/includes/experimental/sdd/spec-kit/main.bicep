metadata name = 'Legacy Windows Server VM Workload'
metadata description = 'Deploys Windows Server 2016 VM with Azure Bastion, secure storage, and comprehensive monitoring'
metadata version = '1.0.0'

targetScope = 'resourceGroup'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Short name for the workload (used in resource naming)')
@minLength(3)
@maxLength(10)
param workloadName string

@description('Azure region for resource deployment')
param location string = 'westus3'

@description('Availability zone for VM deployment (1, 2, or 3)')
@allowed([1, 2, 3])
param availabilityZone int = 1

@description('Administrator username for the VM')
@minLength(1)
@maxLength(20)
param vmAdminUsername string = 'vmadmin'

@description('Name of Key Vault secret storing VM admin password')
param vmAdminSecretName string = 'vm-admin-password'

@description('Azure VM SKU size')
param vmSize string = 'Standard_D2s_v3'

@description('Size of data disk in GB')
param dataDiskSizeGB int = 500

@description('Name of the file share to create')
param fileShareName string = 'data'

@description('File share quota in GB')
@minValue(1)
@maxValue(5120)
param fileShareQuotaGB int = 100

@description('Log Analytics workspace retention in days')
@minValue(30)
@maxValue(730)
param logAnalyticsRetentionDays int = 30

@description('Environment tag')
@allowed(['dev', 'test', 'prod'])
param environment string = 'prod'

// ============================================================================
// VARIABLES
// ============================================================================

// Random suffix for unique resource naming (6 characters)
var randomSuffix = toLower(substring(uniqueString(resourceGroup().id), 0, 6))

// Resource names following CAF abbreviations
var logAnalyticsWorkspaceName = 'log-${workloadName}-${randomSuffix}'
var virtualNetworkName = 'vnet-${workloadName}-${randomSuffix}'
var nsgName = 'nsg-${workloadName}-vm-${randomSuffix}'
var bastionName = 'bas-${workloadName}-${randomSuffix}'
var keyVaultName = 'kv-${workloadName}-${randomSuffix}'
var vmName = 'vm-${workloadName}' // No suffix - 15 char Windows limit
var storageAccountName = 'st${workloadName}${randomSuffix}' // No hyphens for storage accounts

// Network configuration
var addressPrefix = '10.0.0.0/16'
var bastionSubnetPrefix = '10.0.0.0/26'
var vmSubnetPrefix = '10.0.1.0/24'

// Tags
var commonTags = {
  workload: workloadName
  environment: environment
  managedBy: 'Bicep'
}

// Generated password for VM admin
var vmAdminPassword = '${uniqueString(resourceGroup().id, deployment().name)}${guid(resourceGroup().id, deployment().name)}!A1'

// ============================================================================
// PHASE 2: FOUNDATIONAL COMPONENTS
// ============================================================================

// T004-T005: Log Analytics Workspace
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: 'deploy-log-analytics-workspace'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    dataRetention: logAnalyticsRetentionDays
    tags: commonTags
  }
}

// T006-T008: Virtual Network with NSG and Subnets
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: 'deploy-virtual-network'
  params: {
    name: virtualNetworkName
    location: location
    addressPrefixes: [addressPrefix]
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefix: bastionSubnetPrefix
        networkSecurityGroupResourceId: null // Bastion subnet doesn't need NSG
      }
      {
        name: 'vm-subnet'
        addressPrefix: vmSubnetPrefix
        networkSecurityGroupResourceId: networkSecurityGroup.outputs.resourceId
      }
    ]
    tags: commonTags
  }
}

// NSG for VM subnet
module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: 'deploy-network-security-group'
  params: {
    name: nsgName
    location: location
    securityRules: [
      {
        name: 'Allow-RDP-From-Bastion'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: bastionSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          description: 'Allow RDP from Azure Bastion subnet'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Deny all other inbound traffic'
        }
      }
      {
        name: 'Allow-HTTPS-To-Storage'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Storage'
          destinationPortRange: '443'
          description: 'Allow HTTPS to Azure Storage'
        }
      }
      {
        name: 'Deny-Internet-Outbound'
        properties: {
          priority: 4096
          direction: 'Outbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '*'
          description: 'Deny direct internet access'
        }
      }
    ]
    tags: commonTags
  }
}

// ============================================================================
// PHASE 3: MVP - CORE VM INFRASTRUCTURE + SECRET MANAGEMENT
// ============================================================================

// T010-T014: Key Vault with Password Secret
module keyVault 'br/public:avm/res/key-vault/vault:0.10.2' = {
  name: 'deploy-key-vault'
  params: {
    name: keyVaultName
    location: location
    enableRbacAuthorization: true
    sku: 'standard'

    // T011-T012: Generate admin password and store as secret
    secrets: [
      {
        name: vmAdminSecretName
        value: vmAdminPassword
      }
    ]

    // T013: RBAC roles for deployment principal
    roleAssignments: [
      {
        principalId: keyVaultAdmin.outputs.principalId
        roleDefinitionIdOrName: 'Key Vault Secrets Officer'
        principalType: 'ServicePrincipal'
      }
    ]

    // T014: Diagnostic settings
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'audit'
          }
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]

    tags: commonTags
  }
}

// Identity for Key Vault access (deployment principal)
module keyVaultAdmin 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: 'deploy-kv-admin-identity'
  params: {
    name: 'id-kv-admin-${workloadName}-${randomSuffix}'
    location: location
    tags: commonTags
  }
}

// T015-T016: Azure Bastion
module bastionHost 'br/public:avm/res/network/bastion-host:0.4.0' = {
  name: 'deploy-bastion-host'
  params: {
    name: bastionName
    location: location
    skuName: 'Basic'
    virtualNetworkResourceId: virtualNetwork.outputs.resourceId

    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]

    tags: commonTags
  }
}

// T017-T023: Virtual Machine
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.8.0' = {
  name: 'deploy-virtual-machine'
  params: {
    name: vmName
    location: location
    zone: availabilityZone
    osType: 'Windows'

    // T018: VM size and Windows Server 2016 image
    vmSize: vmSize
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
    }

    // T019: OS disk configuration
    osDisk: {
      createOption: 'FromImage'
      diskSizeGB: 127
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      caching: 'ReadWrite'
    }

    // T025 (Phase 4): Data disk configuration
    dataDisks: [
      {
        name: 'disk-vm-data-${workloadName}-${randomSuffix}'
        diskSizeGB: dataDiskSizeGB
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        lun: 0
        caching: 'None'
        createOption: 'Empty'
      }
    ]

    // Admin credentials
    adminUsername: vmAdminUsername
    // T020: Use generated password
    adminPassword: vmAdminPassword

    // T021: Managed identity and boot diagnostics
    managedIdentities: {
      systemAssigned: true
    }
    bootDiagnostics: true

    // Disable encryption at host (feature not enabled in subscription)
    encryptionAtHost: false

    // T022: Network configuration - private IP only
    nicConfigurations: [
      {
        name: '${vmName}-nic'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1] // vm-subnet
            privateIPAllocationMethod: 'Dynamic'
          }
        ]
      }
    ]

    tags: commonTags
  }
  dependsOn: [
    keyVault
  ]
}

// T024: Management Locks
resource rgLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-rg-${workloadName}'
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of resource group'
  }
}

// Reference existing VNet resource for lock
resource existingVnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName
}

resource vnetLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-vnet-${workloadName}'
  scope: existingVnet
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of virtual network'
  }
  dependsOn: [
    virtualNetwork
  ]
}

// Reference existing Bastion resource for lock
resource existingBastion 'Microsoft.Network/bastionHosts@2024-01-01' existing = {
  name: bastionName
}

resource bastionLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-bastion-${workloadName}'
  scope: existingBastion
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of Bastion host'
  }
  dependsOn: [
    bastionHost
  ]
}

// Reference existing VM resource for lock
resource existingVm 'Microsoft.Compute/virtualMachines@2024-07-01' existing = {
  name: vmName
}

resource vmLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-vm-${workloadName}'
  scope: existingVm
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of virtual machine'
  }
  dependsOn: [
    virtualMachine
  ]
}

// Reference existing Key Vault resource for lock
resource existingKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource kvLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-kv-${workloadName}'
  scope: existingKeyVault
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of Key Vault'
  }
  dependsOn: [
    keyVault
  ]
}

// ============================================================================
// PHASE 5: FILE SHARE STORAGE
// ============================================================================

// T026-T032: Storage Account with File Share
module storageAccount 'br/public:avm/res/storage/storage-account:0.14.3' = {
  name: 'deploy-storage-account'
  params: {
    // T027: Storage account naming and configuration
    name: storageAccountName
    location: location
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'

    // T028: File share configuration
    fileServices: {
      shares: [
        {
          name: fileShareName
          shareQuota: fileShareQuotaGB
          accessTier: 'TransactionOptimized'
        }
      ]
    }

    // T029: Private endpoint configuration
    privateEndpoints: [
      {
        name: 'pe-${storageAccountName}-file'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1] // vm-subnet
        service: 'file'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
            }
          ]
        }
      }
    ]

    // T030: Disable public access
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Disabled'

    // T031: Diagnostic settings
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'audit'
          }
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'Transaction'
          }
        ]
      }
    ]

    tags: commonTags
  }
}

// Private DNS Zone for Storage private endpoint
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.6.0' = {
  name: 'deploy-private-dns-zone'
  params: {
    name: 'privatelink.file.${az.environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
      }
    ]
    tags: commonTags
  }
}

// T032: Storage account lock
// Reference existing Storage Account resource for lock
resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageAccountName
}

resource storageLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'lock-storage-${workloadName}'
  scope: existingStorageAccount
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletion of storage account'
  }
  dependsOn: [
    storageAccount
  ]
}

// ============================================================================
// PHASE 6: ALERTS AND MONITORING
// ============================================================================

// T033: VM Power State Alert
module vmPowerStateAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'deploy-vm-power-alert'
  params: {
    name: 'alert-vm-power-${workloadName}'
    alertDescription: 'Alert when VM is stopped or deallocated'
    severity: 1 // Critical
    enabled: true
    scopes: [
      virtualMachine.outputs.resourceId
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          name: 'VM Stopped'
          metricName: 'VmAvailabilityMetric'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'LessThan'
          threshold: 1
          timeAggregation: 'Average'
        }
      ]
    }
    tags: commonTags
  }
}

// T034: Disk Capacity Alert
module diskCapacityAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'deploy-disk-alert'
  params: {
    name: 'alert-disk-capacity-${workloadName}'
    alertDescription: 'Alert when disk capacity exceeds 90%'
    severity: 2 // Warning
    enabled: true
    scopes: [
      virtualMachine.outputs.resourceId
    ]
    evaluationFrequency: 'PT15M'
    windowSize: 'PT1H'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          name: 'Disk Usage High'
          metricName: 'OS Disk Used Percent'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'GreaterThan'
          threshold: 90
          timeAggregation: 'Average'
        }
      ]
    }
    tags: commonTags
  }
}

// T035: Key Vault Access Failures Alert
module kvAccessAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'deploy-kv-access-alert'
  params: {
    name: 'alert-kv-access-${workloadName}'
    alertDescription: 'Alert on Key Vault authentication failures'
    severity: 1 // Critical
    enabled: true
    scopes: [
      keyVault.outputs.resourceId
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          name: 'Auth Failures'
          metricName: 'ServiceApiResult'
          metricNamespace: 'Microsoft.KeyVault/vaults'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Total'
          dimensions: [
            {
              name: 'StatusCode'
              operator: 'Include'
              values: ['401', '403']
            }
          ]
        }
      ]
    }
    tags: commonTags
  }
}

// ============================================================================
// OUTPUTS (T036-T037)
// ============================================================================

@description('The name of the resource group')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual network')
output virtualNetworkId string = virtualNetwork.outputs.resourceId

@description('The name of the virtual machine')
output vmName string = virtualMachine.outputs.name

@description('The name of the VM')
output vmResourceId string = virtualMachine.outputs.resourceId

@description('The name of the Bastion host')
output bastionName string = bastionHost.outputs.name

@description('The name of the storage account')
output storageAccountName string = storageAccount.outputs.name

@description('The name of the file share')
output fileShareName string = fileShareName

@description('PowerShell command to mount file share from VM')
output fileShareMountCommand string = 'net use Z: \\\\${storageAccount.outputs.name}.file.${az.environment().suffixes.storage}\\${fileShareName} /persistent:yes'

@description('The name of the Key Vault')
output keyVaultName string = keyVault.outputs.name

@description('The URI of the VM admin password secret')
output keyVaultSecretUri string = '${keyVault.outputs.uri}secrets/${vmAdminSecretName}'

@description('The resource ID of the Log Analytics workspace')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.resourceId
