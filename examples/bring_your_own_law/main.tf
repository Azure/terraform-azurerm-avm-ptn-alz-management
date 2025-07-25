locals {
  location = "eastus2"
}

resource "random_id" "id" {
  byte_length = 4
}

resource "azurerm_resource_group" "this" {
  location = local.location
  name     = "rg-terraform-${random_id.id.hex}"
}

resource "azurerm_log_analytics_workspace" "this" {
  location            = local.location
  name                = "law-terraform-${random_id.id.hex}"
  resource_group_name = azurerm_resource_group.this.name
}

module "management" {
  source = "../.."

  automation_account_name                  = "aa-terraform-${random_id.id.hex}"
  location                                 = local.location
  resource_group_name                      = azurerm_resource_group.this.name
  log_analytics_workspace_creation_enabled = false
  log_analytics_workspace_id               = azurerm_log_analytics_workspace.this.id
  resource_group_creation_enabled          = false
}
