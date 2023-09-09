variable "location" {
  type        = string
  description = "Enter the location where you want to deploy the resources"
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "The development environment - one of dev, test, uat, prod"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "The name of the associated project"
  default     = "ometapoc"
}
