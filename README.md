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

## Contributing

### Pre-Commit, Pr-Check, and Test

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

NOTE: If an error occurs in Powershell that indicates `Argument or block definition required` for `unit-fixture/locals.tf` and/or `unit-fixture/variables.tf`, the issue could be that the symlink is not configured properly.  This can be fixed as described in [this link](https://stackoverflow.com/questions/5917249/git-symbolic-links-in-windows/59761201#59761201):

```shell
git config core.symlinks true
```

Then switch branches, or execute git reset:

```shell
git reset --hard HEAD
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirements (We strongly recommend you run the following command before you commit):

```shell
docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0, < 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_log_analytics_linked_service.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurerm_log_analytics_solution.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [random_id.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account_encryption"></a> [automation\_account\_encryption](#input\_automation\_account\_encryption) | The encryption configuration for the Azure Automation Account. | <pre>object({<br>    key_vault_key_id          = string<br>    user_assigned_identity_id = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_automation_account_identity"></a> [automation\_account\_identity](#input\_automation\_account\_identity) | The identity to assign to the Azure Automation Account. | <pre>object({<br>    type         = string<br>    identity_ids = optional(set(string), null)<br>  })</pre> | `null` | no |
| <a name="input_automation_account_local_authentication_enabled"></a> [automation\_account\_local\_authentication\_enabled](#input\_automation\_account\_local\_authentication\_enabled) | Whether or not local authentication is enabled for the Azure Automation Account. | `bool` | `true` | no |
| <a name="input_automation_account_location"></a> [automation\_account\_location](#input\_automation\_account\_location) | The Azure region of the Azure Automation Account to deploy. This suppports overriding the location variable in specific cases. | `string` | `null` | no |
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | The name of the Azure Automation Account to create. | `string` | n/a | yes |
| <a name="input_automation_account_public_network_access_enabled"></a> [automation\_account\_public\_network\_access\_enabled](#input\_automation\_account\_public\_network\_access\_enabled) | Whether or not public network access is enabled for the Azure Automation Account. | `bool` | `true` | no |
| <a name="input_automation_account_sku_name"></a> [automation\_account\_sku\_name](#input\_automation\_account\_sku\_name) | The name of the SKU for the Azure Automation Account to create. | `string` | `"Basic"` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | This variable controls whether or not telemetry is enabled for the module.<br>For more information see https://aka.ms/avm/telemetryinfo.<br>If it is set to false, then no telemetry will be collected. | `bool` | `true` | no |
| <a name="input_linked_automation_account_creation_enabled"></a> [linked\_automation\_account\_creation\_enabled](#input\_linked\_automation\_account\_creation\_enabled) | A boolean flag to determine whether to deploy the Azure Automation Account linked to the Log Analytics Workspace or not. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resources will be deployed. | `string` | n/a | yes |
| <a name="input_log_analytics_solution_plans"></a> [log\_analytics\_solution\_plans](#input\_log\_analytics\_solution\_plans) | The Log Analytics Solution Plans to create. | <pre>list(object({<br>    product   = string<br>    publisher = optional(string, "Microsoft")<br>  }))</pre> | <pre>[<br>  {<br>    "product": "OMSGallery/AgentHealthAssessment",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/AntiMalware",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/ChangeTracking",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/ContainerInsights",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/Security",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/SecurityInsights",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/ServiceMap",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/SQLAdvancedThreatProtection",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/SQLAssessment",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/SQLVulnerabilityAssessment",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/Updates",<br>    "publisher": "Microsoft"<br>  },<br>  {<br>    "product": "OMSGallery/VMInsights",<br>    "publisher": "Microsoft"<br>  }<br>]</pre> | no |
| <a name="input_log_analytics_workspace_allow_resource_only_permissions"></a> [log\_analytics\_workspace\_allow\_resource\_only\_permissions](#input\_log\_analytics\_workspace\_allow\_resource\_only\_permissions) | Whether or not to allow resource-only permissions for the Log Analytics Workspace. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_cmk_for_query_forced"></a> [log\_analytics\_workspace\_cmk\_for\_query\_forced](#input\_log\_analytics\_workspace\_cmk\_for\_query\_forced) | Whether or not to force the use of customer-managed keys for query in the Log Analytics Workspace. | `bool` | `null` | no |
| <a name="input_log_analytics_workspace_daily_quota_gb"></a> [log\_analytics\_workspace\_daily\_quota\_gb](#input\_log\_analytics\_workspace\_daily\_quota\_gb) | The daily ingestion quota in GB for the Log Analytics Workspace. | `number` | `null` | no |
| <a name="input_log_analytics_workspace_internet_ingestion_enabled"></a> [log\_analytics\_workspace\_internet\_ingestion\_enabled](#input\_log\_analytics\_workspace\_internet\_ingestion\_enabled) | Whether or not internet ingestion is enabled for the Log Analytics Workspace. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_internet_query_enabled"></a> [log\_analytics\_workspace\_internet\_query\_enabled](#input\_log\_analytics\_workspace\_internet\_query\_enabled) | Whether or not internet query is enabled for the Log Analytics Workspace. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_local_authentication_disabled"></a> [log\_analytics\_workspace\_local\_authentication\_disabled](#input\_log\_analytics\_workspace\_local\_authentication\_disabled) | Whether or not local authentication is disabled for the Log Analytics Workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | The name of the Log Analytics Workspace to create. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_reservation_capacity_in_gb_per_day"></a> [log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day](#input\_log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day) | The reservation capacity in GB per day for the Log Analytics Workspace. | `number` | `null` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | The number of days to retain data for the Log Analytics Workspace. | `number` | `30` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The SKU to use for the Log Analytics Workspace. | `string` | `"PerGB2018"` | no |
| <a name="input_resource_group_creation_enabled"></a> [resource\_group\_creation\_enabled](#input\_resource\_group\_creation\_enabled) | A boolean flag to determine whether to deploy the Azure Resource Group or not. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure Resource Group where the resources will be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the resources created. | `map(string)` | `{}` | no |
| <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled) | Whether enable tracing tags that generated by BridgeCrew Yor. | `bool` | `false` | no |
| <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix) | Default prefix for generated tracing tags | `string` | `"avm_"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_automation_account"></a> [automation\_account](#output\_automation\_account) | A curated output of the Azure Automation Account. |
| <a name="output_log_analytics_workspace"></a> [log\_analytics\_workspace](#output\_log\_analytics\_workspace) | A curated output of the Log Analytics Workspace. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | A curated output of the Azure Resource Group. |
<!-- END_TF_DOCS -->
