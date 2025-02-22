# Create Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_count
  name                = "vm-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.vm_pip[count.index].id
  }

  tags = var.tags
}

# Create Public IPs
resource "azurerm_public_ip" "vm_pip" {
  count               = var.vm_count
  name                = "vm-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id
  ]

  # Additional VM options
  computer_name                   = "vm-${count.index + 1}"  # Hostname of the VM
  enable_automatic_updates        = true
  patch_mode                     = "AutomaticByOS"
  timezone                       = "W. Europe Standard Time"  # Vienna timezone
  license_type                   = "Windows_Server"
  encryption_at_host_enabled     = false # disabled because it is not supported in our subscription
  hotpatching_enabled           = false
  provision_vm_agent            = true
  secure_boot_enabled           = false # not supported with g1 images
  vtpm_enabled                  = false # not supported with g1 images  

  os_disk {
    name                      = "vm-${count.index + 1}-os-disk"
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
    disk_size_gb             = 128
    disk_encryption_set_id   = null  # Optional: Link to a disk encryption set
    write_accelerator_enabled = false
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null  # Uses managed storage account
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Create Log Analytics Workspace (single workspace for all VMs)
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "vm-monitoring-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30  # This controls the data retention

  tags = var.tags
}

# Enable Azure Monitor Agent for each VM
resource "azurerm_virtual_machine_extension" "ama" {
  count                      = var.vm_count
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# Enable VM Insights for each VM
resource "azurerm_virtual_machine_extension" "dependency_agent" {
  count                      = var.vm_count
  name                       = "DependencyAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version = true
}

# Create Diagnostic Setting for each VM
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  count                      = var.vm_count
  name                       = "vm-${count.index + 1}-diagnostics"
  target_resource_id         = azurerm_windows_virtual_machine.vm[count.index].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}