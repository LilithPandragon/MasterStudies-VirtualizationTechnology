# Exercise Goals Overview

### **Exercise 1: Implementing a Virtual Machine**
- Create a VM in Azure with documented settings (Compute, Networking, Storage).
- Access via RDP/SSH.
- Justify configuration choices (e.g., region, VM size, network rules).
- Monitor the VM using **Azure Monitor**.

### **Exercise 2: Azure Backup**
- Back up the VM using **Azure Backup**.
- Test restoration (e.g., delete a file before restoring to verify recovery).
- Document the difference between **snapshots** (short-term state storage) and **backups** (long-term, versioned backups).

### **Exercise 3: Infrastructure as Code (IaC)**
- Automate VM deployment using IaC tools (e.g., Bicep, Terraform).
- Define resources like network, IP addresses, and storage as code.
- **Note**: The provided code is in Terraform, though Bicep is recommended. Terraform is still valid.
➤ We chose terraform


### **Exercise 6: Deploying Multiple Virtual Machines with Identical Configuration**

In this exercise, we combine the results of Exercise 2 with the ability to deploy multiple virtual machines (simultaneously).

**Task Description**

Modify the template from Exercise 3 so that the number of virtual machines to be deployed can be decided at deployment time (e.g., via a parameter).

**Implementation Details**
- Use a variable to control the number of VMs (`vm_count`)
- Each VM should have identical configuration
- All VMs should be deployed simultaneously

**Technical Note**

While the original exercise mentions Bicep loops, we've implemented this using Terraform's count parameter, which provides the same functionality for iterative resource creation.



# Complete Terraform Code Analysis for Exercises 1 to 3 and 6

## 🔗 Code-to-Exercise Mapping
| Exercise | Terraform Implementation |
|----------|---------------------------|
| **1. VM Implementation & Monitoring** | `vm.tf` (VM, Network Interface), `network.tf`, Azure Monitor Agent, Log Analytics |
| **2. Azure Backup** | Recovery Services Vault, Backup Policy, `backup.tf` |
| **3. Infrastructure as Code** | Entire Terraform structure (modularized configs) |
| **6. Multiple VMs** | Modified `vm.tf` and `backup.tf` to support multiple VMs |


# 🚀 Deployment Steps

####  Initialize Terraform
```bash
terraform init
```

#### Review Plan
```bash
terraform plan
```

#### Apply Configuration
```bash
terraform apply
```

#### Post-Deployment Check:

- Access VM via RDP using the public IP address
- Verify backups in Recovery Services Vault
- Check metrics in Azure Monitor

---

## provider.tf - Azure Configuration

Config for the Azure provider for terraform

---

## varibles.tf - Input Parameters

### Reusable variables for location, credentials, and tags
```plaintext
variable "location" { default = "westeurope" }          # Azure region
variable "admin_username" { default = "deployment-admin" } # VM admin user
variable "admin_password" { sensitive = true }          # Secure password handling
variable "tags" { type = map(string) }                  # Resource tagging
```

---

## vm.tf - Virtual Machine & Monitoring

### VM Options

### Basic Configuration
- **Size**: Standard_B2s (2 vCPUs, 4 GB RAM, for testing)
- **OS**: Windows Server 2022 Datacenter
- **Region**: Configurable via variables
- **Authentication**: Username/Password (configurable)
- **Name**: vm01

### Security Features
- Host-level encryption enabled
- UEFI Secure Boot
- Virtual TPM (Trusted Platform Module)
- System-assigned managed identity
- Azure Disk Encryption ready

### Management Features
- Windows automatic updates enabled
- OS-controlled patch management
- Azure VM agent provisioned
- Vienna timezone (W. Europe Standard Time)
- Azure Hybrid Benefit ready (if licensed)

### Storage Configuration
- OS Disk: 128GB Standard LRS
- ReadWrite caching enabled
- Boot diagnostics with managed storage

### Monitoring & Diagnostics
- Boot diagnostics enabled
- Prepared for Azure Monitor integration
- Log Analytics workspace integration ready


### Other options
- One NIC with private and public ip
- Timezone Vienna
- Hotpatching disabled

### Monitoring Extensions
Azure Monitor Agent:
- Collects monitoring data and logs
- Enables advanced monitoring features

Dependency Agent:
- Part of VM Insights
- Maps connections between VMs and processes

Diagnostic Settings:
- Sends VM metrics to Log Analytics
- Enables monitoring and alerting

### Log Analytics
- Creates a workspace for storing monitoring data
- retention_in_days: How long to keep the monitoring data

### Backup Configuration
Backup Vault: Geo-redundant storage (Standard tier)

- Daily backups at 23:00 UTC
- Retention policy:
  - Daily backups: 7 days
  - Weekly backups: 4 weeks (Sundays)
  - Monthly backups: 12 months (First Sunday)

- **Soft Delete**: Enabled for accidental deletion protection

---


| Terraform Resource/Component       | Exercise 1 (VM + Monitoring) | Exercise 2 (Backup) | Exercise 3 (IaC) |
|------------------------------------|------------------------------|---------------------|------------------|
| Network Interface (`vm_nic`)       | ✅                           | -                   | ✅               |
| Windows VM (`azurerm_windows_virtual_machine`) | ✅         | -                   | ✅               |
| Azure Monitor Agent (`ama`)        | ✅                           | -                   | ✅               |
| Dependency Agent (`dependency_agent`) | ✅                      | -                   | ✅               |
| Log Analytics Workspace (`workspace`) | ✅                       | -                   | ✅               |
| Diagnostic Settings (`vm_diagnostics`) | ✅                     | -                   | ✅               |
| Recovery Services Vault (`vault`)  | -                           | ✅                   | ✅               |
| Backup Policy (`backup_policy`)    | -                           | ✅                   | ✅               |
| Backup Protection (`vm_backup`)    | -                           | ✅                   | ✅               |
| Resource Group (`rg`)              | ✅                           | ✅                   | ✅               |
| Virtual Network (`vnet`)           | ✅                           | -                   | ✅               |
| Public IP (`vm_pip`)               | ✅                           | -                   | ✅               |


## Ad Exercise 6
For this exercise we modified the `vm.tf` and `backup.tf` to support multiple VMs.
The `vm_count` variable is used to control the number of VMs which is set to 3 by default and can be changed at deployment time.
The variable is defined in the `variables.tf` file.

We tried to deploy 3 vms but we are only allowed to have 4 cores in our subscription.
So we settled with 2 vms for testing.



