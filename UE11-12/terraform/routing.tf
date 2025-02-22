# Route Table for Spoke VNet
resource "azurerm_route_table" "spoke" {
  name                = "rt-spoke"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  route {
    name                   = "to-hub-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type         = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
}

# Associate Route Table with Spoke Subnet
resource "azurerm_subnet_route_table_association" "spoke" {
  subnet_id      = "${azurerm_virtual_network.spoke.id}/subnets/workload-subnet"
  route_table_id = azurerm_route_table.spoke.id
}

# Route Table for Spoke2 VNet
resource "azurerm_route_table" "spoke2" {
  name                = "rt-spoke2"
  location            = azurerm_resource_group.spoke2.location
  resource_group_name = azurerm_resource_group.spoke2.name

  route {
    name                   = "to-hub-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type         = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
}

# Associate Route Table with Spoke2 Subnet
resource "azurerm_subnet_route_table_association" "spoke2" {
  subnet_id      = "${azurerm_virtual_network.spoke2.id}/subnets/workload-subnet"
  route_table_id = azurerm_route_table.spoke2.id
}

