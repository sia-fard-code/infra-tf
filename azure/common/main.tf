terraform {
  backend "s3" {
  }
  required_providers {
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
  }
}

module "variables" {
  source = "../modules/variables"
  environment = var.env
}

module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.4.2"

  global_settings = var.global_settings

  resource_groups =  { 
    common_rg = {
      name = "${var.env}-common"
    }
    vnet_common_rg = {
      name = "${var.env}-common-vnet"
    }
    dns_rec_common_rg = {
      name = "${var.env}-common-dns-rec"
    }
    sandbox_rg = {
      name = "${var.env}-sandbox"
    }
    images_rg = {
      name = "${var.env}-images"
    }
    bastion_rg = {
      name = "${var.env}-bastion"
    }
  }

  keyvaults = {
    kv = {
      name               = "${var.env}-${var.random_string}-common-kv2"
      resource_group_key = module.variables.rg["common"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        }
      }
    }
    kv-blue = {
      name               = "${var.env}-${var.random_string}-kv"
      resource_group_key = module.variables.rg["common"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
          certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "Getissuers", "Setissuers", "Listissuers", "Deleteissuers", "Manageissuers", "Restore", "Managecontacts"]
          key_permissions = ["Get"]
        }
      }
    }
    bastion_kv = {
      name               = "${var.env}-${var.random_string}-bastion-kv2"
      resource_group_key = module.variables.rg["common"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        }
      }
    }
    encrypt_kv = {
      name               = "${var.env}-${var.random_string}-encrypt-kv2"
      resource_group_key = module.variables.rg["common"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        }
      }
    }
        

  }


  
  managed_identities = {
    common_mi = {
      name               = "common_mi"
      resource_group_key = module.variables.rg["common"]
    }
  }

  storage_accounts = var.storage_accounts

  shared_services = {
    image_definitions        = var.image_definitions
    shared_image_galleries   = var.shared_image_galleries
  }

  networking = {
    # application_gateways                                    = var.application_gateways
    # application_gateway_applications                        = var.application_gateway_applications
    
    vnets = {
      common = {
        resource_group_key = module.variables.rg["vnet"]
        vnet = {
          name          = "${var.env}-common"
          address_space = [module.variables.address_space_common]
                           
        }
      specialsubnets = {}
        subnets = {
          subnet1 = {
            name = "private"
            cidr = [module.variables.subnets[0]]
          }
          subnet2 = {
            name = "public"
            cidr = [module.variables.subnets[1]]
            nsg_key = "web"
          }
          subnet3 = {
            name = "db"
            cidr = [module.variables.subnets[2]]
            nsg_key = "db"
          }
          subnet4 = {
            name = "AzureBationSubnet"
            cidr = [module.variables.subnets[3]]
          }
        }
      }
      sandbox = {
        resource_group_key = "sandbox_rg"
        vnet = {
          name          = "sandbox"
          address_space = [module.variables.address_space_sandbox]
        }
        specialsubnets = {}
      
        subnets = {
          subnet1 = {
            name = "public"
            cidr = [module.variables.subnet_sandbox]
            nsg_key = "web"
          }
        }
      }
    }
   
  public_ip_addresses = {
      lb_pip1 = {
        name                    = "lb_pip1"
        resource_group_key      = module.variables.rg["common"]
        sku                     = "Basic"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
      bastion_pip = {
        name                    = "bastion_pip"
        resource_group_key      = module.variables.rg["common"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
        zones                   = ["1"]
      }      
  }

  

  load_balancers  = {
      lb2 = {
          name                      = "${var.env}-common-mongo-lb"
          sku                       = "Standard"
          resource_group_key        = module.variables.rg["common"]
          backend_address_pool_name = "mongo"
          frontend_ip_configurations = {
            config1 = {
              name                  = "config1"
              vnet_key              = "common"
              subnet_key            = "subnet3"
              private_ip_address    = "10.100.3.4"
            }
          }
          backend_address_pool_addresses = {
            address1 = {
              backend_address_pool_address_name = "address1"
              vnet_key                          = "common"
              ip_address                        = "10.100.3.10"
            }
            address2 = {
              backend_address_pool_address_name = "address2"
              vnet_key                          = "common"
              ip_address                        = "10.100.3.11"
            }
            address3 = {
              backend_address_pool_address_name = "address3"
              vnet_key                          = "common"
              ip_address                        = "10.100.3.12"
            }
          }
          probes = {
            probe1 = {
              resource_group_key = module.variables.rg["common"]
              load_balancer_key  = "lb2"
              probe_name         = "probe1"
              port               = "27017"
            }
          }
          lb_rules = {
            rule1 = {
              resource_group_key             = module.variables.rg["common"]
              load_balancer_key              = "lb2"
              lb_rule_name                   = "rule1"
              protocol                       = "tcp"
              probe_id_key                   = "probe1"
              frontend_port                  = "27017"
              backend_port                   = "27017"
              frontend_ip_configuration_name = "config1" #name must match the configuration that's defined in the load_balancers block.
            }
          }
      }
    }

    network_security_group_definition = var.network_security_group_definition

    application_security_groups = var.application_security_groups

    private_dns = var.private_dns

    dns_zones = var.dns_zones
  }

  compute = {

    virtual_machines = var.virtual_machines
    
  }
  
  
  diagnostics = {
    diagnostic_storage_accounts = {
    # Stores boot diagnostic for region1
    bootdiag1 = {
      name                     = "masimo-storage"
      resource_group_key       = module.variables.rg["common"]
      account_kind             = "StorageV2"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      access_tier              = "Cool"
    }
  }
}

  
}


