# Azure Landing Zones Management Resources AVM Module

This module deploys the management resource for Azure Landings Zones.

## Features

- Deployment of Log Analytics Workspace.
- Opitional deployment of Azure Automation Account.
- Optional deployment of Azure Resource Group.
- Customizable Log Analytics Solutions.
- Optional deployment of Data Collections Rules.
- Optional deployment of User Assigned Managed Identity.

## Example

```hcl
module "avm-ptn-alz-management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  automation_account_name      = "aa-prod-eus-001"
  location                     = "eastus"
  log_analytics_workspace_name = "law-prod-eus-001"
  resource_group_name          = "rg-management-eus-001"
}
```
