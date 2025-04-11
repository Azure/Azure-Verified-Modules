param actionGroupResourceId string
param vmName string
param vmResourceId string
// import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
// param lock lockType

param availableMemoryBytesAlertThreshold int = 536870912 // 0,5GB

module metric_alert_rule_availableMemoryBytes 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-availableMemoryBytes'
  params: {
    name: 'Metric Alert - Available Memory Bytes'
    criteria: {
      allof: [
        {
          name: 'Available Memory Bytes'
          metricName: 'Available Memory Bytes'
          operator: 'LessThan'
          threshold: availableMemoryBytesAlertThreshold
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_osDiskIopsConsumed 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-operatingSystemDiskIopsConsumed'
  params: {
    name: 'Metric Alert - OS Disk IOPS Consumed Percentage'
    criteria: {
      allof: [
        {
          name: 'OS Disk IOPS Consumed Percentage'
          metricName: 'OS Disk IOPS Consumed Percentage'
          operator: 'GreaterThan'
          threshold: 95
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_dataDiskIopsConsumed 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-dataDiskIopsConsumed'
  params: {
    name: 'Metric Alert - Data Disk IOPS Consumed'
    criteria: {
      allof: [
        {
          name: 'Data Disk IOPS Consumed Percentage'
          metricName: 'Data Disk IOPS Consumed Percentage'
          operator: 'GreaterThan'
          threshold: 95
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_networkIn 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-networkInTotal'
  params: {
    name: 'Metric Alert - Network In Total'
    criteria: {
      allof: [
        {
          name: 'Network In Total'
          metricName: 'Network In Total'
          operator: 'GreaterThan'
          threshold: 500000000000
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_networkOut 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-networkOutTotal'
  params: {
    name: 'Metric Alert - Network Out Total'
    criteria: {
      allof: [
        {
          name: 'Network Out Total'
          metricName: 'Network Out Total'
          operator: 'GreaterThan'
          threshold: 200000000000
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_percentageCpu 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-percentageCpu'
  params: {
    name: 'Metric Alert - Percentage CPU'
    criteria: {
      allof: [
        {
          name: 'Percentage CPU'
          metricName: 'Percentage CPU'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}

module metric_alert_rule_vmAvailability 'br/public:avm/res/insights/metric-alert:0.3.2' = {
  name: '${vmName}-metric-alert-vmAvailability'
  params: {
    name: 'Metric Alert - VM Availability (Preview)'
    criteria: {
      allof: [
        {
          name: 'VM Availability Metric (Preview)'
          metricName: 'VmAvailabilityMetric'
          operator: 'LessThan'
          threshold: 1
          timeAggregation: 'Minimum'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [actionGroupResourceId]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [vmResourceId]
    windowSize: 'PT5M'
  }
}
