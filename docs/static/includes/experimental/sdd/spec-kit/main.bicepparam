using './main.bicep'

// ============================================================================
// DEPLOYMENT PARAMETERS
// ============================================================================

// Azure region for resource deployment
param location = 'westus3'

// Virtual machine configuration
param vmSize = 'Standard_D2s_v3'
param vmAdminUsername = 'vmadmin'
param vmAdminPasswordSecretName = 'vm-admin-password'
param availabilityZone = 1

// Storage configuration
param fileShareQuotaGiB = 1024

// Monitoring configuration
param logAnalyticsRetentionDays = 30
