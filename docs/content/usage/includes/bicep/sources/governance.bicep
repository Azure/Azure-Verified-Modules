targetScope = 'resourceGroup'

param namePrefix string
param location string
param tags object = {}
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.0'
param lock lockType?
param enableBackup bool

var varBackupPolicyDisksDailyName = 'Disks-Daily-7daysRetention'

var name = '${namePrefix}-RecoveryVault'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${namePrefix}-LogAnalytics'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
  tags: tags
}

module appInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: '${namePrefix}-AppInsights'
  params: {
    name: '${namePrefix}-AppInsights'
    location: location
    workspaceResourceId: logAnalyticsWorkspace.id
    tags: tags
  }
}

module action_group 'br/public:avm/res/insights/action-group:0.5.0' = {
  name: '${namePrefix}-ActionGroup'
  params: {
    name: 'Recommended Alert Rules'
    groupShortName: 'RecAlertRuls'
    tags: tags
    enabled: true
  }
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: 'MSVMI-${namePrefix}-Linux-DataCollectionRule'
  location: location
  kind: 'Linux'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          streams: [
            'Microsoft-Perf'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Processes'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Handle Count'
            '\\System\\System Up Time'
            '\\System\\Context Switches/sec'
            '\\System\\Processor Queue Length'
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pages/sec'
            '\\Memory\\Page Faults/sec'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Packets/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
          ]
          name: 'perfCounterDataSource60'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspace.id
          name: 'LogAnalytics'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Perf'
        ]
        destinations: [
          'LogAnalytics'
        ]
        transformKql: 'source'
        outputStream: 'Microsoft-Perf'
      }
    ]
  }
}

module backupVault 'br/public:avm/res/data-protection/backup-vault:0.9.0' = if (enableBackup) {
  name: '${namePrefix}-BackupVault'
  params: {
    name: '${namePrefix}-BackupVault'
    tags: tags
    type: 'LocallyRedundant'
    featureSettings: {
      securitySettings: {
        softDeleteSettings: {
          retentionInDays: 1
          state: 'Off'
        }
      }
    }
    backupPolicies: [
      {
        name: varBackupPolicyDisksDailyName
        properties: {
          datasourceTypes: [
            'Microsoft.Compute/disks'
          ]
          objectType: 'BackupPolicy'
          policyRules: [
            {
              backupParameters: {
                backupType: 'Incremental'
                objectType: 'AzureBackupParams'
              }
              dataStore: {
                dataStoreType: 'OperationalStore'
                objectType: 'DataStoreInfoBase'
              }
              name: 'BackupDaily'
              objectType: 'AzureBackupRule'
              trigger: {
                objectType: 'ScheduleBasedTriggerContext'
                schedule: {
                  repeatingTimeIntervals: [
                    'R/2022-05-31T23:30:00+01:00/P1D'
                  ]
                  timeZone: 'W. Europe Standard Time'
                }
                taggingCriteria: [
                  {
                    isDefault: true
                    taggingPriority: 99
                    tagInfo: {
                      id: 'Default_'
                      tagName: 'Default'
                    }
                  }
                ]
              }
            }
            {
              isDefault: true
              lifecycles: [
                {
                  deleteAfter: {
                    duration: 'P7D'
                    objectType: 'AbsoluteDeleteOption'
                  }
                  sourceDataStore: {
                    dataStoreType: 'OperationalStore'
                    objectType: 'DataStoreInfoBase'
                  }
                  targetDataStoreCopySettings: []
                }
              ]
              name: 'Default'
              objectType: 'AzureRetentionRule'
            }
          ]
        }
      }
    ]
  }
}

module recoveryVault 'br/public:avm/res/recovery-services/vault:0.9.1' = if (enableBackup) {
  name: name
  params: {
    name: '${namePrefix}-RecoveryVault'
    backupConfig: {
      // backupVaultId: backupVault.outputs.resourceId
      // backupVaultRegion: location
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
      storageModelType: 'LocallyRedundant'
      storageType: 'LocallyRedundant'
      storageTypeState: 'Unlocked'
    }
    backupPolicies: [
      {
        name: varBackupPolicyDisksDailyName
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 5
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 7
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            // monthlySchedule: {
            //   retentionDuration: {
            //     count: 1
            //     durationType: 'Months'
            //   }
            //   retentionScheduleFormatType: 'Weekly'
            //   retentionScheduleWeekly: {
            //     daysOfTheWeek: [
            //       'Sunday'
            //     ]
            //     weeksOfTheMonth: [
            //       'First'
            //     ]
            //   }
            //   retentionTimes: [
            //     '2019-11-07T07:00:00Z'
            //   ]
            // }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 2
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            // yearlySchedule: {
            //   monthsOfYear: [
            //     'January'
            //   ]
            //   retentionDuration: {
            //     count: 1
            //     durationType: 'Years'
            //   }
            //   retentionScheduleFormatType: 'Weekly'
            //   retentionScheduleWeekly: {
            //     daysOfTheWeek: [
            //       'Sunday'
            //     ]
            //     weeksOfTheMonth: [
            //       'First'
            //     ]
            //   }
            //   retentionTimes: [
            //     '2019-11-07T07:00:00Z'
            //   ]
            // }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'W. Europe Standard Time'
        }
      }
    ]
    tags: tags
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: '${namePrefix}-KeyVault'
  params: {
    name: uniqueString('${namePrefix}-KeyVault', resourceGroup().id, subscription().subscriptionId)
    location: location
    tags: union(tags, { UsedBy: 'Bastion', Purpose: 'SSH Key storage' })
    lock: lock
    enablePurgeProtection: false
    enableSoftDelete: false
    enableRbacAuthorization: true
    sku: 'standard'
  }
}

output actionGroupResourceId string = action_group.outputs.resourceId
output dataCollectionRuleResourceId string = dcr.id
output recoveryVaultName string? = enableBackup ? recoveryVault.outputs.name : null
output diskBackupPolicyName string? = enableBackup ? varBackupPolicyDisksDailyName : null
output keyVaultResourceId string = keyVault.outputs.resourceId
