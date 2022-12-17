variable "color" {
    default = "blue"
}

variable "service" {
    default = "api"
}

variable "subscription" {
  type = string
  default = "10b5e15c-8d59-4b7e-a59b-d47fb2f01f71"
}


variable "app_name" {
  type = string
}

variable "computer_name_prefix" {
  type = string
}

variable "env" {
  type = string
  default = "dev"
}

output "vmss_settings_linux" {
    value = {        
            name                            = "${var.env}-${var.color}-${var.app_name}"
            computer_name_prefix            = var.computer_name_prefix
            sku                             = "Standard_DS1_v2"
            instances                       = 1
            admin_username                  = "ubuntu"
            public_key                      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt95DqmrATAJEHch4e5foJbhKazbwkBjDYOIp739faxMx1pkM1dGIl3UuQESZcSETKpL5qL29IKBdHfgFSB6J+9H9MxBlgJXmJGHK6+4g9ivdtEmGhOSfUDdMZ9rzlpN0MDttdj22vn37O0lGWTA1IwD4Wz8iDi0X7EW4X4Yk9r3AjS2R3I+D6BDFuNhuQt4oiIpM3IiXg3q95BWs4d6KNkj3iY8NDekSsWDSRoE9wH3QYFQhKN/G3VF2W2HJPCKXmGMrp2RpmzxDVQXXeBPFsaXmpUlOF5NBwR5yG9U8QWnQel9cVOZz9LWFEymTEcpxRKemj95haBK0S/JobyiGt msadri@AVMACBOOKPROMSAD.local"
            disable_password_authentication = true
            provision_vm_agent              = true
            priority                        = "Regular"
            ultra_ssd_enabled               = false
            upgrade_mode = "Manual"
            os_disk = {
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
              disk_size_gb         = 128
            }

            identity = {
              type                  = "UserAssigned"
              managed_identity_keys = ["blue_mi"]
            }

            custom_image_id = "/subscriptions/10b5e15c-8d59-4b7e-a59b-d47fb2f01f71/resourceGroups/rg-dev-images/providers/Microsoft.Compute/galleries/sig_dev_common_msn/images/si_dev_common_msn_api_v/versions/1230.008.3"
    
    }
}

variable "appgw_backend_pools" {
    type = any
} 

output "network_interfaces" {
    value = {
            name       = "0"
            primary    = true
            vnet_key   = var.color
            subnet_key = "subnet2"

            appgw_backend_pools = var.appgw_backend_pools

            enable_accelerated_networking = false
            enable_ip_forwarding          = false
            internal_dns_name_label       = "nic0"
          
        }
}

variable "data_disks_map" {
    default = {
        blue = {
            caching                   = "None"  # None / ReadOnly / ReadWrite
            create_option             = "Empty" # Empty / FromImage (only if source image includes data disks)
            disk_size_gb              = "10"
            lun                       = 1
            storage_account_type      = "Standard_LRS" # UltraSSD_LRS only possible when > additional_capabilities { ultra_ssd_enabled = true }
            write_accelerator_enabled = false          # true requires Premium_LRS and caching = "None"
        }
    }
}
    

output "data_disks" {
    value = lookup(var.data_disks_map, var.color)
  
}