resource "random_id" "id" {
  byte_length = 4
}

module "management" {
  source = "../.."

  automation_account_name      = "aa-terraform-azure"
  location                     = "eastus"
  log_analytics_workspace_name = "law-terraform-azure"
  resource_group_name          = "rg-terraform-${random_id.id.hex}"
}

