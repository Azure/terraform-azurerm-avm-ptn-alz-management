
resource "azapi_resource" "rg" {
  count    = var.resource_group_creation_enabled ? 1 : 0
  type     = "Microsoft.Resources/resourceGroups@2024-03-01"
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

resource "azapi_resource" "log_analytics_workspace" {
  type      = "Microsoft.OperationalInsights/workspaces@2023-09-01"
  location  = var.location
  name      = var.log_analytics_workspace_name
  parent_id = local.resource_group_resource_id
  body = {
    properties = {
      features = {
        enableLogAccessUsingOnlyResourcePermissions = var.log_analytics_workspace_allow_resource_only_permissions
        disableLocalAuth                            = var.log_analytics_workspace_local_authentication_disabled
      }
      forceCmkForQuery                = var.log_analytics_workspace_cmk_for_query_forced
      publicNetworkAccessForIngestion = var.log_analytics_workspace_internet_ingestion_enabled ? "Enabled" : "Disabled"
      publicNetworkAccessForQuery     = var.log_analytics_workspace_internet_query_enabled ? "Enabled" : "Disabled"
      retentionInDays                 = var.log_analytics_workspace_retention_in_days
      sku = {
        name = var.log_analytics_workspace_sku
      }
      workspaceCapping = {
        dailyQuotaGb = var.log_analytics_workspace_daily_quota_gb != null ? var.log_analytics_workspace_daily_quota_gb : -1
      }
    }
  }
  tags = var.tags
}

resource "azapi_resource" "automation_account" {
  count     = var.linked_automation_account_creation_enabled ? 1 : 0
  type      = "Microsoft.Automation/automationAccounts@2023-11-01"
  name      = var.automation_account_name
  parent_id = local.resource_group_resource_id
  location  = var.location

  body = {
    properties = {
      encryption = {
        keySource = var.automation_account_encryption != null ? "Microsoft.Keyvault" : "Microsoft.Automation"
        keyVaultProperties = var.automation_account_encryption != null ? {
          keyName     = ""
          keyVaultUri = ""
          keyVersion  = ""
        } : null
        identity = var.automation_account_encryption != null ? {
          userAssignedIdentity = var.automation_account_encryption.user_assigned_identity_id
        } : null
      }
      publicNetworkAccess = var.automation_account_public_network_access_enabled
      disableLocalAuth    = !var.automation_account_local_authentication_enabled
      sku = {
        name = var.automation_account_sku_name
      }
    }
  }
  dynamic "identity" {
    for_each = var.automation_account_identity != null ? [var.automation_account_identity] : []
    content {
      type         = identity.type
      identity_ids = identity.identity_ids
    }
  }
  tags = var.tags
}

resource "azapi_resource" "automation_account_link_to_log_analytics" {
  count     = var.linked_automation_account_creation_enabled ? 1 : 0
  type      = "Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01"
  parent_id = azapi_resource.log_analytics_workspace.id
  name      = "Automation"
  body = {
    properties = {
      resourceId            = azurerm_automation_account.management[0].id
      writeAccessResourceId = null
    }
  }
}

resource "azapi_resource" "log_analytics_solutions" {
  for_each  = { for plan in toset(var.log_analytics_solution_plans) : "${plan.publisher}/${plan.product}" => plan }
  type      = "Microsoft.OperationsManagement/solutions@2015-11-01-preview"
  parent_id = local.resource_group_resource_id
  name      = "${basename(each.value.product)}(${azapi_resource.log_analytics_workspace.name})"
  body = {
    plan = {
      name      = "${basename(each.value.product)}(${azapi_resource.log_analytics_workspace.name})"
      product   = each.value.product
      publisher = each.value.publisher
    }
    properties = {
      workspaceResourceId = azapi_resource.log_analytics_workspace.id
    }
  }

  depends_on = [
    azapi_resource.automation_account_link_to_log_analytics,
  ]
}

resource "azapi_resource" "sentinel_onboarding" {
  count = var.sentinel_onboarding != null ? 1 : 0

  type = "Microsoft.SecurityInsights/onboardingStates@2024-03-01"
  body = {
    properties = {
      customerManagedKey = var.sentinel_onboarding.customer_managed_key_enabled
    }
  }
  name      = var.sentinel_onboarding.name
  parent_id = azurerm_log_analytics_workspace.management.id
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

  type                      = each.value.type
  body                      = each.value.body
  location                  = each.value.location
  name                      = each.value.name
  parent_id                 = local.resource_group_resource_id
  schema_validation_enabled = each.value.schema_validation_enabled
  tags                      = each.value.tags
}
