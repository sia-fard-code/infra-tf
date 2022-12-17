# Authors     : Siavash Fard, Majid Sadri
# Purpose     : IAC for Masimo common environment.
# Description : Terraform template that contains the configuration of the infrastructure for Masimo's common environment.  

################################
# Terraform version definition #
################################
terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.72.0"
    }
  }
}


#######################################
# Configuration of the cloud provider #
#######################################
provider "azurerm" {

#    subscription_id = "00ca454e-f45b-4b32-9a6e-e7a2bfacc135"
    subscription_id = "10b5e15c-8d59-4b7e-a59b-d47fb2f01f71"
    client_id       = "0157ca10-8e72-4c2e-b772-e766c942ba50"
    client_secret   = var.client_secret
    tenant_id       = "e1539182-9f23-4fca-a983-d7c09f4493a5"
    features {}
}

resource "azurerm_resource_group" "tfrg" {
  name     = "${var.resource.prefix}-rg"
  location = var.resource.location

  tags = {
    environment = var.resource.tag
  }
}

module "default_nsg" {
    source             = "./modules/sg"
    name_postfix = "default"
    location    = var.resource.location
    resource_group_name = azurerm_resource_group.tfrg.name
}
module "public_nsg" {
    source             = "./modules/sg"
    name_postfix = "bastion"
    location    = var.resource.location
    resource_group_name = azurerm_resource_group.tfrg.name
}

module "bastion_nsg" {
    source             = "./modules/sg"
    name_postfix = "bastion"
    location    = var.resource.location
    resource_group_name = azurerm_resource_group.tfrg.name
}

module "api_nsg" {
    source             = "./modules/sg"
    name_postfix = "api"
    location    = var.resource.location
    resource_group_name = azurerm_resource_group.tfrg.name
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.tfrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  subnet_names        = ["default", "public", "bastion", "api"]

  nsg_ids = {
    default = module.default_nsg.nsg_id
    public = module.public_nsg.nsg_id
    bastion =  module.bastion_nsg.nsg_id
    api = module.api_nsg.nsg_id
  }

  tags = {
    environment = "devops"
  }
}

module "public_subnet_public_ip" {
  source = "./modules/public_ip"
  name_postfix ="public"
  location    = var.resource.location
  resource_group_name         = azurerm_resource_group.tfrg.name
}

module "default_subnet_public_ip" {
  source = "./modules/public_ip"
  name_postfix ="default"
  location    = var.resource.location
  resource_group_name         = azurerm_resource_group.tfrg.name
}

module "nic_public" {
  source = "./modules/network_int"
  name_postfix ="public"
  location    = var.resource.location
  resource_group_name         = azurerm_resource_group.tfrg.name
  subnet_id = module.vnet.vnet_subnets[1]
  priv_ip = "10.0.2.40"
  pub_ip_id = module.default_subnet_public_ip.ip_address_id
}

module "azurerm_network_security_rule" {
  source                      = "./modules/security_rules"
  name                        = "AllowSSHInbound"
  resource_group_name         = azurerm_resource_group.tfrg.name
  port =  var.ssh_port
  nsg_name = module.default_nsg.nsg_name
}

module "public_lb" {
  source = "./modules/public_lb"
  name_postfix = "default"
  location    = var.resource.location
  resource_group_name = azurerm_resource_group.tfrg.name
  public_ip = module.public_subnet_public_ip.ip_address_id
}

resource "azurerm_lb_backend_address_pool" "new_default_backend_pool" {
    resource_group_name         = azurerm_resource_group.tfrg.name
    loadbalancer_id     = module.public_lb.lb_id
    name                = "defaultBackendPool" 

}

module "new_machine" {
  source = "./modules/ss"
  name  = "new_machine"
  location    = var.resource.location
  resource_group_name         = azurerm_resource_group.tfrg.name
  subnet_id = module.vnet.vnet_subnets[1]
  lb_ids       = [azurerm_lb_backend_address_pool.new_default_backend_pool.id]
}

module "bastion_vm" {
  source = "./modules/bastion"
  name  = "bastion_vm"
  location    = var.resource.location
  resource_group_name         = azurerm_resource_group.tfrg.name
  network_interface_ids      = module.nic_public.network_interface_id
}