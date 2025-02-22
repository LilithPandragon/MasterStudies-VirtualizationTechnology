# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-webapp-ci-cd"
  location = "West Europe"
}

# Create an App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "asp-webapp-ci-cd"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create a Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-ci-cd-${random_string.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      php_version = "8.3"
    }
  }
}

# Generate a random string for the Web App name
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Output the Web App URL
output "webapp_url" {
  value = azurerm_linux_web_app.webapp.default_hostname
}