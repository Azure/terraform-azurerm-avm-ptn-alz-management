locals {
  resource_group_name        = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].name : var.resource_group_name
  resource_group_resource_id = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].id : provider::azapi::build_resource_id("/subscriptions/${data.azapi_client_config.current.subscription_id}", "Microsoft.Resources/resourceGroups", var.resource_group_name)


  enabled_data_collection_rules = {
    for rule_name, rule_config in var.data_collection_rules : rule_name => rule_config
    if rule_config.enabled
  }

  resource_locks_processed = merge(
    {
      for lock_name, lock_config in var.management_resource_locks : lock_name => {
        lock_level = lock_config.lock_level
        scope = (
          lock_name == "log_analytics" ? azurerm_log_analytics_workspace.management.id :
          lock_name == "automation_account" ? azurerm_automation_account.management[0].id :
          lock_name == "user_assigned_identities" ? azurerm_user_assigned_identity.management["ama"].id : null
        )
        } if lock_config.enabled && (
        # Check if the corresponding resource actually exists using the same variables
        lock_name == "log_analytics" ? true : # Log analytics always exists  
        lock_name == "automation_account" ? var.linked_automation_account_creation_enabled :
        lock_name == "user_assigned_identities" ? var.user_assigned_managed_identities.ama.enabled :
        false
      ) && lock_name != "data_collection_rules" # Exclude DCR from single resource handling
    },
    var.management_resource_locks.data_collection_rules.enabled ? {
      for rule_name, rule_config in local.enabled_data_collection_rules : "data_collection_rules_${rule_name}" => {
        lock_level = var.management_resource_locks.data_collection_rules.lock_level
        scope      = azapi_resource.data_collection_rule[rule_name].id
      }
    } : {}
  )
}

locals {
  log_analytics_workspace_id   = var.log_analytics_workspace_creation_enabled ? azurerm_log_analytics_workspace.management[0].id : var.log_analytics_workspace_id
  log_analytics_workspace_name = var.log_analytics_workspace_creation_enabled ? azurerm_log_analytics_workspace.management[0].name : provider::azapi::parse_resource_id("Microsoft.OperationalInsights/workspaces", var.log_analytics_workspace_id).name
}
