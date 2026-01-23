using './main.bicep'

// ============================================================================
// REQUIRED PARAMETERS
// ============================================================================

// T039: Workload identification
param workloadName = 'legacyvm'

// ============================================================================
// INFRASTRUCTURE CONFIGURATION
// ============================================================================

// T039: Regional and availability configuration
param location = 'westus3'
param availabilityZone = 1

// ============================================================================
// VIRTUAL MACHINE CONFIGURATION
// ============================================================================

// T039: VM sizing and credentials
param vmAdminUsername = 'vmadmin'
param vmSize = 'Standard_D2s_v3'

// T040: Configurable - Customize secret name if needed
param vmAdminSecretName = 'vm-admin-password'

// T039: Data disk configuration
param dataDiskSizeGB = 500

// ============================================================================
// STORAGE CONFIGURATION
// ============================================================================

// T040: Configurable - Customize file share name if needed
param fileShareName = 'data'

// T039: File share capacity
param fileShareQuotaGB = 100

// ============================================================================
// MONITORING CONFIGURATION
// ============================================================================

// T039: Log Analytics retention
param logAnalyticsRetentionDays = 30

// ============================================================================
// TAGS
// ============================================================================

// T039: Environment classification
param environment = 'prod'
