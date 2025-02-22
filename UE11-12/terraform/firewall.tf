# Firewall Public IP
resource "azurerm_public_ip" "fw" {
  name                = "fw-pip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Firewall
resource "azurerm_firewall" "hub" {
  name                = "hub-firewall"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id = azurerm_firewall_policy.hub.id

  ip_configuration {
    name                 = "fw-config"
    subnet_id            = "${azurerm_virtual_network.hub.id}/subnets/AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.fw.id
  }
}

# Firewall Policy
resource "azurerm_firewall_policy" "hub" {
  name                = "hub-firewall"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
}

# Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "main" {
  name               = "MainRuleCollection"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 100

  network_rule_collection {
    name     = "AllowInternet"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "AllowInternetAccess"
      protocols            = ["TCP", "UDP"]
      source_addresses     = ["172.16.0.0/16", "192.168.0.0/16"]
      destination_addresses = ["*"]
      destination_ports    = ["*"]
    }
  }

  network_rule_collection {
    name     = "DenyInterSpoke"
    priority = 200
    action   = "Deny"
    rule {
      name                  = "DenySpokeCommunication"
      protocols            = ["Any"]
      source_addresses     = ["*"]
      destination_addresses = ["*"]
      destination_ports    = ["*"]
    }
  }
} 