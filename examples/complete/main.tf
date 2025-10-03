resource "random_id" "id" {
  byte_length = 4
}

resource "azurerm_resource_group" "management" {
  location = "westeurope"
  name     = "rg-terraform-${random_id.id.hex}"
}

resource "azurerm_user_assigned_identity" "management" {
  location            = azurerm_resource_group.management.location
  name                = "id-terraform-${random_id.id.hex}"
  resource_group_name = azurerm_resource_group.management.name
}

module "management" {
  source = "../.."

  automation_account_name = "aa-terraform-azure"
  location                = "westeurope"
  resource_group_name     = azurerm_resource_group.management.name
  automation_account_identity = {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.management.id]
  }
  automation_account_local_authentication_enabled  = true
  automation_account_public_network_access_enabled = true
  automation_account_sku_name                      = "Basic"
  data_collection_rules = {
    change_tracking = {
      name     = "dcr-change-tracking-${random_id.id.hex}"
      location = azurerm_resource_group.management.location
      tags = {
        testing = "123"
      }
    }
    vm_insights = {
      name = "dcr-vm-insights-${random_id.id.hex}"
    }
    defender_sql = {
      name = "dcr-defender-sql-${random_id.id.hex}"
    }
  }
  linked_automation_account_creation_enabled = true
  log_analytics_solution_plans = [
    {
      product   = "OMSGallery/AgentHealthAssessment"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/AntiMalware"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ChangeTracking"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    },
  ]
  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = true
  log_analytics_workspace_daily_quota_gb                     = 1
  log_analytics_workspace_internet_ingestion_enabled         = true
  log_analytics_workspace_internet_query_enabled             = true
  log_analytics_workspace_name                               = "law-terraform-azure"
  log_analytics_workspace_reservation_capacity_in_gb_per_day = 200
  log_analytics_workspace_retention_in_days                  = 50
  log_analytics_workspace_sku                                = "CapacityReservation"
  resource_group_creation_enabled                            = false
  sentinel_onboarding                                        = {}
  tags = {
    environment = "dev"
  }
  user_assigned_managed_identities = {
    ama = {
      name = "uami-ama-${random_id.id.hex}"
    }
  }
  management_resource_locks = {
    automation_account = {
      enabled = true
    }
    data_collection_rules = {
      enabled    = true
      lock_level = "ReadOnly"
    }
    user_assigned_identities = {
      enabled = true
    }
  }
}
