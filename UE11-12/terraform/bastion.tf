# Bastion Public IP
resource "azurerm_public_ip" "bastion" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "hub" {
  name                = "hub-bastion"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${azurerm_virtual_network.hub.id}/subnets/AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
} 