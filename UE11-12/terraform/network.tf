# Hub VNet
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "AzureFirewallSubnet"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.0.2.0/24"
  }
}

# Spoke VNet
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  address_space       = ["172.16.0.0/16"]

  subnet {
    name           = "workload-subnet"
    address_prefix = "172.16.1.0/24"
  }
}

# Spoke2 VNet
resource "azurerm_virtual_network" "spoke2" {
  name                = "vnet-spoke2"
  resource_group_name = azurerm_resource_group.spoke2.name
  location            = azurerm_resource_group.spoke2.location
  address_space       = ["192.168.0.0/16"]

  subnet {
    name           = "workload-subnet"
    address_prefix = "192.168.1.0/24"
  }
}

# VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.spoke.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
}

# VNet Peering for Spoke2
resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.spoke2.name
  virtual_network_name         = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
}

# Network Watcher
resource "azurerm_network_watcher" "hub" {
  name                = "nw-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

# Network Watcher Flow Logs Storage Account
resource "azurerm_storage_account" "flowlogs" {
  name                     = "hubflowlogs${random_string.unique.result}"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Random string for storage account name
resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}