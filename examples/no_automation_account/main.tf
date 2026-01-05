resource "random_id" "id" {
  byte_length = 4
}

module "management" {
  source = "../.."

  location                                   = "eastus"
  resource_group_name                        = "rg-terraform-${random_id.id.hex}"
  log_analytics_workspace_name               = "law-terraform-${random_id.id.hex}"
  linked_automation_account_creation_enabled = false
}
