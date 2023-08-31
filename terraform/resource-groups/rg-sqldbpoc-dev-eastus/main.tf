locals {
    resource_tag = "${var.project}-${var.environment}-${var.location}-${random_pet.pet.id}"
}

resource "random_pet" "pet" {
  length = 1
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.resource_tag}"
  location = var.location
}


resource "random_password" "admin_password" {
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}


resource "azurerm_mssql_server" "server" {
  name                         = "sql-${local.resource_tag}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = "sql-${local.resource_tag}-admin"
  administrator_login_password = random_password.admin_password.result
  version                      = "12.0"
#   public_network_access_enabled = false
}

# resource "azurerm_mssql_database" "db" {
#   name      = "sqldb-${local.resource_tag}"
#   server_id = azurerm_mssql_server.server.id
# }

resource "azurerm_mssql_database" "IPEP_C3LX_Training" {
  name      = "IPEP_C3LX_Training"
  server_id = azurerm_mssql_server.server.id
}

module private_endpoint_tt {
    source = "../../modules/private-endpoint"
    client_resource_group_name = "TTRESOURCES"
    client_virtual_network_name = "TTVirtualNet"
    client_subnet_name = "WebServers"
    server_resource_group_name = azurerm_resource_group.rg.name
    server_resource_tag = local.resource_tag
    server_resource_name = azurerm_mssql_server.server.name
    server_resource_id = azurerm_mssql_server.server.id
    server_location = var.location
    subresource_names = ["sqlServer"]
}

# module private_endpoint_ipep {
#     source = "../../modules/private-endpoint"
#     client_resource_group_name = "IPEPRESOURCES"
#     client_virtual_network_name = "IPEPResources-vnet"
#     client_subnet_name = "default"
#     server_resource_group_name = azurerm_resource_group.rg.name
#     server_resource_tag = local.resource_tag
#     server_resource_name = azurerm_mssql_server.server.name
#     server_resource_id = azurerm_mssql_server.server.id
#     server_location = var.location
#     subresource_names = ["sqlServer"]
# }
