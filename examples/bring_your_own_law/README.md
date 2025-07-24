<!-- BEGIN_TF_DOCS -->
# Basic of the Azure Landings Zones Management Module

This code sample shows how to create the resources using default settings.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_test_automation_account_resource_id"></a> [test\_automation\_account\_resource\_id](#output\_test\_automation\_account\_resource\_id)

Description: value of the resource ID for the Azure Automation Account.

### <a name="output_test_data_collection_rule_ids"></a> [test\_data\_collection\_rule\_ids](#output\_test\_data\_collection\_rule\_ids)

Description: Data Collection Rule Resource Ids.

### <a name="output_test_managed_identity_ids"></a> [test\_managed\_identity\_ids](#output\_test\_managed\_identity\_ids)

Description: User assigned identity IDs.

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