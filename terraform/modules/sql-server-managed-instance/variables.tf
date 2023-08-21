variable "prefix" {
  type        = string
  default     = "ssmi"
  description = "Prefix of the resource name"
}

variable "license_type" {
  type        = string
  description = "Enter license type"
  default     = "BasePrice"
}

variable "vcores" {
  type        = number
  description = "Enter number of vCores you want to deploy"
  default     = 8
}

variable "storage_size_in_gb" {
  type        = number
  description = "Enter storage size in GB"
  default     = 32
}

variable "environment" {
  type = string
  description = "Denotes the development env - one of dev, test, uat, prod"
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group that this managed instance belongs to"
}

variable "virtual_network_name" {
  type = string
  description = "Name of the virtual network that this managed instance belongs to"
}

variable "subnet_name" {
  type = string
  description = "Name of the subnet that this managed instance belongs to"
}

variable "network_security_group_name" {
  type = string
  description = "Name of the network security group that this managed instance belongs to"
}

variable "sku_name" {
  type = string
  description = " Specifies the SKU Name for the SQL Managed Instance. Valid values include GP_Gen4, GP_Gen5, GP_Gen8IM, GP_Gen8IH, BC_Gen4, BC_Gen5, BC_Gen8IM or BC_Gen8IH."
}


