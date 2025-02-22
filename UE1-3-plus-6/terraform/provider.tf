# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  # If you're using Azure CLI authentication, you don't need to specify credentials here
  # For other authentication methods, you would add subscription_id, client_id, etc.
} 