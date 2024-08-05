<!-- BEGIN_TF_DOCS -->
# Complete example for the Azure Lanading Zones Management module

This shows how to use the variables to customise the management resources for Azure Landing Zones.

```hcl
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

  automation_account_name         = "aa-terraform-azure"
  location                        = "westeurope"
  log_analytics_workspace_name    = "law-terraform-azure"
  resource_group_name             = azurerm_resource_group.management.name
  resource_group_creation_enabled = false

  automation_account_identity = {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.management.id]
  }

  automation_account_local_authentication_enabled  = true
  automation_account_public_network_access_enabled = true
  automation_account_sku_name                      = "Basic"
  linked_automation_account_creation_enabled       = true

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
  log_analytics_workspace_reservation_capacity_in_gb_per_day = 200
  log_analytics_workspace_retention_in_days                  = 50
  log_analytics_workspace_sku                                = "CapacityReservation"

  user_assigned_managed_identities = {
    ama = {
      name = "uami-ama-${random_id.id.hex}"
    }
  }

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

  tags = {
    environment = "dev"
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.8)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.107)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_user_assigned_identity.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_test_automation_account_msi_principal_id"></a> [test\_automation\_account\_msi\_principal\_id](#output\_test\_automation\_account\_msi\_principal\_id)

Description: value of the MSI principal ID for the Azure Automation Account.

### <a name="output_test_automation_account_resource_id"></a> [test\_automation\_account\_resource\_id](#output\_test\_automation\_account\_resource\_id)

Description: value of the resource ID for the Azure Automation Account.

### <a name="output_test_log_analytics_workspace_resource_id"></a> [test\_log\_analytics\_workspace\_resource\_id](#output\_test\_log\_analytics\_workspace\_resource\_id)

Description: value of the resource ID for the Log Analytics Workspace.

## Modules

The following Modules are called:

### <a name="module_management"></a> [management](#module\_management)

Source: ../..

Version:

## Usage

Ensure you have Terraform installed and the Azure CLI authenticated to your Azure subscription.

Navigate to the directory containing this configuration and run:

```
terraform init
terraform plan
terraform apply
```
<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

## AVM Versioning Notice

Major version Zero (0.y.z) is for initial development. Anything MAY change at any time. The module SHOULD NOT be considered stable till at least it is major version one (1.0.0) or greater. Changes will always be via new versions being published and no changes will be made to existing published versions. For more details please go to https://semver.org/
<!-- END_TF_DOCS -->