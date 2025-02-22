# Resource Groups
resource "azurerm_resource_group" "hub" {
  name     = "RG-Hub"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke" {
  name     = "RG-Spoke1"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke2" {
  name     = "RG-Spoke2"
  location = var.location
  tags     = var.tags
}