This module was coded for the msn-infrastructure repo. We may not get access to
that repo after all. So, the code is copied here. Should be pretty straight
forward to adapt to this repo, just need to collect the necessary variables.

aws

- variables.tf
- main.tf
- modules
  - pan
    - main.tf
    - outputs.tf
    - variables.tf

Updated the msn-infrastructure/aws/main.tf with the following

```terraform
module "pan" {
  source            = "./modules/pan"
  region            = local.region
  vpc_id            = module.vpc.vpc_dc_id
  server_key_name   = ""
  pan_instance_size = var.pan_instance_size
  volume_size       = var.pan_volume_size

  plan = {
    pan_az1 = {
      mgt_subnet_id      = module.vpc.vpc_dc_public_subnets[0]
      pub_subnet_id      = module.vpc.vpc_dc_public_subnets[0]
      pri_subnet_id      = module.vpc.vpc_api_prv_subnet_a
      availability_zone  = "${local.region}a"
      pri_route_table_id = module.vpc.vpc_dc_private_route_table_ids[0]
    }
    pan_az2 = {
      mgt_subnet_id      = module.vpc.vpc_dc_public_subnets[1]
      pub_subnet_id      = module.vpc.vpc_dc_public_subnets[1]
      pri_subnet_id      = module.vpc.vpc_api_prv_subnet_b
      pri_route_table_id = "${local.region}b"
      availability_zone  = module.vpc.vpc_dc_private_route_table_ids[1]
    }
  }
}
```

Had to add the variables as well to msn-infrastructure/aws/variables.tf

```terraform
variable "pan_instance_size" {
  default = "m5.4xlarge"
}

variable "pan_volume_size" {
  default = 60
}
```

And finally had to update the vpc module outputs msn-infrastructure/aws/modules/vpc/outputs.tf

```terraform
output "vpc_dc_private_route_table_ids" {
  value = module.vpc_dc.private_route_table_ids
}
```
