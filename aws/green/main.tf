locals {
  fqdn         = "${module.variables.second_level_domains}.${module.variables.top_level_domains}"
  dns_zone_int = "${module.variables.second_level_domains}.internal"
  msn_svc_enabled = contains(var.msn_svc_env, terraform.workspace)
  msn_open_enabled = contains(var.msn_open_env, terraform.workspace)
  msn_th_enabled = contains(var.msn_th_env, terraform.workspace)
  dns_dr          = contains(var.dr_env, terraform.workspace) ? "-dr" : ""
  records_pub = [
   {
      name    = "www-g${local.dns_dr}"
      type    = "A"
      alias   = {
        name    = module.alb.web_dns_name
        zone_id = module.alb.web_zone_id
      }
    },
    {
      name    = "admin-g${local.dns_dr}"
      type    = "A"
      alias   = {
        name    = module.alb.admin_dns_name
        zone_id = module.alb.admin_zone_id
      }
    },
    {
      name    = "app-g${local.dns_dr}"
      type    = "A"
      alias   = {
        name    = module.alb.api_dns_name_pub
        zone_id = module.alb.api_zone_id_pub
      }
    },
 ]
  color            = "GREEN"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = local.region
  default_tags {
    tags = module.variables.extra_tags 
  }

#  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
#    role_arn    = "arn:aws:iam::366839203706:role/MSM-ACCESS_DEPLOYMENT_TO_MSM-PRODUCTION"
    # (Optional) The external ID created in step 1c.
    # external_id = "my_external_id"
#  }
}

terraform {
  backend "s3" {
  }
}

module "variables" {
  source      = "../modules/variables"
  environment = local.environment
  region      = local.region
  color       = local.color
  is_prod     = contains(var.prod_env, terraform.workspace)
  is_dr       = contains(var.dr_env, terraform.workspace)
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    access_key     = var.backend_aws_access_key
    secret_key     = var.backend_aws_secret_key
    region         = "us-west-2"
    bucket         = "com.masimo.msn.tf.${var.env_type}"
    key            = "aws/${terraform.workspace}/common.tfstate"
  }
}
# data "aws_acm_certificate" "cert" {
#   domain   = "*.${local.fqdn}"
#   statuses = ["ISSUED"]
# }
module "alb" {
  source                     = "../modules/alb-new"
  env                        = local.environment
  msn_prefix                 = ""
  msn_svc_enabled            = local.msn_svc_enabled
  msn_open_enabled           = local.msn_open_enabled
  msn_th_enabled             = local.msn_th_enabled
  type                       = ["GREEN"]
  vpc_id                     = data.terraform_remote_state.common.outputs.vpc_dc_id
  open_api_https_prv_arn     = data.terraform_remote_state.common.outputs.open_api_https_prv_arn
  api_https_prv_arn          = data.terraform_remote_state.common.outputs.api_https_prv_arn
  vpc_prv_subnet_cidr_blocks = { "GREEN" = data.terraform_remote_state.common.outputs.vpc_prv_subnet_cidr_green }
  domain_arn                 = data.terraform_remote_state.common.outputs.acm_certificate_arn
  # domain_arn = data.aws_acm_certificate.cert.arn
  alb_web_sg_ids = [data.terraform_remote_state.common.outputs.alb_web_sg_id]
  alb_admin_sg_ids = [data.terraform_remote_state.common.outputs.alb_web_sg_id]
  alb_open_api_sg_ids = [data.terraform_remote_state.common.outputs.alb_open_api_sg_id]
  alb_gateway_sg_ids = [data.terraform_remote_state.common.outputs.alb_gateway_sg_id]
  alb_api_sg_ids = [data.terraform_remote_state.common.outputs.alb_api_sg_id]
  nlb_db_sg_ids  = [data.terraform_remote_state.common.outputs.db_sg_id]
  db_subnets     = data.terraform_remote_state.common.outputs.vpc_db_prv_subnet_ids
  web_subnets    = data.terraform_remote_state.common.outputs.vpc_dc_public_subnets
  api_subnets    = data.terraform_remote_state.common.outputs.vpc_dc_public_subnets
  admin_subnets  = data.terraform_remote_state.common.outputs.vpc_dc_public_subnets
  open_api_subnets  = data.terraform_remote_state.common.outputs.vpc_dc_public_subnets
  gateway_subnets  = data.terraform_remote_state.common.outputs.vpc_dc_public_subnets
}

module "msn_route53" {
  source  = "../modules/records"
  count   = 1

  zone_id = module.variables.dns_zone_ids
  private_zone = false
  zone_name = local.fqdn
  records = local.msn_svc_enabled || local.msn_open_enabled ? concat(
    [
    {
      name    = "api-g${local.dns_dr}"
      type    = "A"
      alias   = {
        name    = module.alb.gateway_dns_name
        zone_id = module.alb.gateway_zone_id
      }
    }
    ],
    local.records_pub,
  ) : local.records_pub

 depends_on = [module.alb]
}

module "web_asg" {
  source                  = "../modules/asg-lt"
  count                   = 1
  ami                     = module.variables.ubuntu_amis //TODO: Remove this if possible - may cause drift issues
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-web"]
  deployment_map          = [local.color]
  instance_type           = "m5.large"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_web_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_web_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_web_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_web_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-web"
      }

  lt_tag = "msn-web-${local.environment}-scale"
}

module "api_asg" {
  source                  = "../modules/asg-lt"
  count                   = 1
  ami                     = module.variables.ubuntu_amis // TODO See if you can remove this. Might cause drift issues
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-api"]
  deployment_map          = [local.color]
  instance_type           = "m5.large"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_api_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_api_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_api_arn_pub, module.alb.tg_api_arn_prv]
  }
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_api_kms_arn
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "2"
  lt_tag                   = "msn-api-${local.environment}-scale"
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-api"
      }
}

module "admin_asg" {
  source                  = "../modules/asg-lt"
  count                   = 1
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-admin-app"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_admin_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_admin_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_admin_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_admin_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-admin-app"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-admin-app"
}

module "risk_asg" {
  count                   = local.msn_svc_enabled || local.msn_open_enabled ? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-risk-service"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_risk_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_risk_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_risk_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-risk-service"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-risk-service-scale"
}

module "streaming_asg" {
  count                   = local.msn_svc_enabled  || local.msn_open_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-streaming-service"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_streaming_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_streaming_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_streaming_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-streaming-service"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-streaming-service-scale"
}
module "system_events_rest_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-system-events-rest"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_system_events_rest_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_system_events_rest_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_system_events_rest_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-system-events-rest"
      }

}

module "system_events_consumer_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-system-events-consumer"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_system_events_consumer_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_system_events_consumer_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-system-events-consumer"
      }

}

module "external_integration_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-external-integration"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_external_integration_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_external_integration_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_external_integration_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-external-integration"
      }

}

module "vitals_rest_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-vitals-rest"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_vitals_rest_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_vitals_rest_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_vitals_rest_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-vitals-rest"
      }

}


module "vitals_data_capture_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-vitals-data-capture"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_vitals_data_capture_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_vitals_data_capture_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-vitals-data-capture"
      }

}

module "legacy_data_capture_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-legacy-data-capture"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_legacy_data_capture_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_legacy_data_capture_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-legacy-data-capture"
      }

}
module "gateway_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-gateway"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_gateway_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_gateway_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_gateway_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-gateway"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-gateway-scale"
}

module "activity_asg" {
  count                   = local.msn_svc_enabled  || local.msn_open_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-activity-service"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_activity_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_activity_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_activity_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-activity-service"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-activity-service-scale"
}

module "open_rest_asg" {
  count                   = local.msn_svc_enabled  || local.msn_open_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-open-rest"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_open_rest_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_open_rest_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  alb_target_group_arn = {
    0 = [module.alb.tg_open_rest_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-open-rest"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-open-rest-scale"
}

module "status_scheduler_asg" {
  count                   = local.msn_svc_enabled  || local.msn_open_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-status-scheduler"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_status_scheduler_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_status_scheduler_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_open_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-status-scheduler"
      }

  lt_tag = "${local.environment}${var.msn_prefix}-status-scheduler-scale"
}

module "hifi_download_asg" {
  count                   = local.msn_svc_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-hifi-download"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_hifi_download_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_hifi_download_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_green
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-hifi-download"
      }

}

module "telehealth_service_asg" {
  count                   = local.msn_th_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-telehealth-service"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_telehealth_service_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_telehealth_service_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_blue
  alb_target_group_arn = {
    0 = [module.alb.tg_telehealth_service_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-telehealth-service"
      }


}

module "patient_settings_asg" {
  count                   = local.msn_th_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-patient-settings"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_patient_settings_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_patient_settings_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_blue
  alb_target_group_arn = {
    0 = [module.alb.tg_patient_settings_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-patient-settings"
      }


}

module "notification_service_asg" {
  count                   = local.msn_th_enabled? 1 : 0
  source                  = "../modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-notification-service"]
  deployment_map          = [local.color]
  instance_type           = "t3.medium"
  key_name                = data.terraform_remote_state.common.outputs.app_server_key_name
  vpc_security_group_ids  = [data.terraform_remote_state.common.outputs.alb_notification_service_sg_id]
  security_group_names    = [data.terraform_remote_state.common.outputs.alb_notification_service_sg_name]
  subnet_ids              = data.terraform_remote_state.common.outputs.vpc_dc_private_subnets_blue
  alb_target_group_arn = {
    0 = [module.alb.tg_notification_service_arn]
  }
  desired_capacity         = "0"
  min_size                 = "0"
  max_size                 = "4"
  iam_instance_profile_arn = data.terraform_remote_state.common.outputs.iam_msn_svc_kms_arn
  tags = {
       Name = "${local.environment}-${var.index_to_deployment_map[1]}${var.msn_prefix}-notification-service"
      }


}
