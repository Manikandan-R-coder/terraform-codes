provider "azurerm" {
  features {}
  version = "3.97.1"
}

# Define the Azure resource group
resource "azurerm_resource_group" "mani" {
  name     = "new-resource-group-name"  # Change the name here
  location = "West Europe"
}

# Define the Azure virtual network
resource "azurerm_virtual_network" "mani" {
  name                = "mani-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mani.location
  resource_group_name = azurerm_resource_group.mani.name
}

# Define the Azure subnet
resource "azurerm_subnet" "mani" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.mani.name
  virtual_network_name = azurerm_virtual_network.mani.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define the Azure public IP address
resource "azurerm_public_ip" "mani" {
  name                = "mani-public-ip"
  location            = azurerm_resource_group.mani.location
  resource_group_name = azurerm_resource_group.mani.name
  allocation_method   = "Dynamic"
}

# Define the Azure network interface
resource "azurerm_network_interface" "mani" {
  name                = "mani-nic"
  location            = azurerm_resource_group.mani.location
  resource_group_name = azurerm_resource_group.mani.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mani.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mani.id
  }
}

# Define the Azure Linux virtual machine
resource "azurerm_linux_virtual_machine" "mani" {
  name                = "mani-machine"
  resource_group_name = azurerm_resource_group.mani.name
  location            = azurerm_resource_group.mani.location
  size                = "Standard_F8"
  admin_username      = "ubuntu"
  disable_password_authentication = false  # Enable password authentication

  admin_password = "manikandan@92"

  network_interface_ids = [
    azurerm_network_interface.mani.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
