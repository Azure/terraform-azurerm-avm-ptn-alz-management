variable "automation_account_name" {
  type        = string
  description = "The name of the Azure Automation Account to create."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
  nullable    = false
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the resources will be created."
}

variable "automation_account_encryption" {
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = optional(string, null)
  })
  default     = null
  description = "The encryption configuration for the Azure Automation Account."
}

variable "automation_account_identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string), null)
  })
  default     = null
  description = "The identity to assign to the Azure Automation Account."
}

variable "automation_account_local_authentication_enabled" {
  type        = bool
  default     = true
  description = "Whether or not local authentication is enabled for the Azure Automation Account."
  nullable    = false
}

# Adding to support scenarios such as https://learn.microsoft.com/en-us/azure/automation/how-to/region-mappings#supported-mappings-for-log-analytics-and-azure-automation
variable "automation_account_location" {
  type        = string
  default     = null
  description = "The Azure region of the Azure Automation Account to deploy. This suppports overriding the location variable in specific cases."
}

variable "automation_account_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is enabled for the Azure Automation Account."
  nullable    = false
}

variable "automation_account_sku_name" {
  type        = string
  default     = "Basic"
  description = "The name of the SKU for the Azure Automation Account to create."
  nullable    = false
}

variable "data_collection_rules" {
  type = object({
    change_tracking = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
    vm_insights = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
    defender_sql = object({
      enabled                                                = optional(bool, true)
      name                                                   = string
      location                                               = optional(string, null)
      tags                                                   = optional(map(string), null)
      enable_collection_of_sql_queries_for_security_research = optional(bool, false)
    })
  })
  default = {
    change_tracking = {
      name = "dcr-change-tracking"
    }
    vm_insights = {
      name = "dcr-vm-insights"
    }
    defender_sql = {
      name = "dcr-defender-sql"
    }
  }
  description = "Enables customisation of the data collection rules."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "linked_automation_account_creation_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to deploy the Azure Automation Account linked to the Log Analytics Workspace or not."
  nullable    = false
}

variable "log_analytics_solution_plans" {
  type = list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
  default = [
    {
      product   = "OMSGallery/SecurityInsights"
      publisher = "Microsoft"
    },
  ]
  description = "The Log Analytics Solution Plans to create."
  nullable    = false
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  type        = bool
  default     = true
  description = "Whether or not to allow resource-only permissions for the Log Analytics Workspace."
  nullable    = false
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type        = bool
  default     = null
  description = "Whether or not to force the use of customer-managed keys for query in the Log Analytics Workspace."
}

variable "log_analytics_workspace_daily_quota_gb" {
  type        = number
  default     = null
  description = "The daily ingestion quota in GB for the Log Analytics Workspace."
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  type        = bool
  default     = true
  description = "Whether or not internet ingestion is enabled for the Log Analytics Workspace."
  nullable    = false
}

variable "log_analytics_workspace_internet_query_enabled" {
  type        = bool
  default     = true
  description = "Whether or not internet query is enabled for the Log Analytics Workspace."
  nullable    = false
}

variable "log_analytics_workspace_local_authentication_disabled" {
  type        = bool
  default     = false
  description = "Whether or not local authentication is disabled for the Log Analytics Workspace."
  nullable    = false
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  type        = number
  default     = null
  description = "The reservation capacity in GB per day for the Log Analytics Workspace."
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  default     = 30
  description = "The number of days to retain data for the Log Analytics Workspace."
  nullable    = false
}

variable "log_analytics_workspace_sku" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU to use for the Log Analytics Workspace."
  nullable    = false
}

variable "resource_group_creation_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to deploy the Azure Resource Group or not."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to apply to the resources created."
}

variable "user_assigned_managed_identities" {
  type = object({
    ama = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
  })
  default = {
    ama = {
      name = "uami-ama"
    }
  }
  description = "Enables customisation of the user assigned managed identities."
}

variable "sentinel_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to deploy the Sentinel onboardingStates configuration or not."
  nullable    = false
}
