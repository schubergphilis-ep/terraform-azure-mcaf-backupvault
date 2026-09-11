variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Recovery Services Vault should be created."
}

variable "backup_vault" {
  type = object({
    name                         = string
    location                     = string
    redundancy                   = string
    immutability                 = string
    cross_region_restore_enabled = optional(bool, null)
    soft_delete                  = optional(string, "On")
    soft_delete_retention_days   = optional(number, 14)
    cmk_key_vault_key_id         = optional(string, null)
  })
  description = <<BACKUP_VAULT
This variable is an object used to configure the Azure Data Protection Backup Vault.

- `name`                         (Required) - The name of the Backup Vault.
- `location`                     (Required) - The Azure region where the Backup Vault should be created.
- `redundancy`                   (Required) - The redundancy setting for the Backup Vault. Allowed values are `GeoRedundant`, `LocallyRedundant`, and `ZoneRedundant`.
- `immutability`                 (Required) - The immutability setting for the Backup Vault. Allowed values are `Disabled`, `Locked`, and `Unlocked`.
- `cross_region_restore_enabled` (Optional) - Whether to enable cross-region restore. Only valid when `redundancy` is `GeoRedundant`, where it defaults to `true`. Setting it to `true` with any other redundancy is a validation error; `false` or unset are accepted and have no effect. Cannot be disabled once enabled - Azure forces replacement of the vault.
- `soft_delete`                  (Optional) - The state of soft delete for this Backup Vault. Allowed values are `AlwaysOn`, `Off`, and `On`. Defaults to `On`.
- `soft_delete_retention_days`   (Optional) - The number of days for which soft-deleted backups are retained. Defaults to `14`. Required when `soft_delete` is not `Off`.
- `cmk_key_vault_key_id`         (Optional) - The ID of the Key Vault Key used for customer-managed key encryption. Required when `enable_customer_managed_key` is `true`.

```hcl
backup_vault = {
  name                         = "bv-example"
  location                     = "westeurope"
  redundancy                   = "GeoRedundant"
  immutability                 = "Disabled"
  cross_region_restore_enabled = true
  soft_delete                  = "On"
  soft_delete_retention_days   = 14
  cmk_key_vault_key_id         = null
}
```
BACKUP_VAULT

  validation {
    condition     = var.backup_vault.cross_region_restore_enabled != true || var.backup_vault.redundancy == "GeoRedundant"
    error_message = "cross_region_restore_enabled can only be true when redundancy is \"GeoRedundant\"."
  }
}

variable "enable_customer_managed_key" {
  type        = bool
  description = "Whether to enable customer managed key for the backup vault."
  default     = false
}

variable "blob_storage_backup_policy" {
  type = map(object({
    retention_duration              = string
    backup_repeating_time_intervals = list(string)
  }))
  description = <<BLOB_STORAGE_BACKUP_POLICY
A map of blob storage backup policies to create for the Backup Vault. The map key is used as the policy name.

- `retention_duration`              (Required) - The duration of the retention period, specified in ISO 8601 duration format (e.g., `P30D` for 30 days).
- `backup_repeating_time_intervals` (Required) - A list of repeating time intervals for the backup schedule in ISO 8601 format.

```hcl
blob_storage_backup_policy = {
  "daily-policy" = {
    retention_duration              = "P30D"
    backup_repeating_time_intervals = ["R/2025-02-21T14:00:00+00:00/P1D"]
  }
}
```
BLOB_STORAGE_BACKUP_POLICY
}
