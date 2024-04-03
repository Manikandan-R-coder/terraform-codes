provider "azurerm" {
  features {}
}

# Define the resource groups for development and testing environments
resource "azurerm_resource_group" "dev_rg" {
  name     = "dev-aks-rg"
  location = "East US"  # Change to your desired location for development
}

resource "azurerm_resource_group" "test_rg" {
  name     = "test-aks-rg"
  location = "East US"  # Change to your desired location for testing
}

# Define the AKS clusters for development and testing environments
resource "azurerm_kubernetes_cluster" "dev_aks_cluster" {
  name                = "dev-aks-cluster"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name
  dns_prefix          = "devakscluster"  # Change to your desired DNS prefix for development

  default_node_pool {
    name       = "default"
    node_count = 3  # Change to your desired node count for development
    vm_size    = "Standard_DS2_v2"  # Change to your desired VM size for development
  }

  service_principal {
    client_id     = "your-dev-client-id"     # Replace with your development service principal client ID
    client_secret = "your-dev-client-secret" # Replace with your development service principal client secret
  }

  tags = {
    environment = "Development"
  }
}

resource "azurerm_kubernetes_cluster" "test_aks_cluster" {
  name                = "test-aks-cluster"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  dns_prefix          = "testakscluster"  # Change to your desired DNS prefix for testing

  default_node_pool {
    name       = "default"
    node_count = 3  # Change to your desired node count for testing
    vm_size    = "Standard_DS2_v2"  # Change to your desired VM size for testing
  }

  service_principal {
    client_id     = "your-test-client-id"     # Replace with your testing service principal client ID
    client_secret = "your-test-client-secret" # Replace with your testing service principal client secret
  }

  tags = {
    environment = "Testing"
  }
}

# Output the kube_config to connect to the clusters
output "dev_kube_config" {
  value     = azurerm_kubernetes_cluster.dev_aks_cluster.kube_config_raw
  sensitive = true
}

output "test_kube_config" {
  value     = azurerm_kubernetes_cluster.test_aks_cluster.kube_config_raw
  sensitive = true
}
