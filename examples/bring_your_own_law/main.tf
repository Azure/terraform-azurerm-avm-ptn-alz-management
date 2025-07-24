resource "random_id" "id" {
  byte_length = 4
}

module "management" {
  source = "../.."

  automation_account_name                  = "aa-terraform-${random_id.id.hex}"
  location                                 = "eastus"
  resource_group_name                      = "<EXISTING_RESOURCE_GROUP_NAME>"
  log_analytics_workspace_creation_enabled = false
  log_analytics_workspace_id               = "<EXISTING_LOG_ANALYTICS_WORKSPACE_ID>"
  resource_group_creation_enabled          = false
}
