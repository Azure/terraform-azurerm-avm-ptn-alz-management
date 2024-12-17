locals {
  resource_group_name        = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].name : var.resource_group_name
  resource_group_resource_id = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].id : "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}
