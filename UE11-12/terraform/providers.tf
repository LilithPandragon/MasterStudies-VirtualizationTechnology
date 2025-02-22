# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Specify your desired version
    }
  }
}

provider "azurerm" {
  features {}
  # If using Service Principal, uncomment and fill these:
  # subscription_id = "your-subscription-id"
  # client_id       = "your-client-id"
  # client_secret   = "your-client-secret"
  # tenant_id       = "your-tenant-id"
} 