# Explanation of Tasks and Code Analysis

## Exercise Goals Overview

### **Exercise 11: Hub- and Spoke Architecture**

- *Deploy Architecture in Azure:* Use either the Azure Portal or Infrastructure as Code (e.g., Bicep).
- *Create Resource Groups*  
  - *RG-Hub* for the central hub.  
  - *RG-Spoke1* for the spoke.
- *Set Up Virtual Networks*
  - Deploy *vnet-hub* in *RG-Hub*.  
  - Deploy *vnet-spoke* in *RG-Spoke1*.  
  - Establish *VNET Peering* between *vnet-hub* and *vnet-spoke*.
- *Hub Network Configuration*  
  - Deploy *Azure Firewall* (choose a small SKU to minimize costs).
- *Spoke Network Configuration*  
  - Set up a *Routing Table* (with the next hop set to the Azure Firewall in the Hub).  
  - Deploy a *Virtual Machine* (including support resources like NIC, OS disk, etc.).
- *Traffic Routing*  
  Ensure that all non-local traffic in *vnet-spoke* is routed through the *Hub*.

### **Exercise 12: Implementing a second spokes with VM & monitoring**

- *Extend the Existing Architecture*  
  - Add a second Spoke with its own Resource Group.
  - Deploy a new VNet, Virtual Machine (including support resources), and set up VNet Peering.
- *Connectivity Testing*  
  - Test data transfer (e.g., using Ping) between the VMs in different spokes.

- *Firewall Policy Configuration*  
  - Create a Firewall Policy to block data transfer between the two VMs.
  - Ensure that Internet access remains available for both VMs.

- *Routing and Public IP Considerations*  
  - Verify that the VMs do not have direct public IP addresses.
  - Confirm that all traffic is routed through the Firewall (using Network Watcher).

- *Bastion Host Planning*  
  - Determine the optimal placement of a Bastion host for remote administrative access.
  - Ensure that the Bastion host can manage both VMs.
---

## How to use terraform

- Install in VS Code the Hashicorp Terraform Plugin
- Download the binary [Terraform Install]([https://duckduckgo.com](https://developer.hashicorp.com/terraform/install))
- Unzip it in a path like C:\terraform
- Open in Windows the System > About
- Open the Advanced Settings
- Open in the Tab *Advanced* the *Environment Variables
- Go there to the *System variables* -> *Path* part
- Click on *Edit*
- Click on *New*
- Add your like C:\terraform and click on *OK*

---

# Complete Terraform Code Analysis for Exercises 11-12

## 🔗 Code-to-Exercise Mapping
| Exercise | Terraform Implementation |
|----------|---------------------------|
| **11. Hub Spoke Architecture** | `vm1.tf` VM in spoke; `network.tf`  Routing table, Azure Monitor Agent, Log Analytics; `main.tf` ressource groups for Hub and spokes 1/2; `firewall.tf` firewall of hub;  `rotuing.tf` routing definition for vnet communication; |
| **12. Implementing a second spokes with VM & monitoring** | `bastion.tf` Azure Bastion for Jumphost access, Rules for Access only through firewall hub `firewall.tf` and `network.tf`, `vm2.tf` additional spoke|


---

## 📁 File Breakdown

###  bastion.tf - Configuration Azure Bastion Ressource as a Jump-Host for the Access to the VM1 and VM2

- Whole resource will be place in the resource group resource **"azurerm_resource_group" "hub"** defined in **main.tf**
- Resource **"azurerm_public_ip" "bastion"** provides static ip adress
- Resource **"azurerm_bastion_host" "hub"** defines the ip-configuration
- *ip-configuration* is defined through *subnet_id* and this information will be pulled from network.tf through variable **${azurerm_virtual_network.hub.id}**

### firewall.tf - Configuration Azure Firewall Ressource for the protection hub vnet and the public internet access. Includes Networkrules and Firewall rules

- **resource "azurerm_public_ip" "fw"** defines a public static IP that is reachable from the internet
- Resource **"azurerm_firewall" "hub"** defines the ip-configuration
- *ip-configuration* is defined through *subnet_id* and this information will be pulled from network.tf through variable **${azurerm_virtual_network.hub.id}**
- **resource "azurerm_firewall_policy" "hub"** defines the firewall policy that should be used without it the next step will not work and all access will be blocked
- **resource "azurerm_firewall_policy_rule_collection_group" "main"** defines the network rules and is linked through *firewall_policy_id = azurerm_firewall_policy.hub.id* with the *resource "azurerm_firewall_policy" "hub"*

### main.tf - Configuration 3 Resourcegroups - 1 Hub, 2 Spokes
- there are 3 resources defined for the hub and 2 for spoke
- definition for the names

### network.tf - Includes Vnet, VnetPeering, Watcher, Watcher Flow Logs
- **resource "azurerm_virtual_network" "hub"** defines the adress-space 10.0.0.0/16 and two /24 subnet for the *azure bastion host* and the *azure firewall* 
- **resource "azurerm_virtual_network" "spoke"** defines a vnet *172.16.0.0/16* and a subnet /24 for the workload. Done for the first spoke
- **resource "azurerm_virtual_network" "spoke2"** defines vnet *192.168.0.0/16* and a subnet /24 for the workload. Done for the second spoke
- VNet Peering is done through **resource "azurerm_virtual_network_peering" "hub_to_spoke"** and **resource "azurerm_virtual_network_peering" "spoke_to_hub"** and with 2 for the second spoke.
  - *resource_group_name* defines the
  - *virtual_network_name* defines the
  - *remote_virtual_network_id* defines
  - *allow_virtual_network_access = true* >>
  - *allow_forwarded_traffic = true* >>

### routing.tf - Routing table for Spoke 1-2 Vnet, and associate vnets

- Defines hops and route tables
- *resource "azurerm_route_table" "spoke"* defines for the first spoke the next hop through the route json array
- *azurerm_firewall.hub.ip_configuration[0].private_ip_address* is the value from firewall.tf
- *resource "azurerm_subnet_route_table_association" "spoke"* Associate Route Table with Spoke Subnet meaning that the data from *network.tf* and *resource "azurerm_virtual_network" "spoke"* will be used
- same done for spoke two

### variables.tf - Includes the variables for location, admin_username, admin_passwor and tags

- variables will be filed from terraform providers.tf
- definition of *type* like string or array
- additional definition or sensitivity defined

### vm1.tf and vm2.tf- Terraform template for VMd - WindowsServer with ip_configuration, os_disk, and

- *resource "azurerm_network_interface" "vm"* defines the nic and the subnet linking it through *subnet_id* network.tf and the *azurerm_virtual_network.spoke.id* variable
- *resource "azurerm_windows_virtual_machine" "spoke"* links to variables.tf for *admin_username* and *admin_password*
- *network_interface_ids* links to the defined subnet in the resource *resource "azurerm_network_interface" "vm"* 
- *os_disk* defines storage type
- *source_image_reference* defines OS and which image for the building of the vm is used
