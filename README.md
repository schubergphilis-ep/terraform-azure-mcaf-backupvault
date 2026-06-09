# terraform-azure-mcaf-backupvault
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_protection_backup_policy_blob_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_blob_storage) | resource |
| [azurerm_data_protection_backup_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault) | resource |
| [azurerm_data_protection_backup_vault_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault_customer_managed_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_vault"></a> [backup\_vault](#input\_backup\_vault) | This variable is an object used to configure the Azure Data Protection Backup Vault.<br/><br/>- `name`                       (Required) - The name of the Backup Vault.<br/>- `location`                   (Required) - The Azure region where the Backup Vault should be created.<br/>- `redundancy`                 (Required) - The redundancy setting for the Backup Vault. Allowed values are `GeoRedundant`, `LocallyRedundant`, and `ZoneRedundant`.<br/>- `immutability`               (Required) - The immutability setting for the Backup Vault. Allowed values are `Disabled`, `Locked`, and `Unlocked`.<br/>- `soft_delete`                (Optional) - The state of soft delete for this Backup Vault. Allowed values are `AlwaysOn`, `Off`, and `On`. Defaults to `On`.<br/>- `soft_delete_retention_days` (Optional) - The number of days for which soft-deleted backups are retained. Defaults to `14`. Required when `soft_delete` is not `Off`.<br/>- `cmk_key_vault_key_id`       (Optional) - The ID of the Key Vault Key used for customer-managed key encryption. Required when `enable_customer_managed_key` is `true`.<pre>hcl<br/>backup_vault = {<br/>  name                       = "bv-example"<br/>  location                   = "westeurope"<br/>  redundancy                 = "GeoRedundant"<br/>  immutability               = "Disabled"<br/>  soft_delete                = "On"<br/>  soft_delete_retention_days = 14<br/>  cmk_key_vault_key_id       = null<br/>}</pre> | <pre>object({<br/>    name                       = string<br/>    location                   = string<br/>    redundancy                 = string<br/>    immutability               = string<br/>    soft_delete                = optional(string, "On")<br/>    soft_delete_retention_days = optional(number, 14)<br/>    cmk_key_vault_key_id       = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_blob_storage_backup_policy"></a> [blob\_storage\_backup\_policy](#input\_blob\_storage\_backup\_policy) | A map of blob storage backup policies to create for the Backup Vault. The map key is used as the policy name.<br/><br/>- `retention_duration`              (Required) - The duration of the retention period, specified in ISO 8601 duration format (e.g., `P30D` for 30 days).<br/>- `backup_repeating_time_intervals` (Required) - A list of repeating time intervals for the backup schedule in ISO 8601 format.<pre>hcl<br/>blob_storage_backup_policy = {<br/>  "daily-policy" = {<br/>    retention_duration              = "P30D"<br/>    backup_repeating_time_intervals = ["R/2025-02-21T14:00:00+00:00/P1D"]<br/>  }<br/>}</pre> | <pre>map(object({<br/>    retention_duration              = string<br/>    backup_repeating_time_intervals = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Recovery Services Vault should be created. | `string` | n/a | yes |
| <a name="input_enable_customer_managed_key"></a> [enable\_customer\_managed\_key](#input\_enable\_customer\_managed\_key) | Whether to enable customer managed key for the backup vault. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_vault_id"></a> [backup\_vault\_id](#output\_backup\_vault\_id) | The ID of the Backup Vault. |
| <a name="output_backup_vault_name"></a> [backup\_vault\_name](#output\_backup\_vault\_name) | The name of the Backup Vault. |
| <a name="output_system_assigned_identity_id"></a> [system\_assigned\_identity\_id](#output\_system\_assigned\_identity\_id) | The principal ID of the system-assigned managed identity of the Backup Vault. |
<!-- END_TF_DOCS -->