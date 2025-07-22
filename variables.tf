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
  description = "The Azure region of the Azure Automation Account to deploy. This supports overriding the location variable in specific cases."
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
  description = <<DESCRIPTION
Enables customisation of the data collection rules for Azure Monitor.
This is an object with attributes pertaining to the three DCRs that are created by this module.

Each object has the following attributes:

- enabled (Optional) - Whether or not to create the data collection rule. Defaults to `true`.
- name (Required) - The name of the data collection rule. For the default values, see the default variable value.
- location (Optional) - The Azure region of the data collection rule. Defaults to the value of the location variable.
- tags (Optional) - A map of tags to apply to the data collection rule. Defaults to `null`.

The defender_sql object has an additional attribute:

- enable_collection_of_sql_queries_for_security_research (Optional) - Whether or not to enable collection of SQL queries for security research. Defaults to `false`.
DESCRIPTION
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
  default     = false
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
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/VMInsights"
      publisher = "Microsoft"
    },
  ]
  description = <<DESCRIPTION
The Log Analytics Solution Plans to create.
Do not add the SecurityInsights solution plan here, this deployment method is deprecated. Instead refer to `sentinel_onboarding` variable.

The value of this variable is a list of objects with the following attributes:

- product (Required) - The product name of the solution plan, e.g. `OMSGallery/ContainerInsights`.
- publisher (Optional) - The publisher name of the solution plan, e.g. `Microsoft`. Defaults to `Microsoft`.
DESCRIPTION
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

variable "sentinel_onboarding" {
  type = object({
    name                         = optional(string, "default")
    customer_managed_key_enabled = optional(bool, false)
  })
  default     = {}
  description = <<DESCRIPTION
Enables customisation of the Sentinel onboarding. Set to `null` to disable.

This is an object with the following attributes:

- name (Optional) - The name of the Sentinel onboarding object. Defaults to `default`.
- customer_managed_key_enabled (Optional) - Whether or not to enable customer-managed keys for the Sentinel onboarding. Defaults to `false`.
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to apply to the resources created."
}

variable "timeouts" {
  type = object({
    sentinel_onboarding = optional(object({
      create = optional(string, "5m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "5m")
      }), {}
    )
    data_collection_rule = optional(object({
      create = optional(string, "5m")
      delete = optional(string, "10m")
      update = optional(string, "5m")
      read   = optional(string, "5m")
      }), {}
    )
  })
  default     = {}
  description = <<DESCRIPTION
A map of timeouts to apply to the creation and destruction of resources.
If using retry, the maximum elapsed retry time is governed by this value.

The object has attributes for each resource type, with the following optional attributes:

- `create` - (Optional) The timeout for creating the resource. Defaults to `5m`.
- `delete` - (Optional) The timeout for deleting the resource. Defaults to `5m` apart from data_collection_rule, where this is set to `10m`.
- `update` - (Optional) The timeout for updating the resource. Defaults to `5m`.
- `read` - (Optional) The timeout for reading the resource. Defaults to `5m`.

Each time duration is parsed using this function: <https://pkg.go.dev/time#ParseDuration>.
DESCRIPTION
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
  description = <<DESCRIPTION
Enables customisation of the user assigned managed identities.

The value of this variable is an object with the following attributes:

- ama (Required) - The user assigned managed identity for the Azure Monitor Agent.
  - enabled (Optional) - Whether or not to create the user assigned managed identity. Defaults to `true`.
  - name (Required) - The name of the user assigned managed identity, the variable default value is `uami-ama`.
  - location (Optional) - The Azure region of the user assigned managed identity. Defaults to the value of the location variable.
  - tags (Optional) - A map of tags to apply to the user assigned managed identity. Defaults to `null`.
DESCRIPTION
}

variable "management_resource_locks" {
  type = object({
    log_analytics = optional(object({
      enabled    = optional(bool, false)
      lock_level = optional(string, "CanNotDelete")
      }), {
      enabled    = false
      lock_level = "CanNotDelete"
    })
    automation_account = optional(object({
      enabled    = optional(bool, false)
      lock_level = optional(string, "CanNotDelete")
      }), {
      enabled    = false
      lock_level = "CanNotDelete"
    })
    user_assigned_identities = optional(object({
      enabled    = optional(bool, false)
      lock_level = optional(string, "CanNotDelete")
      }), {
      enabled    = false
      lock_level = "CanNotDelete"
    })
    data_collection_rules = optional(object({
      enabled    = optional(bool, false)
      lock_level = optional(string, "CanNotDelete")
      }), {
      enabled    = false
      lock_level = "CanNotDelete"
    })
  })

  validation {
    condition = alltrue([
      contains(["CanNotDelete", "ReadOnly"], var.management_resource_locks.log_analytics.lock_level),
      contains(["CanNotDelete", "ReadOnly"], var.management_resource_locks.automation_account.lock_level),
      contains(["CanNotDelete", "ReadOnly"], var.management_resource_locks.user_assigned_identities.lock_level),
      contains(["CanNotDelete", "ReadOnly"], var.management_resource_locks.data_collection_rules.lock_level)
    ])
    error_message = "All lock_level values must be either 'CanNotDelete' or 'ReadOnly'."
  }
  default     = {}
  description = "Resource Locks that can be assigned to management resources to prevent accidential deletion or modification."
}
