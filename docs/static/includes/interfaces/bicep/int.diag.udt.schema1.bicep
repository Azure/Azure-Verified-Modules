
// ============== //
//   Parameters   //
// ============== //

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The diagnostic settings of the service. If neither metrics nor logs are specified, all metrics & logs are configured by default. If only one of them is specified, the other one will not be configured.')
param diagnosticSettings diagnosticSettingFullType[]?

// ============= //
//   Resources   //
// ============= //

resource >singularMainResourceType<_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: [
      for group in (diagnosticSetting.?metricCategories ?? (empty(diagnosticSetting.?logCategoriesAndGroups)
        ? [{ category: 'AllMetrics' }]
        : [])): {
        category: group.category
        enabled: group.?enabled ?? true
        timeGrain: null
      }
    ]
    logs: [
      for group in (diagnosticSetting.?logCategoriesAndGroups ?? (empty(diagnosticSetting.?metricCategories)
        ? [{ categoryGroup: 'allLogs' }]
        : [])): {
        categoryGroup: group.?categoryGroup
        category: group.?category
        enabled: group.?enabled ?? true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: >singularMainResourceType<
}]
