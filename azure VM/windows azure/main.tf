provider "azurerm" {
  features {}
  version = "3.97.1"
}

# Define the Azure resource group
resource "azurerm_resource_group" "windows" {
  name     = "windows"  # Change the name here
  location = "East US"
}

# Define the Azure virtual network
resource "azurerm_virtual_network" "windows" {
  name                = "windows-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.windows.location
  resource_group_name = azurerm_resource_group.windows.name
}

# Define the Azure subnet
resource "azurerm_subnet" "windows" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.windows.name
  virtual_network_name = azurerm_virtual_network.windows.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define the Azure public IP address
resource "azurerm_public_ip" "windows" {
  name                = "windows-public-ip"
  location            = azurerm_resource_group.windows.location
  resource_group_name = azurerm_resource_group.windows.name
  allocation_method   = "Dynamic"
}

# Define the Azure network interface
resource "azurerm_network_interface" "windows" {
  name                = "windows-nic"
  location            = azurerm_resource_group.windows.location
  resource_group_name = azurerm_resource_group.windows.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.windows.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }
}

# Define the Azure Windows virtual machine
resource "azurerm_windows_virtual_machine" "windows" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.windows.name
  location            = azurerm_resource_group.windows.location
  size                = "Standard_F8"
  admin_username      = "ubuntu"  # Change as needed
  admin_password      = "manikandan@92"  # Change as needed

  network_interface_ids = [
    azurerm_network_interface.windows.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
