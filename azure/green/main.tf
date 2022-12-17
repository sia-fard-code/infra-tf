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

module "vmss_api" {
  source = "../modules/vmss"
  app_name = "api"
  color = "green"
  env = var.env
  computer_name_prefix = "green-api"
  appgw_backend_pools = {
              appgw-api = {
                appgw_key = "agw-api"
                pool_names = ["dev-green-api-ag-app"]
              }
            }
}

module "vmss_web" {
  source = "../modules/vmss"
  app_name = "web"
  env = var.env
  computer_name_prefix = "green-web"
  color = "green"
  appgw_backend_pools = {
              appgw-web = {
                appgw_key = "agw-web"
                pool_names = ["dev-green-web-ag-app"]
              }
            }
}

data "azurerm_key_vault" "dev_kv" {
  name                = "kv-dev-abc-kv"
  resource_group_name = "rg-dev-common"
}


module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.4.2"

  global_settings = var.global_settings

  keyvaults = {
    bastion_kv = {
      name               = "${var.env}-${var.random_string}-bastion-kv"
      resource_group_key = module.variables.rg["green"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
          certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "Getissuers", "Setissuers", "Listissuers", "Deleteissuers", "Manageissuers", "Restore", "Managecontacts"]
          key_permissions = ["Get"]
        }
      }
    }
    masimo = {
      name               = "masimo-cert-${var.random_string}-kv"
      resource_group_key = module.variables.rg["green"]
      sku_name           = "standard"
      creation_policies = {
        logged_in_user = {
          secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
          certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "Getissuers", "Setissuers", "Listissuers", "Deleteissuers", "Manageissuers", "Restore", "Managecontacts"]
          key_permissions = ["Get"]
        }
      }
    }
    
  }

  keyvault_access_policies = {
    masimo = {
      apgw_keyvault_secrets = {
        managed_identity_key    = "green_mi"
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "Getissuers", "Setissuers", "Listissuers", "Deleteissuers", "Manageissuers", "Restore", "Managecontacts"]
      }
    }
  }

  resource_groups = {
    green_rg = {
      name = "${var.env}-green"
    }
    dns_rec_green_rg = {
      name = "${var.env}-green-dns-rec"
    }
  }

  managed_identities = {
    green_mi = {
      name               = "green_mi"
      resource_group_key = "green_rg"
    }
    masimo = {
      # Used by the release agent to access the level0 keyvault and storage account with the tfstates in read / write
      # Assign read access to level0
      name               = "agw-secrets-msi"
      resource_group_key = module.variables.rg["green"]
      }
  }

  networking = {

    vnets = {
      green = {
      resource_group_key = module.variables.rg["green"]
      vnet = {
        name          = "${var.env}-green"
        address_space = [module.variables.address_space_color]
      }

      specialsubnets = {}
      subnets = {
        subnet1 = {
          name = "private"
          cidr = [module.variables.subnet_color[0]]
        }
        subnet2 = {
          name = "public"
          cidr = [module.variables.subnet_color[1]]
          nsg_key = "web"
        }
        subnet3 = {
          name = "db"
          cidr = [module.variables.subnet_color[2]]
          nsg_key = "db"
        }
        subnet4 = {
          name = "AzureBationSubnet"
          cidr = [module.variables.subnet_color[3]]
          nsg_key = "application_gateway"
        }
        }
      }
    }

    vnet_peerings = {
      common_2_green = {
        name = "common_2_green"
        from = {
          vnet_key = "common"
          virtual_network_name = "vnet-${var.env}-common"
          resource_group_name = "rg-${var.env}-common-vnet"
          remote_virtual_network_id = "/subscriptions/${var.subscription}/resourceGroups/rg-dev-common-vnet/providers/Microsoft.Network/virtualNetworks/vnet-dev-common"
        }
        to = {
          vnet_key = "green"
          virtual_network_name = "vnet-${var.env}-green"
          resource_group_name = "rg-${var.env}-green"
          remote_virtual_network_id = "/subscriptions/${var.subscription}/resourceGroups/rg-dev-green/providers/Microsoft.Network/virtualNetworks/vnet-dev-green"
        }
        allow_virtual_network_access = true
        allow_forwarded_traffic      = false
        allow_gateway_transit        = false
        use_remote_gateways          = false
      }
      green_2_common = {
        name = "green_2_common"
        from = {
          vnet_key = "green"
          virtual_network_name = "vnet-${var.env}-green"
          resource_group_name = "rg-${var.env}-green"
          remote_virtual_network_id = "/subscriptions/${var.subscription}/resourceGroups/rg-dev-green/providers/Microsoft.Network/virtualNetworks/vnet-dev-green"
        }
        to = {
          vnet_key = "common"
          virtual_network_name = "vnet-${var.env}-common"
          resource_group_name = "rg-${var.env}-common-vnet"
          remote_virtual_network_id = "/subscriptions/${var.subscription}/resourceGroups/rg-dev-common-vnet/providers/Microsoft.Network/virtualNetworks/vnet-dev-common"

        }
        allow_virtual_network_access = true
        allow_forwarded_traffic      = false
        allow_gateway_transit        = false
        use_remote_gateways          = false
      }
    }

    application_security_groups = {
      api_sg = {
      resource_group_key = module.variables.rg["green"]
      name               = "api_sg"
      } 
    }

    public_ip_addresses = {
      lb_pip_api = {
        name                    = "${var.env}-green-lb-api-pip"
        resource_group_key      = module.variables.rg["green"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
      lb_pip_api-int = {
        name                    = "${var.env}-green-lb-api-int-pip"
        resource_group_key      = module.variables.rg["green"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
      lb_pip_web = {
        name                    = "${var.env}-green-lb-web-pip"
        resource_group_key      = module.variables.rg["green"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
      green_bastion_pip = {
        name                    = "green_bastion_pip"
        resource_group_key      = module.variables.rg["green"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
      nat_gateway_pip = {
        name                    = "public_ip_nat_gateway"
        resource_group_key      = module.variables.rg["green"]
        sku                     = "Standard"
        allocation_method       = "Static"
        ip_version              = "IPv4"
        idle_timeout_in_minutes = "4"
      }
    }

    nat_gateways = {

      nat_gateway1 = {
        name                    = "nat_gateway1"
        idle_timeout_in_minutes = 10
        vnet_key           = "green"
        subnet_key         = "subnet2"
        public_ip_key      = "nat_gateway_pip"
        resource_group_key = module.variables.rg["green"]
      }
    }

    application_gateways = {
      agw-api = {
      resource_group_key = module.variables.rg["green"]
      name               = "${var.env}-green-api-ag"
      vnet_key           = "green"
      subnet_key         = "subnet4"
      sku_name           = "WAF_v2"
      sku_tier           = "WAF_v2"
      capacity = {
        autoscale = {
          minimum_scale_unit = 2
          maximum_scale_unit = 10
        }
      }
      zones        = ["1"]
      enable_http2 = false
      
      identity = {
        managed_identity_keys = [
        "green_mi"
        ]
      }

      front_end_ip_configurations = {
        public = {
          name          = "api-public"
          public_ip_key = "lb_pip_api"
        }
        private = {
          name                          = "api-private"
          vnet_key                      = "green"
          subnet_key                    = "subnet4"
          subnet_cidr_index             = 0 
          private_ip_offset             = 24
          private_ip_address_allocation = "Static"
        }
      }

      front_end_ports = {
        80 = {
          name     = "http"
          port     = 80
          protocol = "Http"
        }
        443 = {
          name     = "https"
          port     = 443
          protocol = "Https"
        }
        8443 = {
          name     = "8443https"
          port     = 8443
          protocol = "Https"
        }
      }
      waf_configuration = {
        enabled                  = true
        firewall_mode            = "Detection"
        rule_set_type            = "OWASP"
        rule_set_version         = "3.1"
        file_upload_limit_mb     = 100
        request_body_check       = true
        max_request_body_size_kb = 128

        # Optional
        disabled_rule_groups = {
          general = {
            rule_group_name = "General"
            rules           = ["200004"]
          }
          # Disable a spacific rule in the rule group
          REQUEST-913-SCANNER-DETECTION = {
            rule_group_name = "REQUEST-913-SCANNER-DETECTION"
            rules           = ["913102"]
          }
          # Disable all rule in the rule group
          REQUEST-930-APPLICATION-ATTACK-LFI = {
            rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
          }
        }
 

        # Optional
        exclusions = {
          exc1 = {
            match_variable          = "RequestHeaderNames"
            selector_match_operator = "Equals" # StartsWith, EndsWith, Contains
            selector                = "SomeHeader"
          }
        }
      }
    }

      agw-web = {
      resource_group_key = module.variables.rg["green"]
      name               = "${var.env}-green-web-ag"
      vnet_key           = "green"
      subnet_key         = "subnet4"
      sku_name           = "WAF_v2"
      sku_tier           = "WAF_v2"
      capacity = {
        autoscale = {
          minimum_scale_unit = 2
          maximum_scale_unit = 10
        }
      }
      zones        = ["1"]
      enable_http2 = false
      
      identity = {
        managed_identity_keys = [
        "green_mi"
        ]
      }

      front_end_ip_configurations = {
        public = {
          name          = "web-public"
          public_ip_key = "lb_pip_web"

        }
        private = {
          name                          = "web-private"
          vnet_key                      = "green"
          subnet_key                    = "subnet4"
          subnet_cidr_index             = 0
          private_ip_offset             = 14
          private_ip_address_allocation = "Static"
        }
      }

      front_end_ports = {
        80 = {
          name     = "http"
          port     = 80
          protocol = "Http"
        }
        443 = {
          name     = "https"
          port     = 443
          protocol = "Https"
        }
        8443 = {
          name     = "https8443"
          port     = 8443
          protocol = "Https"
        }
      }
      waf_configuration = {
        enabled                  = true
        firewall_mode            = "Detection"
        rule_set_type            = "OWASP"
        rule_set_version         = "3.1"
        file_upload_limit_mb     = 100
        request_body_check       = true
        max_request_body_size_kb = 128

        # Optional
        disabled_rule_groups = {
          general = {
            rule_group_name = "General"
            rules           = ["200004"]
          }
          # Disable a spacific rule in the rule group
          REQUEST-913-SCANNER-DETECTION = {
            rule_group_name = "REQUEST-913-SCANNER-DETECTION"
            rules           = ["913102"]
          }
          # Disable all rule in the rule group
          REQUEST-930-APPLICATION-ATTACK-LFI = {
            rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
          }
        }

        # Optional
        exclusions = {
          exc1 = {
            match_variable          = "RequestHeaderNames"
            selector_match_operator = "Equals" # StartsWith, EndsWith, Contains
            selector                = "SomeHeader"
          }
        }

      }
    }
  }

  application_gateway_applications = {
    agw-api-app = {

      application_gateway_key = "agw-api"
      name                    = "${var.env}-green-api-ag-app"
      listeners = {
        port80 = {
          name                           = "listener80"
          front_end_ip_configuration_key = "public"
          front_end_port_key             = "80"
          # host_name                      = "api1"
          request_routing_rule_key       = "redirect_config"
        }
        port443 = {
          name                           = "listener443"
          front_end_ip_configuration_key = "public"
          front_end_port_key             = "443"
          # host_name                      = "api2"
          request_routing_rule_key       = "default"
          keyvault_certificate = {
            certificate_name = "masimocert"
            keyvault_key     = "masimo"
          }
        }
        port8443 = {
          name                           = "listener8443"
          front_end_ip_configuration_key = "private"
          front_end_port_key             = "8443"
          # host_name                      = "api2"
          request_routing_rule_key       = "default"
          keyvault_certificate = {
            certificate_name = "masimocert2"
            keyvault_key     = "masimo"
          }
        }           
      }

      # redirect_config = {
      #   RedirectType = "permanent"
      #   TargetListener = "port80"
      # }

      request_routing_rules = {
        redirect_config = {
          name = "rc1"
          RedirectType = "permanent"
          TargetListener = "port80"
        }
        # default = {
        #   rule_type = "Basic"
        # }
      }


      backend_http_setting = {
        port                                = 8443
        protocol                            = "Https"
        pick_host_name_from_backend_address = false
        probe_key                           = "probe_1"
        # host_name                           = "masimosafetynetintegration.com"

      }
       probes = {
              probe_1 = {
                  name                = "probe-backend-8443"
                  protocol            = "Https"
                  path                = "/health"
                  host                = "${var.host}"
                  interval            = 30
                  timeout             = 30
                  unhealthy_threshold = 3
                  match               = {
                      status_code = ["200"]
                  }
              }
        }
    }

    agw-web-app = {

      application_gateway_key = "agw-web"
      name                    = "${var.env}-green-web-ag-app"

      listeners = {
        public = {
          name                           = "myapp2-80"
          front_end_ip_configuration_key = "public"
          front_end_port_key             = "80"
          # host_name                      = "web"
          request_routing_rule_key       = "default"
        }
        port443 = {
          name                           = "https_web_listener01"
          front_end_ip_configuration_key = "public"
          front_end_port_key             = "443"
          # host_name                      = "web1"
          request_routing_rule_key       = "default"
          keyvault_certificate = {
            # certificate_key = "masimo"
            certificate_name = "masimocert"
            keyvault_key     = "masimo"
          }
        }
      }



      request_routing_rules = {
        default = {
          rule_type = "Basic"
        }
      }

      backend_http_setting = {
        port                                = 443
        protocol                            = "Https"
        pick_host_name_from_backend_address = false
        probe_key                           = "probe_3"
        # host_name                           = "masimosafetynetintegration.com"
      }
        probes = {
              probe_3 = {
                  name                = "probe-backend-8443"
                  protocol            = "Https"
                  host                = "${var.host}"
                  interval            = 30
                  timeout             = 30
                  path                = "/health"
                  unhealthy_threshold = 3
                  match               = {
                      status_code = ["200"]
                  }
              }
        }
    }
  }

    network_security_group_definition = var.network_security_group_definition
    
    private_dns = {
      masimosafetynetintegration = {
        name               = "${var.host}" 
        resource_group_key = module.variables.rg["green"]

        records = {
          a_records = {
            mongo = {
              name    = "db0"
              ttl     = 60
              records = ["10.100.3.4"]
            }
            applb = {
              name    = "applb"
              ttl     = 60
              records = ["10.101.4.24"]
            }
            app = {
              name    = "app"
              ttl     = 60
              records = ["10.101.4.24"]
            }
          }
        }

        vnet_links = {
          link_test = {
            name     = "green-vnet-link"
            vnet_key = "green"
          }
        }
      }
    }  
  }

  compute = {
     virtual_machine_scale_sets = {
      api-vmss = {
        resource_group_key                   = module.variables.rg["green"]
        os_type                              = "linux"
        # keyvault_key                         = "vault_uri"
        public_key_pem_file                  = "ssh-dev.pub"

        vmss_settings = {
          linux =  module.vmss_api.vmss_settings_linux

        }

        network_interfaces = { 
          nic0 = module.vmss_api.network_interfaces
        }

        data_disks = {
          data1 = module.vmss_api.data_disks
        }

      }

      web-vmss = {
        resource_group_key                   = module.variables.rg["green"]
        os_type                              = "linux"
        # keyvault_key                         = "vault_uri"
        public_key_pem_file                  = "ssh-dev.pub"

        vmss_settings = {
          linux =  module.vmss_web.vmss_settings_linux

        }

        network_interfaces = { 
          nic0 = module.vmss_web.network_interfaces
        }

        data_disks = {
          data1 = module.vmss_web.data_disks
        }

      }
    }

  # Virtual machines
  virtual_machines = {

    bastion_host = {
      resource_group_key = module.variables.rg["green"]
      provision_vm_agent = true
      os_type = "linux"
      public_key_pem_file             = "bastion.pub"
      keyvault_key = "bastion_kv"

      networking_interfaces = {
        nic1 = {
          vnet_key                = "green"
          subnet_key              = "subnet2"
          name                    = "dev-green-bastion"
          enable_ip_forwarding    = false
          internal_dns_name_label = "nic1"
          public_ip_address_key   = "green_bastion_pip"

          # networking_interface_asg_associations = {
          #   bastion = {
          #     key = "bastion"
          #   }
          # }
        }
      }

      virtual_machine_settings = {
        linux = {
          name                            = "bastion_host"
          size                            = "Standard_F2"
          admin_username                  = "ubuntu"
          public_key                      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"

          disable_password_authentication = true

          zone = "1"

          # Value of the nic keys to attach the VM. The first one in the list is the default nic
          network_interface_keys = ["nic1"]

          os_disk = {
            name                 = "bastion_host-os"
            caching              = "ReadWrite"
            storage_account_type = "Standard_LRS"
          }

          source_image_reference = {
            publisher = "Canonical"
            offer     = "UbuntuServer"
            sku       = "18.04-LTS"
            version   = "latest"
          }
        }
      }
    }
    }  
  }
  
  diagnostics = {
    diagnostic_storage_accounts     = var.diagnostic_storage_accounts
  }
}


