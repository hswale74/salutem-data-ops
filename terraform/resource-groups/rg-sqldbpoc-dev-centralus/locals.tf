locals {
    resource_tag = "${var.project}-${var.environment}-${var.location}-${random_pet.pet.id}"
    georep_resource_tag = "${var.project}-${var.environment}-${var.georep_location}-${random_pet.pet.id}"
}


