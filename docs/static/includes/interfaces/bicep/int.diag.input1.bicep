diagnosticSettings: [
  {
    name: 'diagSetting1'
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
    logAnalyticsDestinationType: 'Dedicated'
    workspaceResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}'
    storageAccountResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}'
    eventHubAuthorizationRuleResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationrules/{authorizationRuleName}'
    eventHubName: '{eventHubName}'
    marketplacePartnerResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{partnerResourceProvider}/{partnerResourceType}/{partnerResourceName}'
  }
]
