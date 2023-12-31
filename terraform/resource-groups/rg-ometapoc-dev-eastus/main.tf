resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.resource_tag}"
  location = var.location
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "public_ip-${local.resource_tag}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "ometapoc"
}


# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "nic-${local.resource_tag}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = data.azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "nsg-${local.resource_tag}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ometa-ingress-8080-mehak"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range    = "8080"
    source_address_prefix      = "98.220.219.25"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ometa-ingress-8585-mehak"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8585"
    source_address_prefix      = "98.220.219.25"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "ometa-ingress-8080-haz"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range    = "8080"
    source_address_prefix      = "207.229.172.100"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ometa-ingress-8585-haz"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8585"
    source_address_prefix      = "207.229.172.100"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "ometa-ingress-22-haz"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "207.229.172.100"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "ometa-ingress-80-haz"
    priority                   = 1050
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "207.229.172.100"
    destination_address_prefix = "*"
  }


}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-${local.resource_tag}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_A3"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = "ometapoc-dev-admin"

  admin_ssh_key {
    username   = "ometapoc-dev-admin"
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "pet" {
  length = 1
}