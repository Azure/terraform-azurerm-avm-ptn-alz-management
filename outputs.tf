output "automation_account" {
  description = "A curated output of the Azure Automation Account."
  value = {
    dsc_server_endpoint = try(azurerm_automation_account.management[0].dsc_server_endpoint, null)
    hybrid_service_url  = try(azurerm_automation_account.management[0].hybrid_service_url, null)
    id                  = try(azurerm_automation_account.management[0].id, null)
    name                = try(azurerm_automation_account.management[0].name, null)
    identity = {
      tenant_id    = try(azurerm_automation_account.management[0].identity[0].tenant_id, null)
      principal_id = try(azurerm_automation_account.management[0].identity[0].principal_id, null)
    }
  }
}

output "automation_account_dsc_keys" {
  description = "Sensitive values for the Azure Automation Account."
  sensitive   = true
  value = {
    primary   = try(azurerm_automation_account.management[0].dsc_primary_access_key, null)
    secondary = try(azurerm_automation_account.management[0].dsc_secondary_access_key, null)
  }
}

output "data_collection_rule_ids" {
  description = "Data Collection Rule Resource Ids."
  value = { for key, value in azapi_resource.data_collection_rule : key => {
    id = value.id
    }
  }
}

output "log_analytics_workspace" {
  description = "A curated output of the Log Analytics Workspace."
  value = {
    id           = try(azurerm_log_analytics_workspace.management[0].id, null)
    name         = try(azurerm_log_analytics_workspace.management[0].name, null)
    workspace_id = try(azurerm_log_analytics_workspace.management[0].workspace_id, null)
  }
}

output "log_analytics_workspace_keys" {
  description = "Sensitive values for the Log Analytics Workspace."
  sensitive   = true
  value = {
    primary   = try(azurerm_log_analytics_workspace.management[0].primary_shared_key, null)
    secondary = try(azurerm_log_analytics_workspace.management[0].secondary_shared_key, null)
  }
}

output "resource_group" {
  description = "A curated output of the Azure Resource Group."
  value = {
    id   = local.resource_group_resource_id
    name = local.resource_group_name
  }
}

output "resource_id" {
  description = "The resource ID of the Log Analytics Workspace."
  value       = try(azurerm_log_analytics_workspace.management[0].id, null)
}

output "user_assigned_identity_ids" {
  description = "User assigned identity IDs."
  value = { for key, value in azurerm_user_assigned_identity.management : key => {
    id = value.id
    }
  }
}
