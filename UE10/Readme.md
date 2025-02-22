# UE10
# Azure Web App CI/CD Demo

This project demonstrates a complete CI/CD pipeline for deploying a PHP application to Azure Web App using GitHub Actions and Terraform for infrastructure provisioning.

## Project Structure
```
└── .github/
 └── workflows/
  └── deploy.yml # GitHub Actions workflow

UE10/
├── app/
│ └── index.php # PHP application
├── terraform/
  ├── main.tf # Main Terraform configuration
  └── providers.tf # Azure provider configuration
```

## Infrastructure Setup

### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
- An Azure subscription
- GitHub account

### Infrastructure Provisioning

The infrastructure is defined using Terraform in the `terraform` directory:

1. Initialize Terraform:
cd UE10/terraform
terraform init

2. Apply the Terraform configuration:
terraform apply


This will create:
- A Resource Group in West Europe
- An App Service Plan (B1 SKU)
- A Linux Web App with PHP 8.3

## Application Deployment

The application is automatically deployed using GitHub Actions whenever changes are pushed to the `main` branch.

### GitHub Actions Workflow

The workflow in `.github/workflows/deploy.yml`:
1. Checks out the code
2. Prepares the deployment by:
   - Isolating the `UE10/app` directory contents
   - Moving them to the root directory
3. Deploys to Azure Web App using the Azure WebApp Deploy action

### Setup Requirements

1. In your GitHub repository settings, add the following secret:
   - `AZURE_PUBLISH_PROFILE`: The publish profile from your Azure Web App
     - This can be downloaded from the Azure Portal > Your Web App > Get Publish Profile

## Infrastructure Details

### Resource Specifications

- **Resource Group**: `rg-webapp-ci-cd`
  - Location: West Europe

- **App Service Plan**: `asp-webapp-ci-cd`
  - SKU: B1 (Basic)
  - OS: Linux

- **Web App**:
  - Name: `webapp-ci-cd-[random-string]`
  - Stack: PHP 8.3
  - OS: Linux