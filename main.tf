
resource "azurerm_resource_group" "management" {
  count = var.resource_group_creation_enabled ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "management" {
  count = var.log_analytics_workspace_creation_enabled ? 1 : 0

  location                           = var.location
  name                               = local.log_analytics_workspace_name
  resource_group_name                = local.resource_group_name
  allow_resource_only_permissions    = var.log_analytics_workspace_allow_resource_only_permissions
  cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  local_authentication_enabled       = var.log_analytics_workspace_local_authentication_enabled
  reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  retention_in_days                  = var.log_analytics_workspace_retention_in_days
  sku                                = var.log_analytics_workspace_sku
  tags                               = var.tags
}

resource "azurerm_automation_account" "management" {
  count = var.linked_automation_account_creation_enabled ? 1 : 0

  location                      = coalesce(var.automation_account_location, var.location)
  name                          = var.automation_account_name
  resource_group_name           = local.resource_group_name
  sku_name                      = var.automation_account_sku_name
  local_authentication_enabled  = var.automation_account_local_authentication_enabled
  public_network_access_enabled = var.automation_account_public_network_access_enabled
  tags                          = var.tags

  dynamic "encryption" {
    for_each = var.automation_account_encryption == null ? [] : ["Encryption"]

    content {
      key_vault_key_id          = var.automation_account_encryption.key_vault_key_id
      user_assigned_identity_id = var.automation_account_encryption.user_assigned_identity_id
    }
  }
  dynamic "identity" {
    for_each = var.automation_account_identity == null ? [] : ["Identity"]

    content {
      type         = var.automation_account_identity.type
      identity_ids = var.automation_account_identity.identity_ids
    }
  }
}

resource "azurerm_log_analytics_linked_service" "management" {
  count = var.linked_automation_account_creation_enabled ? 1 : 0

  resource_group_name = local.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.management[0].id
  read_access_id      = azurerm_automation_account.management[0].id
  write_access_id     = null
}

resource "azurerm_log_analytics_solution" "management" {
  for_each = { for plan in toset(var.log_analytics_solution_plans) : "${plan.publisher}/${plan.product}" => plan }

  location              = var.location
  resource_group_name   = local.resource_group_name
  solution_name         = basename(each.value.product)
  workspace_name        = local.log_analytics_workspace_name
  workspace_resource_id = azurerm_log_analytics_workspace.management[0].id
  tags                  = var.tags

  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }

  depends_on = [
    azurerm_log_analytics_linked_service.management,
  ]
}

resource "azapi_resource" "sentinel_onboarding" {
  count = var.sentinel_onboarding != null ? 1 : 0

  name      = var.sentinel_onboarding.name
  parent_id = azurerm_log_analytics_workspace.management[0].id
  type      = "Microsoft.SecurityInsights/onboardingStates@2024-03-01"
  body = {
    properties = {
      customerManagedKey = var.sentinel_onboarding.customer_managed_key_enabled
    }
  }

  timeouts {
    create = var.timeouts.sentinel_onboarding.create
    delete = var.timeouts.sentinel_onboarding.delete
    read   = var.timeouts.sentinel_onboarding.read
    update = var.timeouts.sentinel_onboarding.update
  }
}

resource "azurerm_user_assigned_identity" "management" {
  for_each = local.user_assigned_managed_identities

  location            = each.value.location
  name                = each.value.name
  resource_group_name = local.resource_group_name
  tags                = each.value.tags
}

resource "azapi_resource" "data_collection_rule" {
  for_each = local.data_collection_rules

  location                  = each.value.location
  name                      = each.value.name
  parent_id                 = local.resource_group_resource_id
  type                      = each.value.type
  body                      = each.value.body
  schema_validation_enabled = each.value.schema_validation_enabled
  tags                      = each.value.tags

  timeouts {
    create = var.timeouts.data_collection_rule.create
    delete = var.timeouts.data_collection_rule.delete
    read   = var.timeouts.data_collection_rule.read
    update = var.timeouts.data_collection_rule.update
  }
}
