locals {
  resource_group_name        = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].name : var.resource_group_name
  resource_group_resource_id = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].id : provider::azapi::build_resource_id("/subscriptions/${data.azapi_client_config.current.subscription_id}", "Microsoft.Resources/resourceGroups", var.resource_group_name)
}

locals {
  log_analytics_workspace_id   = var.log_analytics_workspace_creation_enabled ? azurerm_log_analytics_workspace.management[0].id : var.log_analytics_workspace_id
  log_analytics_workspace_name = var.log_analytics_workspace_creation_enabled ? azurerm_log_analytics_workspace.management[0].name : provider::azapi::parse_resource_id(var.log_analytics_workspace_id).name
}
