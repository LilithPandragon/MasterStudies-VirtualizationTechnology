# Create Recovery Services Vault for Backup
resource "azurerm_recovery_services_vault" "vault" {
  name                = "vm-backup-vault"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  soft_delete_enabled = true

  tags = var.tags
}

# Create Backup Policy
resource "azurerm_backup_policy_vm" "backup_policy" {
  name                = "vm-backup-policy"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}

# Enable Backup for VMs
resource "azurerm_backup_protected_vm" "vm_backup" {
  count               = var.vm_count
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id       = azurerm_windows_virtual_machine.vm[count.index].id
  backup_policy_id   = azurerm_backup_policy_vm.backup_policy.id
}
