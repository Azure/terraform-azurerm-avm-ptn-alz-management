locals {
  data_collection_rule_change_tracking = var.data_collection_rules.change_tracking.enabled ? {
    change_tracking = {
      name                      = var.data_collection_rules.change_tracking.name
      type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
      parent_id                 = local.resource_group_resource_id
      location                  = var.data_collection_rules.change_tracking.location == null ? var.location : var.data_collection_rules.change_tracking.location
      schema_validation_enabled = true
      tags                      = var.data_collection_rules.change_tracking.tags == null ? var.tags : var.data_collection_rules.change_tracking.tags
      body = {
        properties = {
          description = "Data collection rule for CT"
          dataSources = {
            extensions = [
              {
                streams = [
                  "Microsoft-ConfigurationChange",
                  "Microsoft-ConfigurationChangeV2",
                  "Microsoft-ConfigurationData"
                ]
                extensionName = "ChangeTracking-Windows"
                extensionSettings = {
                  enableFiles     = true,
                  enableSoftware  = true,
                  enableRegistry  = true,
                  enableServices  = true,
                  enableInventory = true,
                  registrySettings = {
                    registryCollectionFrequency = 3600
                    registryInfo = [
                      {
                        name        = "Registry_1",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Startup",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_2",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Shutdown",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_3",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_4",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_5",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\ShellEx\\ContextMenuHandlers",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_6",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Background\\ShellEx\\ContextMenuHandlers",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_7",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Shellex\\CopyHookHandlers",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_8",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_9",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_10",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_11",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_12",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Extensions",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_13",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Internet Explorer\\Extensions",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_14",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_15",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_16",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls",
                        valueName   = ""
                      },
                      {
                        name        = "Registry_17",
                        groupTag    = "Recommended",
                        enabled     = false,
                        recurse     = true,
                        description = "",
                        keyName     = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify",
                        valueName   = ""
                      }
                    ]
                  }
                  fileSettings = {
                    fileCollectionFrequency = 2700,
                  },
                  softwareSettings = {
                    softwareCollectionFrequency = 1800
                  },
                  inventorySettings = {
                    inventoryCollectionFrequency = 36000
                  },
                  servicesSettings = {
                    serviceCollectionFrequency = 1800
                  }
                }
                name = "CTDataSource-Windows"
              },
              {
                streams = [
                  "Microsoft-ConfigurationChange",
                  "Microsoft-ConfigurationChangeV2",
                  "Microsoft-ConfigurationData"
                ]
                extensionName = "ChangeTracking-Linux"
                extensionSettings = {
                  enableFiles     = true,
                  enableSoftware  = true,
                  enableRegistry  = false,
                  enableServices  = true,
                  enableInventory = true,
                  fileSettings = {
                    fileCollectionFrequency = 900,
                    fileInfo = [
                      {
                        name                  = "ChangeTrackingLinuxPath_default",
                        enabled               = true,
                        destinationPath       = "/etc/.*.conf",
                        useSudo               = true,
                        recurse               = true,
                        maxContentsReturnable = 5000000,
                        pathType              = "File",
                        type                  = "File",
                        links                 = "Follow",
                        maxOutputSize         = 500000,
                        groupTag              = "Recommended"
                      }
                    ]
                  },
                  softwareSettings = {
                    softwareCollectionFrequency = 300
                  },
                  inventorySettings = {
                    inventoryCollectionFrequency = 36000
                  },
                  servicesSettings = {
                    serviceCollectionFrequency = 300
                  }
                }
                name = "CTDataSource-Linux"
              }
            ]
          }
          destinations = {
            logAnalytics = [
              {
                name                = "Microsoft-CT-Dest"
                workspaceResourceId = azurerm_log_analytics_workspace.management.id
              }
            ]
          }
          dataFlows = [
            {
              streams = [
                "Microsoft-ConfigurationChange",
                "Microsoft-ConfigurationChangeV2",
                "Microsoft-ConfigurationData"
              ]
              destinations = ["Microsoft-CT-Dest"]
            }
          ]
        }
      }
    }
  } : {}
  data_collection_rules = merge(
    local.data_collection_rule_change_tracking,
    local.data_collection_rule_defender_sql,
    local.data_collection_rule_vm_insights
  )
}

locals {
  data_collection_rule_defender_sql = var.data_collection_rules.defender_sql.enabled ? {
    defender_sql = {
      name                      = var.data_collection_rules.defender_sql.name
      parent_id                 = local.resource_group_resource_id
      type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
      location                  = var.data_collection_rules.defender_sql.location == null ? var.location : var.data_collection_rules.defender_sql.location
      schema_validation_enabled = true
      tags                      = var.data_collection_rules.defender_sql.tags == null ? var.tags : var.data_collection_rules.defender_sql.tags
      body = {
        properties = {
          description = "Data collection rule for Defender for SQL.",
          dataSources = {
            extensions = [
              {
                extensionName = "MicrosoftDefenderForSQL",
                name          = "MicrosoftDefenderForSQL",
                streams = [
                  "Microsoft-DefenderForSqlAlerts",
                  "Microsoft-DefenderForSqlLogins",
                  "Microsoft-DefenderForSqlTelemetry",
                  "Microsoft-DefenderForSqlScanEvents",
                  "Microsoft-DefenderForSqlScanResults",
                ],
                extensionSettings = {
                  enableCollectionOfSqlQueriesForSecurityResearch = var.data_collection_rules.defender_sql.enable_collection_of_sql_queries_for_security_research
                }
              }
            ]
          },
          destinations = {
            logAnalytics = [
              {
                workspaceResourceId = azurerm_log_analytics_workspace.management.id,
                name                = "LogAnalyticsDest"
              }
            ]
          },
          dataFlows = [
            {
              streams = [
                "Microsoft-DefenderForSqlAlerts",
                "Microsoft-DefenderForSqlLogins",
                "Microsoft-DefenderForSqlTelemetry",
                "Microsoft-DefenderForSqlScanEvents",
                "Microsoft-DefenderForSqlScanResults",
              ],
              destinations = [
                "LogAnalyticsDest"
              ]
            }
          ]
        }
      }
    }
  } : {}
}

locals {
  data_collection_rule_vm_insights = var.data_collection_rules.vm_insights.enabled ? {
    vm_insights = {
      name                      = var.data_collection_rules.vm_insights.name
      parent_id                 = local.resource_group_resource_id
      type                      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
      location                  = var.data_collection_rules.vm_insights.location == null ? var.location : var.data_collection_rules.vm_insights.location
      tags                      = var.data_collection_rules.vm_insights.tags == null ? var.tags : var.data_collection_rules.vm_insights.tags
      schema_validation_enabled = false
      body = {
        properties = {
          description = "Data collection rule for VM Insights.",
          dataSources = {
            performanceCounters = [
              {
                name = "VMInsightsPerfCounters",
                streams = [
                  "Microsoft-InsightsMetrics"
                ],
                scheduledTransferPeriod    = "PT1M",
                samplingFrequencyInSeconds = 60,
                counterSpecifiers = [
                  "\\VmInsights\\DetailedMetrics"
                ]
              }
            ],
            extensions = [
              {
                streams = [
                  "Microsoft-ServiceMap"
                ],
                extensionName     = "DependencyAgent",
                extensionSettings = {},
                name              = "DependencyAgentDataSource"
              }
            ]
          },
          destinations = {
            logAnalytics = [
              {
                workspaceResourceId = azurerm_log_analytics_workspace.management.id,
                name                = "VMInsightsPerf-Logs-Dest"
              }
            ]
          },
          dataFlows = [
            {
              streams = [
                "Microsoft-InsightsMetrics"
              ],
              destinations = [
                "VMInsightsPerf-Logs-Dest"
              ]
            },
            {
              streams = [
                "Microsoft-ServiceMap"
              ],
              destinations = [
                "VMInsightsPerf-Logs-Dest"
              ]
            }
          ]
        }
      }
    }
  } : {}
}
