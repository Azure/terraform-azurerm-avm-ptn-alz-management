locals {
  resource_group_name        = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].name : data.azurerm_resource_group.management[0].name
  resource_group_resource_id = var.resource_group_creation_enabled ? azurerm_resource_group.management[0].id : data.azurerm_resource_group.management[0].id
}