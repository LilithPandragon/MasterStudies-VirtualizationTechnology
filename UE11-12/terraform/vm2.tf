# VM2 NIC
resource "azurerm_network_interface" "vm2" {
  name                = "vm2-nic"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.spoke2.id}/subnets/workload-subnet"
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows VM2
resource "azurerm_windows_virtual_machine" "spoke2" {
  name                = "spoke2-vm"
  resource_group_name = azurerm_resource_group.spoke2.name
  location            = azurerm_resource_group.spoke2.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
} 