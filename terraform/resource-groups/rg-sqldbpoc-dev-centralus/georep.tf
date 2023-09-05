resource "azurerm_resource_group" "georep_rg" {
  name = "rg-${local.georep_resource_tag}"
  location = var.georep_location
}

resource "azurerm_mssql_server" "georep_server" {
  name                         = "sql-${local.georep_resource_tag}"
  resource_group_name          = azurerm_resource_group.georep_rg.name
  location                     = azurerm_resource_group.georep_rg.location
  administrator_login          = "sql-${local.georep_resource_tag}-admin"
  administrator_login_password = random_password.georep_admin_password.result
  version                      = "12.0"
#   public_network_access_enabled = false
}

resource "random_password" "georep_admin_password" {
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}
