output "test_automation_account_resource_id" {
  description = "value of the resource ID for the Azure Automation Account."
  value       = module.management.automation_account.id
}

output "test_data_collection_rule_ids" {
  description = "Data Collection Rule Resource Ids."
  value       = module.management.data_collection_rule_ids
}

output "test_managed_identity_ids" {
  description = "User assigned identity IDs."
  value       = module.management.user_assigned_identity_ids
}
