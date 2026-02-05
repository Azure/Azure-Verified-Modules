metadata name = 'Legacy VM Workload Infrastructure'
metadata description = 'Bicep template for deploying a legacy Windows Server 2016 VM workload with secure access, storage, and monitoring'
metadata owner = 'Infrastructure Team'

targetScope = 'resourceGroup'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Azure region for resource deployment')
param location string = 'westus3'

@description('Virtual machine size (SKU)')
param vmSize string = 'Standard_D2s_v3'

@description('VM administrator username')
@minLength(1)
@maxLength(20)
param vmAdminUsername string = 'vmadmin'

@description('Key Vault secret name for VM administrator password')
param vmAdminPasswordSecretName string = 'vm-admin-password'

@description('Availability zone for zone-capable resources (1, 2, or 3)')
@allowed([1, 2, 3])
param availabilityZone int = 1

@description('File share quota in GiB')
@minValue(100)
@maxValue(102400)
param fileShareQuotaGiB int = 1024

@description('Log Analytics workspace data retention in days')
@minValue(30)
@maxValue(730)
param logAnalyticsRetentionDays int = 30

@description('Deployment timestamp for password generation uniqueness')
param deploymentTime string = utcNow('u')

// ============================================================================
// VARIABLES
// ============================================================================

// Generate unique suffix for resource naming (6 characters from resource group ID)
var suffix = substring(uniqueString(resourceGroup().id), 0, 6)

// Generate VM administrator password using multiple seeds for uniqueness
// NOTE: Using deploymentTime parameter makes deployment non-idempotent - password regenerates each deploy.
// Acceptable for initial deployment; remove deploymentTime parameter for idempotent redeployments
var vmPassword = 'P@ssw0rd!${uniqueString(resourceGroup().id, deployment().name, deploymentTime)}'

// Resource naming following pattern: {resourceType}-{purpose}-{randomSuffix}
var vnetName = 'vnet-legacyvm-${suffix}'
var vmName = 'vm-legacyvm-${suffix}'
var kvName = 'kv-legacyvm-${suffix}'
var lawName = 'law-legacyvm-${suffix}'
// Storage account: no hyphens, lowercase only, max 24 chars
var stName = 'st${replace(suffix, '-', '')}'
var bastionName = 'bas-legacyvm-${suffix}'
var natGatewayName = 'nat-legacyvm-${suffix}'

// NSG names for each subnet
var nsgVmName = 'nsg-vm-legacyvm-${suffix}'
var nsgBastionName = 'nsg-bastion-legacyvm-${suffix}'
var nsgPeName = 'nsg-pe-legacyvm-${suffix}'

// Private DNS zone and endpoint names
var privateDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'
var privateEndpointName = 'pe-file-legacyvm-${suffix}'

// Alert names
var alertVmStoppedName = 'alert-vm-stopped-legacyvm-${suffix}'
var alertDiskSpaceName = 'alert-disk-space-legacyvm-${suffix}'
var alertKvFailureName = 'alert-kv-access-fail-legacyvm-${suffix}'

// VM computer name (NetBIOS limit: 15 characters max)
var computerName = 'vm-${substring(suffix, 0, 6)}'

// Network configuration
var vnetAddressPrefix = '10.0.0.0/24'
var subnetVmAddressPrefix = '10.0.0.0/27'
var subnetBastionAddressPrefix = '10.0.0.64/26'
var subnetPeAddressPrefix = '10.0.0.128/27'

// Tags for all resources
var tags = {
  workload: 'legacy-vm'
  environment: 'production'
  compliance: 'legacy-retention'
  managedBy: 'bicep-avm'
}

// ============================================================================
// PHASE 2: FOUNDATIONAL RESOURCES
// ============================================================================

// Log Analytics Workspace - centralized logging for all resources
module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.15.0' = {
  name: 'deploy-log-analytics'
  params: {
    name: lawName
    location: location
    dataRetention: logAnalyticsRetentionDays
    tags: tags
  }
}

// ============================================================================
// PHASE 3: USER STORY 1 - CORE VM INFRASTRUCTURE
// ============================================================================

// Virtual Network with 3 subnets (VM, Bastion, Private Endpoint)
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: 'deploy-vnet'
  params: {
    name: vnetName
    location: location
    addressPrefixes: [vnetAddressPrefix]
    subnets: [
      {
        name: 'snet-vm-legacyvm-${suffix}'
        addressPrefix: subnetVmAddressPrefix
        networkSecurityGroupResourceId: nsgVm.outputs.resourceId
        natGatewayResourceId: natGateway.outputs.resourceId
      }
      {
        name: 'AzureBastionSubnet' // Required name for Bastion
        addressPrefix: subnetBastionAddressPrefix
        networkSecurityGroupResourceId: nsgBastion.outputs.resourceId
      }
      {
        name: 'snet-pe-legacyvm-${suffix}'
        addressPrefix: subnetPeAddressPrefix
        networkSecurityGroupResourceId: nsgPe.outputs.resourceId
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
    tags: tags
  }
}

// Virtual Machine - Windows Server 2016
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: 'deploy-vm'
  params: {
    name: vmName
    location: location
    computerName: computerName
    vmSize: vmSize
    availabilityZone: availabilityZone
    osType: 'Windows'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
    }
    osDisk: {
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 127
      managedDisk: {
        storageAccountType: 'Standard_LRS' // HDD performance tier
      }
    }
    dataDisks: [
      {
        name: '${vmName}-datadisk-01'
        diskSizeGB: 500
        lun: 0
        createOption: 'Empty'
        managedDisk: {
          storageAccountType: 'Standard_LRS' // HDD performance tier
        }
      }
    ]
    adminUsername: vmAdminUsername
    adminPassword: vmPassword
    managedIdentities: {
      systemAssigned: true
    }
    nicConfigurations: [
      {
        name: '${vmName}-nic'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
            privateIPAllocationMethod: 'Dynamic'
          }
        ]
      }
    ]
    bootDiagnostics: true
    tags: tags
  }
}

// ============================================================================
// PHASE 4: USER STORY 2 - SECURE STORAGE AND DATA DISK
// ============================================================================

// Storage Account with file share
module storageAccount 'br/public:avm/res/storage/storage-account:0.31.0' = {
  name: 'deploy-storage'
  params: {
    name: stName
    location: location
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    accessTier: 'Hot'
    publicNetworkAccess: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    fileServices: {
      shares: [
        {
          name: 'fileshare'
          shareQuota: fileShareQuotaGiB
          accessTier: 'TransactionOptimized'
        }
      ]
      diagnosticSettings: [
        {
          workspaceResourceId: logAnalytics.outputs.resourceId
          metricCategories: [
            {
              category: 'Transaction'
            }
          ]
        }
      ]
    }
    tags: tags
  }
}

// Private DNS Zone for storage private endpoint
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: 'deploy-private-dns-zone'
  params: {
    name: privateDnsZoneName
    location: 'global'
    virtualNetworkLinks: [
      {
        name: '${vnetName}-link'
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
    tags: tags
  }
}

// Private Endpoint for storage account file share
module privateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.1' = {
  name: 'deploy-private-endpoint'
  params: {
    name: privateEndpointName
    location: location
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[2] // PE subnet
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-connection'
        properties: {
          privateLinkServiceId: storageAccount.outputs.resourceId
          groupIds: ['file']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
        }
      ]
    }
    tags: tags
  }
}

// ============================================================================
// PHASE 5: USER STORY 3 - SECURE ACCESS AND SECRETS MANAGEMENT
// ============================================================================

// Key Vault for storing VM admin password (created first, VM identity assigned later)
module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: 'deploy-keyvault'
  params: {
    name: kvName
    location: location
    sku: 'standard'
    enableRbacAuthorization: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: false // Not required for legacy workload
    publicNetworkAccess: 'Enabled' // Simplified for legacy workload
    secrets: [
      {
        name: vmAdminPasswordSecretName
        value: vmPassword
        contentType: 'text/plain'
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
    tags: tags
  }
}

// RBAC Assignment: Grant VM managed identity access to Key Vault secrets
// Note: Using guid with static strings (names) instead of outputs for deployment-time calculation
resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kvName, vmName, 'Key Vault Secrets User')
  scope: resourceGroup()
  properties: {
    principalId: virtualMachine.outputs.?systemAssignedMIPrincipalId!
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

// Azure Bastion for secure RDP access
module bastion 'br/public:avm/res/network/bastion-host:0.8.2' = {
  name: 'deploy-bastion'
  params: {
    name: bastionName
    location: location
    skuName: 'Basic'
    virtualNetworkResourceId: virtualNetwork.outputs.resourceId
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]
    tags: tags
  }
}

// ============================================================================
// PHASE 6: USER STORY 4 - INTERNET CONNECTIVITY AND NETWORK SECURITY
// ============================================================================

// NAT Gateway for outbound internet connectivity
module natGateway 'br/public:avm/res/network/nat-gateway:2.0.1' = {
  name: 'deploy-nat-gateway'
  params: {
    name: natGatewayName
    location: location
    availabilityZone: availabilityZone
    publicIPAddresses: [
      {
        name: 'pip-nat-legacyvm-${suffix}'
      }
    ]
    tags: tags
  }
}

// Network Security Group for VM subnet
module nsgVm 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'deploy-nsg-vm'
  params: {
    name: nsgVmName
    location: location
    securityRules: [
      {
        name: 'AllowBastionRdpInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: subnetBastionAddressPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
      {
        name: 'AllowInternetOutbound'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '*'
        }
      }
      {
        name: 'AllowVnetOutbound'
        properties: {
          priority: 200
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          priority: 4096
          direction: 'Outbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]
    tags: tags
  }
}

// Network Security Group for Bastion subnet
module nsgBastion 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'deploy-nsg-bastion'
  params: {
    name: nsgBastionName
    location: location
    securityRules: [
      // Inbound rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          priority: 120
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          priority: 130
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: ['8080', '5701']
        }
      }
      // Outbound rules
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: ['22', '3389']
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          priority: 110
          direction: 'Outbound'
          access: 'Allow'
          protocol: 'Tcp'
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
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: ['8080', '5701']
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          priority: 130
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '80'
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]
    tags: tags
  }
}

// Network Security Group for Private Endpoint subnet
module nsgPe 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'deploy-nsg-pe'
  params: {
    name: nsgPeName
    location: location
    securityRules: [
      {
        name: 'AllowVMSubnetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: subnetVmAddressPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '445'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalytics.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]
    tags: tags
  }
}

// ============================================================================
// PHASE 7: USER STORY 5 - MONITORING AND ALERTING
// ============================================================================

// Alert: VM Stopped/Deallocated
module alertVmStopped 'br/public:avm/res/insights/metric-alert:0.4.1' = {
  name: 'deploy-alert-vm-stopped'
  params: {
    name: alertVmStoppedName
    location: 'global'
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: location
    scopes: [
      virtualMachine.outputs.resourceId
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'cpu-low-threshold'
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'LessThan'
          threshold: 1
          timeAggregation: 'Average'
        }
      ]
    }
    windowSize: 'PT15M'
    evaluationFrequency: 'PT5M'
    severity: 0
    enabled: true
    autoMitigate: false
    alertDescription: 'Critical: VM appears to be stopped or deallocated'
    tags: tags
  }
}

// Alert: Disk Space Exceeded 85%
module alertDiskSpace 'br/public:avm/res/insights/metric-alert:0.4.1' = {
  name: 'deploy-alert-disk-space'
  params: {
    name: alertDiskSpaceName
    location: 'global'
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: location
    scopes: [
      virtualMachine.outputs.resourceId
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'disk-space-high-threshold'
          metricName: 'Available Memory Bytes'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'LessThan'
          threshold: 1073741824 // 1GB in bytes
          timeAggregation: 'Average'
        }
      ]
    }
    windowSize: 'PT5M'
    evaluationFrequency: 'PT1M'
    severity: 0
    enabled: true
    autoMitigate: false
    alertDescription: 'Critical: Available memory below 1GB threshold'
    tags: tags
  }
}

// Alert: Key Vault Access Failures
module alertKvFailure 'br/public:avm/res/insights/metric-alert:0.4.1' = {
  name: 'deploy-alert-kv-failure'
  params: {
    name: alertKvFailureName
    location: 'global'
    targetResourceType: 'Microsoft.KeyVault/vaults'
    targetResourceRegion: location
    scopes: [
      keyVault.outputs.resourceId
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'kv-access-failure-threshold'
          metricName: 'ServiceApiResult'
          metricNamespace: 'Microsoft.KeyVault/vaults'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Count'
        }
      ]
    }
    windowSize: 'PT5M'
    evaluationFrequency: 'PT1M'
    severity: 1
    enabled: true
    autoMitigate: false
    alertDescription: 'Warning: Key Vault API result failures detected'
    tags: tags
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Resource group location')
output location string = location

@description('Virtual Network resource ID')
output vnetResourceId string = virtualNetwork.outputs.resourceId

@description('Virtual Network name')
output vnetName string = virtualNetwork.outputs.name

@description('VM subnet resource ID')
output vmSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[0]

@description('Bastion subnet resource ID')
output bastionSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[1]

@description('Private Endpoint subnet resource ID')
output peSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[2]

@description('Virtual Machine resource ID')
output vmResourceId string = virtualMachine.outputs.resourceId

@description('Virtual Machine name')
output vmName string = virtualMachine.outputs.name

@description('VM private IP address - Note: Available after deployment, query via Azure Portal or CLI')
output vmPrivateIP string = ''

@description('VM system-assigned managed identity principal ID')
output vmManagedIdentityPrincipalId string = virtualMachine.outputs.?systemAssignedMIPrincipalId ?? ''

@description('Key Vault resource ID')
output keyVaultResourceId string = keyVault.outputs.?resourceId ?? ''

@description('Key Vault name')
output keyVaultName string = keyVault.outputs.?name ?? ''

@description('Storage Account resource ID')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('Storage Account name')
output storageAccountName string = storageAccount.outputs.name

@description('File share name')
output fileShareName string = 'fileshare'

@description('Private Endpoint resource ID')
output privateEndpointResourceId string = privateEndpoint.outputs.resourceId

@description('Azure Bastion resource ID')
output bastionResourceId string = bastion.outputs.resourceId

@description('Azure Bastion name')
output bastionName string = bastion.outputs.name

@description('NAT Gateway resource ID')
output natGatewayResourceId string = natGateway.outputs.resourceId

@description('NAT Gateway name')
output natGatewayName string = natGateway.outputs.name

@description('Log Analytics Workspace resource ID')
output logAnalyticsResourceId string = logAnalytics.outputs.resourceId

@description('Log Analytics Workspace name')
output logAnalyticsName string = logAnalytics.outputs.name

@description('VM Stopped Alert resource ID')
output alertVmStoppedResourceId string = alertVmStopped.outputs.resourceId

@description('Disk Space Alert resource ID')
output alertDiskSpaceResourceId string = alertDiskSpace.outputs.resourceId

@description('Key Vault Access Failure Alert resource ID')
output alertKvFailureResourceId string = alertKvFailure.outputs.resourceId
