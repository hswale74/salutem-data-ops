# TODO set the variables below either enter them in plain text after = sign, or change them in variables.tf
#  (var.xyz will take the default value from variables.tf if you don't change it)

# Create resource group

locals {
  resource_name_substring = "${var.project}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.resource_name_substring}-${random_pet.prefix.id}"
  location = var.location
}

# Create security group
resource "azurerm_network_security_group" "example" {
  name                = "nsg-${local.resource_name_substring}-${random_pet.prefix.id}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name = "vnet-${local.resource_name_substring}-${random_pet.prefix.id}"

  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.example.location
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-${local.resource_name_substring}-${random_pet.prefix.id}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/27"]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Associate subnet and the security group
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a route table
resource "azurerm_route_table" "example" {
  name                          = "rt-${local.resource_name_substring}-${random_pet.prefix.id}"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = false
}

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
}

# Create managed instance
resource "azurerm_mssql_managed_instance" "main" {
  name                         = "sqlmi-${local.resource_name_substring}-${random_pet.prefix.id}"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  subnet_id                    = azurerm_subnet.example.id
  administrator_login          = "admin-sqlmi-${local.resource_name_substring}-${random_pet.prefix.id}"
  administrator_login_password = random_password.password.result
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  length = 1
}