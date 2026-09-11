locals {
  # Cross-region restore is only valid on GeoRedundant vaults: the provider rejects the
  # argument when it is present at all - even set to false - on other redundancy types,
  # so it must be null there. Defaults to true on GeoRedundant to preserve the module's
  # previous hardcoded behaviour; flipping an enabled vault to false forces replacement.
  cross_region_restore_enabled = (
    var.backup_vault.redundancy == "GeoRedundant"
    ? coalesce(var.backup_vault.cross_region_restore_enabled, true)
    : null
  )
}

resource "azurerm_data_protection_backup_vault" "this" {
  name                         = var.backup_vault.name
  resource_group_name          = var.resource_group_name
  location                     = var.backup_vault.location
  datastore_type               = "VaultStore"
  redundancy                   = var.backup_vault.redundancy
  immutability                 = var.backup_vault.immutability
  cross_region_restore_enabled = local.cross_region_restore_enabled
  soft_delete                  = var.backup_vault.soft_delete
  retention_duration_in_days   = var.backup_vault.soft_delete == "Off" ? null : var.backup_vault.soft_delete_retention_days

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.tags,
    tomap({
      "Resource Type" = "Backup Vault"
    })
  )
}

resource "azurerm_data_protection_backup_vault_customer_managed_key" "this" {
  count                           = var.enable_customer_managed_key ? 1 : 0
  data_protection_backup_vault_id = azurerm_data_protection_backup_vault.this.id
  key_vault_key_id                = var.backup_vault.cmk_key_vault_key_id
}