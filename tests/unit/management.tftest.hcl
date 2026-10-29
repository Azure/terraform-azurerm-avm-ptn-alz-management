mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
      tenant_id       = "00000000-0000-0000-0000-000000000001"
    }
  }
}

mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-unit"
    }
  }

  mock_resource "azurerm_log_analytics_workspace" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-unit/providers/Microsoft.OperationalInsights/workspaces/law-unit"
    }
  }

  mock_resource "azurerm_automation_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-unit/providers/Microsoft.Automation/automationAccounts/aa-unit"
    }
  }
}

mock_provider "modtm" {}
mock_provider "random" {}

variables {
  automation_account_name      = "aa-unit"
  enable_telemetry             = false
  location                     = "eastus2"
  log_analytics_workspace_name = "law-unit"
  resource_group_name          = "rg-unit"
}

run "managed_defaults" {
  command = apply

  assert {
    condition     = length(azurerm_resource_group.management) == 1 && length(azurerm_log_analytics_workspace.management) == 1
    error_message = "The default configuration must create a resource group and a Log Analytics workspace."
  }

  assert {
    condition     = output.resource_group.id == azurerm_resource_group.management[0].id && output.log_analytics_workspace.id == azurerm_log_analytics_workspace.management[0].id
    error_message = "Managed resource outputs must reference the resource group and workspace that were created."
  }

  assert {
    condition     = length(azurerm_automation_account.management) == 0 && length(azurerm_log_analytics_linked_service.management) == 0 && length(azapi_resource.sentinel_onboarding) == 0
    error_message = "Automation and Sentinel onboarding must remain disabled by default."
  }

  assert {
    condition     = toset(keys(azurerm_log_analytics_solution.management)) == toset(["Microsoft/OMSGallery/ContainerInsights", "Microsoft/OMSGallery/VMInsights"])
    error_message = "The default solution plans must deploy Container Insights and VM Insights exactly once."
  }

  assert {
    condition     = azurerm_log_analytics_solution.management["Microsoft/OMSGallery/VMInsights"].workspace_resource_id == output.log_analytics_workspace.id
    error_message = "Default solutions must use the managed Log Analytics workspace."
  }

  assert {
    condition     = toset(keys(azapi_resource.data_collection_rule)) == toset(["change_tracking", "defender_sql", "vm_insights"]) && toset(keys(output.data_collection_rule_ids)) == toset(["change_tracking", "defender_sql", "vm_insights"])
    error_message = "All three default data collection rules must be created and included in the ID output."
  }

  assert {
    condition     = toset(keys(azurerm_user_assigned_identity.management)) == toset(["ama"]) && output.user_assigned_identity_ids.ama.id == azurerm_user_assigned_identity.management["ama"].id
    error_message = "The default Azure Monitor Agent identity must appear in the output."
  }
}

run "reuse_existing_workspace_and_group" {
  command = apply

  variables {
    resource_group_creation_enabled          = false
    resource_group_name                      = "rg-existing"
    log_analytics_workspace_creation_enabled = false
    log_analytics_workspace_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.OperationalInsights/workspaces/law-existing"
    log_analytics_solution_plans = [
      { product = "OMSGallery/VMInsights" },
    ]
    data_collection_rules = {
      change_tracking = { enabled = false, name = "dcr-ct" }
      defender_sql    = { name = "dcr-sql" }
      vm_insights     = { enabled = false, name = "dcr-vm" }
    }
    user_assigned_managed_identities = {
      ama = { enabled = false, name = "uami-ama" }
    }
  }

  assert {
    condition     = length(azurerm_resource_group.management) == 0 && length(azurerm_log_analytics_workspace.management) == 0
    error_message = "Reusing a resource group and workspace must not create replacements."
  }

  assert {
    condition     = output.resource_group.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing" && output.resource_group.name == "rg-existing"
    error_message = "The reused resource group's output must contain its canonical ID and name."
  }

  assert {
    condition     = output.resource_id == null && output.log_analytics_workspace.id == null
    error_message = "Managed-workspace outputs must be null when the workspace is provided by the caller."
  }

  assert {
    condition     = azurerm_log_analytics_solution.management["Microsoft/OMSGallery/VMInsights"].workspace_name == "law-existing" && azurerm_log_analytics_solution.management["Microsoft/OMSGallery/VMInsights"].workspace_resource_id == var.log_analytics_workspace_id
    error_message = "Solutions must derive the existing workspace name from its resource ID and use that ID."
  }

  assert {
    condition     = toset(keys(azapi_resource.data_collection_rule)) == toset(["defender_sql"]) && length(azurerm_user_assigned_identity.management) == 0
    error_message = "Per-rule and identity feature flags must suppress the disabled resources."
  }

  assert {
    condition     = azapi_resource.data_collection_rule["defender_sql"].parent_id == output.resource_group.id && azapi_resource.data_collection_rule["defender_sql"].body.properties.destinations.logAnalytics[0].workspaceResourceId == var.log_analytics_workspace_id
    error_message = "The remaining rule must use the existing resource group and workspace IDs."
  }
}

run "linked_automation_account" {
  command = apply

  variables {
    automation_account_location                      = "westus3"
    automation_account_local_authentication_enabled  = false
    automation_account_public_network_access_enabled = false
    linked_automation_account_creation_enabled       = true
    automation_account_identity = {
      type = "SystemAssigned"
    }
  }

  assert {
    condition     = length(azurerm_automation_account.management) == 1 && length(azurerm_log_analytics_linked_service.management) == 1
    error_message = "Enabling linked Automation must create an account and a workspace link."
  }

  assert {
    condition     = azurerm_automation_account.management[0].location == "westus3" && azurerm_automation_account.management[0].resource_group_name == output.resource_group.name
    error_message = "Automation must honor its location override and use the managed resource group."
  }

  assert {
    condition     = azurerm_automation_account.management[0].local_authentication_enabled == false && azurerm_automation_account.management[0].public_network_access_enabled == false && azurerm_automation_account.management[0].identity[0].type == "SystemAssigned"
    error_message = "Automation authentication, network access, and identity inputs must reach the account."
  }

  assert {
    condition     = azurerm_log_analytics_linked_service.management[0].workspace_id == output.log_analytics_workspace.id && azurerm_log_analytics_linked_service.management[0].read_access_id == azurerm_automation_account.management[0].id
    error_message = "The linked service must join the created workspace to the created Automation account."
  }

  assert {
    condition     = output.automation_account.id == azurerm_automation_account.management[0].id && output.automation_account.name == "aa-unit"
    error_message = "The Automation output must identify the linked account."
  }
}

run "sentinel_onboarding_and_timeouts" {
  command = apply

  variables {
    sentinel_onboarding = {
      customer_managed_key_enabled = true
    }
    timeouts = {
      sentinel_onboarding = {
        create = "12m"
        delete = "9m"
      }
    }
  }

  assert {
    condition     = length(azapi_resource.sentinel_onboarding) == 1 && azapi_resource.sentinel_onboarding[0].name == "default"
    error_message = "Enabling Sentinel onboarding must create the default onboarding state."
  }

  assert {
    condition     = azapi_resource.sentinel_onboarding[0].parent_id == output.log_analytics_workspace.id && azapi_resource.sentinel_onboarding[0].body.properties.customerManagedKey == true
    error_message = "Sentinel onboarding must target the managed workspace and honor the key setting."
  }

  assert {
    condition     = azapi_resource.sentinel_onboarding[0].timeouts.create == "12m" && azapi_resource.sentinel_onboarding[0].timeouts.delete == "9m"
    error_message = "Sentinel onboarding must honor custom creation and deletion timeouts."
  }
}

run "per_resource_overrides" {
  command = apply

  variables {
    tags = { owner = "platform" }
    data_collection_rules = {
      change_tracking = { enabled = false, name = "dcr-ct" }
      defender_sql = {
        name                                                   = "dcr-sql"
        location                                               = "westus3"
        tags                                                   = { owner = "sql" }
        enable_collection_of_sql_queries_for_security_research = true
      }
      vm_insights = { name = "dcr-vm" }
    }
    user_assigned_managed_identities = {
      ama = {
        name     = "uami-agent"
        location = "centralus"
        tags     = { owner = "monitoring" }
      }
    }
  }

  assert {
    condition     = toset(keys(azapi_resource.data_collection_rule)) == toset(["defender_sql", "vm_insights"]) && toset(keys(output.data_collection_rule_ids)) == toset(["defender_sql", "vm_insights"])
    error_message = "Only enabled rules must be created and reported in the ID output."
  }

  assert {
    condition     = azapi_resource.data_collection_rule["defender_sql"].location == "westus3" && azapi_resource.data_collection_rule["defender_sql"].tags["owner"] == "sql" && length(azapi_resource.data_collection_rule["defender_sql"].tags) == 1
    error_message = "The Defender for SQL rule must honor its own location and tags."
  }

  assert {
    condition     = azapi_resource.data_collection_rule["defender_sql"].body.properties.dataSources.extensions[0].extensionSettings.enableCollectionOfSqlQueriesForSecurityResearch == true
    error_message = "The security research setting must reach the Defender for SQL data source."
  }

  assert {
    condition     = azapi_resource.data_collection_rule["vm_insights"].location == var.location && azapi_resource.data_collection_rule["vm_insights"].tags == var.tags
    error_message = "VM Insights must fall back to the module location and tags."
  }

  assert {
    condition     = azurerm_user_assigned_identity.management["ama"].location == "centralus" && azurerm_user_assigned_identity.management["ama"].tags["owner"] == "monitoring" && length(azurerm_user_assigned_identity.management["ama"].tags) == 1
    error_message = "The agent identity must honor its own location and tags."
  }

  assert {
    condition     = output.data_collection_rule_ids.defender_sql.id == azapi_resource.data_collection_rule["defender_sql"].id && output.user_assigned_identity_ids.ama.id == azurerm_user_assigned_identity.management["ama"].id
    error_message = "Per-resource ID outputs must reference the corresponding created resources."
  }
}

run "workspace_name_required_when_created" {
  command = plan

  variables {
    log_analytics_workspace_name = null
  }

  expect_failures = [var.log_analytics_workspace_name]
}

run "workspace_id_required_when_reused" {
  command = plan

  variables {
    log_analytics_workspace_creation_enabled = false
    log_analytics_workspace_id               = null
  }

  expect_failures = [var.log_analytics_workspace_id]
}
