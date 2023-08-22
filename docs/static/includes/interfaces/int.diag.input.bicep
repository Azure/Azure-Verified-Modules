diagnosticSettings: [
  {
    retentionInDays: 30
    logCategoriesAndGroups: ['allLogs']
    metricCategories: ['AllMetrics']
    logAnalyticsDestinationType: 'Dedicated'
    workspaceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}'
    storageAccountId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}'
    eventHubAuthorizationRuleId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationrules/{authorizationRuleName}'
    eventHubName: '{eventHubName}'
    marketplacePartnerId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{partnerResourceProvider}/{partnerResourceType}/{partnerResourceName}'
  }
]
