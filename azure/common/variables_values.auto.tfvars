# Authors     : Siavash Fard.
# Purpose     : IAC for Masimo common environment.
# Description : Terraform template that contains the configuration of the infrastructure for Masimo's common environment.  



# Virtual network address space
vnet_address_space = ["172.16.0.0/16"]  

# Default subnet address prefix
default_subnet_address_prefix = ["172.16.0.0/24"]  

# Application gateway subnet address prefix
appGateway_subnet_address_prefix = ["172.16.1.0/24"]

# Load balancer subnet address prefix
loadBalancer_subnet_address_prefix = ["172.16.5.0/24"]

# Mongo VM subnet address prefix
mongoVm_subnet_address_prefix = ["172.16.2.0/24"]

# Admin VM subnet address prefix
adminVm_subnet_address_prefix = ["172.16.4.0/24"]

# Bastion service subnet address prefix
bastion_service_subnet_address_prefix = ["172.16.6.0/27"]

# Bastion VM subnet address prefix
bastionVm_subnet_address_prefix = ["172.16.3.0/24"]
