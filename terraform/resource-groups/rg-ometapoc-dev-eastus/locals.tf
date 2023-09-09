locals {
  resource_tag              = "${var.project}-${var.environment}-${var.location}-${random_pet.pet.id}"
  ipep_resource_group_name  = "IPEPResources"
  ipep_virtual_network_name = "IPEPResources-vnet"
}


