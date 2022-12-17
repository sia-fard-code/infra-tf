# Virtual machines
virtual_machines = {

  # Configuration to deploy a bastion host linux virtual machine
  bastion_host = {
    resource_group_key = "common_rg"
    provision_vm_agent = true
    os_type = "linux"
    keyvault_key = "bastion_kv"

    networking_interfaces = {
      nic1 = {
        # Value of the keys from networking.tfvars
        vnet_key                = "common"
        subnet_key              = "subnet2"
        name                    = "dev-common-bastion"
        enable_ip_forwarding    = false
        internal_dns_name_label = "nic1"
        public_ip_address_key   = "bastion_pip"

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
        size                            = "Standard_F2s"
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