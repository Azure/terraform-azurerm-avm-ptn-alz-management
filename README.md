<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-ptn-alz-management

This module deploys a Log Analytics Workspace in Azure with Log Analytics Solutions and a linked Azure Automation Account.

## Features

- Deployment of Log Analytics Workspace.
- Opitional deployment of Azure Automation Account.
- Optional deployment of Azure Resource Group.
- Customizable Log Analytics Solutions.

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

## Enable or Disable Tracing Tags

We're using [BridgeCrew Yor](https://github.com/bridgecrewio/yor) and [yorbox](https://github.com/lonegunmanb/yorbox) to help manage tags consistently across infrastructure as code (IaC) frameworks. This adds accountability for the code responsible for deploying the particular Azure resources. In this module you might see tags like:

```hcl
resource "azurerm_resource_group" "management" {
  count = var.resource_group_creation_enabled ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "ba28d2019d124ec455bed690e553fe9c7e4e2780"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-15 11:25:58"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-avm-ptn-alz-management"
    avm_yor_name             = "management"
    avm_yor_trace            = "00a12560-70eb-4d00-81b9-d4059bc7ed62"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}
```

To enable tracing tags, set the `tracing_tags_enabled` variable to true:

```hcl
module "example" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  automation_account_name      = "aa-prod-eus-001"
  location                     = "eastus"
  log_analytics_workspace_name = "law-prod-eus-001"
  resource_group_name          = "rg-management-eus-001"

  tracing_tags_enabled = true
}
```

The `tracing_tags_enabled` is defaulted to `false`.

To customize the prefix for your tracing tags, set the `tracing_tags_prefix` variable value in your Terraform configuration:

```hcl
module "example" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  automation_account_name      = "aa-prod-eus-001"
  location                     = "eastus"
  log_analytics_workspace_name = "law-prod-eus-001"
  resource_group_name          = "rg-management-eus-001"

  tracing_tags_enabled = true
  tracing_tags_prefix  = "custom_prefix_"
}
```

The actual applied tags would be:

```text
{
  custom_prefix_git_commit           = "ba28d2019d124ec455bed690e553fe9c7e4e2780"
  custom_prefix_git_file             = "main.tf"
  custom_prefix_git_last_modified_at = "2023-05-15 11:25:58"
  custom_prefix_git_org              = "Azure"
  custom_prefix_git_repo             = "terraform-azurerm-avm-ptn-alz-management"
  custom_prefix_yor_trace            = "00a12560-70eb-4d00-81b9-d4059bc7ed62"
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.0, < 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.0, < 4.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0)

## Resources

The following resources are used by this module:

- [azurerm_automation_account.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) (resource)
- [azurerm_log_analytics_linked_service.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) (resource)
- [azurerm_log_analytics_solution.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) (resource)
- [azurerm_log_analytics_workspace.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_resource_group.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [random_id.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name)

Description: The name of the Azure Automation Account to create.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region where the resources will be deployed.

Type: `string`

### <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name)

Description: The name of the Log Analytics Workspace to create.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the Azure Resource Group where the resources will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_automation_account_encryption"></a> [automation\_account\_encryption](#input\_automation\_account\_encryption)

Description: The encryption configuration for the Azure Automation Account.

Type:

```hcl
object({
    key_vault_key_id          = string
    user_assigned_identity_id = optional(string, null)
  })
```

Default: `null`

### <a name="input_automation_account_identity"></a> [automation\_account\_identity](#input\_automation\_account\_identity)

Description: The identity to assign to the Azure Automation Account.

Type:

```hcl
object({
    type         = string
    identity_ids = optional(set(string), null)
  })
```

Default: `null`

### <a name="input_automation_account_local_authentication_enabled"></a> [automation\_account\_local\_authentication\_enabled](#input\_automation\_account\_local\_authentication\_enabled)

Description: Whether or not local authentication is enabled for the Azure Automation Account.

Type: `bool`

Default: `true`

### <a name="input_automation_account_location"></a> [automation\_account\_location](#input\_automation\_account\_location)

Description: The Azure region of the Azure Automation Account to deploy. This suppports overriding the location variable in specific cases.

Type: `string`

Default: `null`

### <a name="input_automation_account_public_network_access_enabled"></a> [automation\_account\_public\_network\_access\_enabled](#input\_automation\_account\_public\_network\_access\_enabled)

Description: Whether or not public network access is enabled for the Azure Automation Account.

Type: `bool`

Default: `true`

### <a name="input_automation_account_sku_name"></a> [automation\_account\_sku\_name](#input\_automation\_account\_sku\_name)

Description: The name of the SKU for the Azure Automation Account to create.

Type: `string`

Default: `"Basic"`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_linked_automation_account_creation_enabled"></a> [linked\_automation\_account\_creation\_enabled](#input\_linked\_automation\_account\_creation\_enabled)

Description: A boolean flag to determine whether to deploy the Azure Automation Account linked to the Log Analytics Workspace or not.

Type: `bool`

Default: `true`

### <a name="input_log_analytics_solution_plans"></a> [log\_analytics\_solution\_plans](#input\_log\_analytics\_solution\_plans)

Description: The Log Analytics Solution Plans to create.

Type:

```hcl
list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
```

Default:

```json
[
  {
    "product": "OMSGallery/AgentHealthAssessment",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/AntiMalware",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/ChangeTracking",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/ContainerInsights",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/Security",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/SecurityInsights",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/ServiceMap",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/SQLAdvancedThreatProtection",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/SQLAssessment",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/SQLVulnerabilityAssessment",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/Updates",
    "publisher": "Microsoft"
  },
  {
    "product": "OMSGallery/VMInsights",
    "publisher": "Microsoft"
  }
]
```

### <a name="input_log_analytics_workspace_allow_resource_only_permissions"></a> [log\_analytics\_workspace\_allow\_resource\_only\_permissions](#input\_log\_analytics\_workspace\_allow\_resource\_only\_permissions)

Description: Whether or not to allow resource-only permissions for the Log Analytics Workspace.

Type: `bool`

Default: `true`

### <a name="input_log_analytics_workspace_cmk_for_query_forced"></a> [log\_analytics\_workspace\_cmk\_for\_query\_forced](#input\_log\_analytics\_workspace\_cmk\_for\_query\_forced)

Description: Whether or not to force the use of customer-managed keys for query in the Log Analytics Workspace.

Type: `bool`

Default: `null`

### <a name="input_log_analytics_workspace_daily_quota_gb"></a> [log\_analytics\_workspace\_daily\_quota\_gb](#input\_log\_analytics\_workspace\_daily\_quota\_gb)

Description: The daily ingestion quota in GB for the Log Analytics Workspace.

Type: `number`

Default: `null`

### <a name="input_log_analytics_workspace_internet_ingestion_enabled"></a> [log\_analytics\_workspace\_internet\_ingestion\_enabled](#input\_log\_analytics\_workspace\_internet\_ingestion\_enabled)

Description: Whether or not internet ingestion is enabled for the Log Analytics Workspace.

Type: `bool`

Default: `true`

### <a name="input_log_analytics_workspace_internet_query_enabled"></a> [log\_analytics\_workspace\_internet\_query\_enabled](#input\_log\_analytics\_workspace\_internet\_query\_enabled)

Description: Whether or not internet query is enabled for the Log Analytics Workspace.

Type: `bool`

Default: `true`

### <a name="input_log_analytics_workspace_local_authentication_disabled"></a> [log\_analytics\_workspace\_local\_authentication\_disabled](#input\_log\_analytics\_workspace\_local\_authentication\_disabled)

Description: Whether or not local authentication is disabled for the Log Analytics Workspace.

Type: `bool`

Default: `false`

### <a name="input_log_analytics_workspace_reservation_capacity_in_gb_per_day"></a> [log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day](#input\_log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day)

Description: The reservation capacity in GB per day for the Log Analytics Workspace.

Type: `number`

Default: `null`

### <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days)

Description: The number of days to retain data for the Log Analytics Workspace.

Type: `number`

Default: `30`

### <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku)

Description: The SKU to use for the Log Analytics Workspace.

Type: `string`

Default: `"PerGB2018"`

### <a name="input_resource_group_creation_enabled"></a> [resource\_group\_creation\_enabled](#input\_resource\_group\_creation\_enabled)

Description: A boolean flag to determine whether to deploy the Azure Resource Group or not.

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to apply to the resources created.

Type: `map(string)`

Default: `{}`

### <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled)

Description: Whether enable tracing tags that generated by BridgeCrew Yor.

Type: `bool`

Default: `false`

### <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix)

Description: Default prefix for generated tracing tags

Type: `string`

Default: `"avm_"`

## Outputs

The following outputs are exported:

### <a name="output_automation_account"></a> [automation\_account](#output\_automation\_account)

Description: A curated output of the Azure Automation Account.

### <a name="output_log_analytics_workspace"></a> [log\_analytics\_workspace](#output\_log\_analytics\_workspace)

Description: A curated output of the Log Analytics Workspace.

### <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group)

Description: A curated output of the Azure Resource Group.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->