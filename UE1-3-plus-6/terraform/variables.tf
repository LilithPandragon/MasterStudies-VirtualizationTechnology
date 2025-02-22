variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "deployment-admin"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}