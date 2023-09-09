
data "azurerm_virtual_network" "ipep" {
  name                = local.ipep_virtual_network_name
  resource_group_name = local.ipep_resource_group_name
}

data "azurerm_subnet" "default" {
  name                 = "default"
  virtual_network_name = local.ipep_virtual_network_name
  resource_group_name  = local.ipep_resource_group_name
}



data "azurerm_network_security_group" "salutem-nsg" {
  name                = "salutempowerbi-nsg"
  resource_group_name = local.ipep_resource_group_name
}