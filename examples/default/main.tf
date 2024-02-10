module "management" {
  source = "../.."

  automation_account_name      = "aa-terraform-azure"
  location                     = "eastus"
  log_analytics_workspace_name = "law-terraform-azure"
  resource_group_name          = "rg-terraform-azure"
}

