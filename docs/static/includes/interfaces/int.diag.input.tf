diagnostic_settings = {
  diag_setting_1 = {
    retention_in_days : 30
    log_categories_and_groups : ["allLogs"]
    metric_categories : ["AllMetrics"]
    log_analytics_destination_type : "Dedicated"
    workspace_resource_id : "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}"
    storage_account_resource_id : "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}"
    event_hub_authorization_rule_resource_id : "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationrules/{authorizationRuleName}"
    event_hub_name : "{eventHubName}"
    marketplace_partner_resource_id : "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{partnerResourceProvider}/{partnerResourceType}/{partnerResourceName}"
  }
}
