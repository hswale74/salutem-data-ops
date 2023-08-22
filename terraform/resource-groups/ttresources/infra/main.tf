module "dev-sql-server-managed-instance" {
  source = "../../../modules/sql-server-managed-instance"

  environment                 = var.environment
  vcores                      = var.vcores
  storage_size_in_gb          = var.storage_size_in_gb
  resource_group_name         = var.resource_group_name
  virtual_network_name        = var.virtual_network_name
  subnet_name                 = var.subnet_name
  network_security_group_name = var.network_security_group_name
  sku_name                    = var.sku_name

}