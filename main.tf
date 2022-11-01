terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.23.0"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  location = var.rg_location
  name     = var.rg_name
}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "linuxkey" {
  content  = tls_private_key.key.private_key_pem
  filename = "linuxkey.pem"
}
# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "stage-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.cidr_block
}

# Create a Subnet for VM
resource "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.sub_add
}
# Create the AKS cluster

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "stage-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-k8s"

  default_node_pool {
    name                = "stage"
    node_count          = 1
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
    vnet_subnet_id      = azurerm_subnet.subnet.id
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = tls_private_key.key.public_key_openssh
    }
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }

  tags = {
    environment = "stage"
  }
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = azurerm_kubernetes_cluster.cluster.kube_config_raw
  connection {
    type        = "ssh"
    user        = "kub"
    host        = "20.111.30.218"
    private_key = file(var.ssh_private_key)
  }
  provisioner "file" {
    source      = "kubeconfig"
    destination = "/home/kub/kub/kubeconfig"
  }
}
