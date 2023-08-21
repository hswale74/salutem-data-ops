
data "azurerm_resource_group" "this" {
  name = "TTRESOURCES"
}

data "azurerm_network_security_group" "this" {
  name = "CFSDemoServer-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
}

data azurerm_virtual_network this {
  name = "TTVirtualNet"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name = "WebServers"
  resource_group_name = data.azurerm_resource_group.this.name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

resource "azurerm_mssql_managed_instance" "main" {
  name                         = "${var.prefix}-${var.resource_group_name}-${var.environment}"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  subnet_id                    = data.azurerm_subnet.this.id
  administrator_login          = "${var.prefix}-${var.resource_group_name}-${var.environment}-admin"
  administrator_login_password = random_password.password.result
  license_type                 = var.license_type
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
  sku_name = var.sku_name
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}
