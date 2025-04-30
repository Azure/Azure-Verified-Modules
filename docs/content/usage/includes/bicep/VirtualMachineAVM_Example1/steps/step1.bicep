module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: '${prefix}-LAW'
    // Non-required parameters
    location: 'westus2'
  }
}
