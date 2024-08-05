resource "random_id" "id" {
  byte_length = 4
}

module "management" {
  source = "../.."

  automation_account_name      = "aa-terraform-${random_id.id.hex}"
  location                     = "eastus"
  log_analytics_workspace_name = "law-terraform-${random_id.id.hex}"
  resource_group_name          = "rg-terraform-${random_id.id.hex}"
}
