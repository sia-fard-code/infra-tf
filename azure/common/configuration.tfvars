global_settings = {
  default_region = "region1"
  regions = {
    region1 = "westus2"
  }
  random_length  = 0
  environment = "dev"
  useprefix   = false
  prefix = ""
}

# Application security groups
application_security_groups = {
  app_sg1 = {
    resource_group_key = "common_rg"
    name               = "app_sg1"
  }
  bastion = {
    name               = "bastionappsecgw1"
    resource_group_key = "bastion_rg"
  }
}



