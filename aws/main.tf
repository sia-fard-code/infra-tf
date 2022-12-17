locals {
  fqdn         = "${module.variables.second_level_domains}.${module.variables.top_level_domains}"
  dns_zone_int = "${module.variables.second_level_domains}.internal"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = local.region
#  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
#    role_arn    = "arn:aws:iam::366839203706:role/MSM-ACCESS_DEPLOYMENT_TO_MSM-PRODUCTION"
    # (Optional) The external ID created in step 1c.
    # external_id = "my_external_id"
#  }
}

terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "com.masimo.safetynet.tf.prod"
    key            = "state.tfstate"
    dynamodb_table = "com.masimo.safetynet.tf.prod"
  }
}

module "variables" {
  source      = "./modules/variables"
  environment = local.environment
  region      = local.region
}

resource "aws_key_pair" "bastion" {
  key_name   = "${local.environment}-${var.key_name_bastion}"
  public_key = module.variables.ssh_bastion_public_keys
}

resource "aws_key_pair" "app_server" {
  key_name   = "${local.environment}-${var.key_name_app_server}"
  public_key = module.variables.ssh_dev_public_keys
}
data "aws_acm_certificate" "cert" {
  domain   = "*.${local.fqdn}"
  statuses = ["ISSUED"]
}
/*
module "external-certificate" {
  source                    = "terraform-aws-modules/acm/aws"
  domain_name               = local.fqdn
  zone_id                   = module.variables.dns_zone_ids
  subject_alternative_names = ["*.${local.fqdn}"]
  wait_for_validation       = false
  tags = {
    Environment = local.environment
    Description = "Managed by Terraform"
    Name        = "${local.environment}-${local.fqdn}"
  }
}
*/

module "vpc" {
  source             = "./modules/vpc"
  env                = local.environment
  security_group_ids = [module.sg.internal_sg_id]
  vpc_name           = "${var.vpc_name}-${local.environment}"
  vpc_cidr           = module.variables.vpc_cidrs
  azs_a              = "${local.region}a"
  azs_b              = "${local.region}b"

  pan_env = var.pan_env
  cluster_name   = join("-", [var.cluster_name, local.environment])
  rke_cluster_id = join("-", [var.rke_cluster_id, local.environment])

  azs_c = ""
}

module "sg" {
  source       = "./modules/security-groups"
  vpc_id       = module.vpc.vpc_dc_id
  env          = local.environment
  pan_env      = var.pan_env
  msn_open_env      = var.msn_open_env
  allowed_cidr = [module.variables.vpc_cidrs]
}

module "alb" {
  source                     = "./modules/alb"
  env                        = local.environment
  type                       = ["BLUE", "GREEN"]
  vpc_id                     = module.vpc.vpc_dc_id
  vpc_prv_subnet_cidr_blocks = { "BLUE" = module.vpc.vpc_prv_subnet_cidr_blue, "GREEN" = module.vpc.vpc_prv_subnet_cidr_green }
//  domain_arn                 = module.external-certificate.acm_certificate_arn
  domain_arn = data.aws_acm_certificate.cert.arn
  alb_web_sg_ids = [module.sg.alb_web_sg_id]
  alb_admin_sg_ids = [module.sg.alb_web_sg_id]
  alb_open_api_sg_ids = module.sg.alb_open_api_sg_id
  alb_gateway_sg_ids = module.sg.alb_gateway_sg_id
  alb_api_sg_ids = [module.sg.alb_api_sg_id]
  nlb_db_sg_ids  = [module.sg.db_sg_id]
  db_subnets     = module.vpc.vpc_db_prv_subnet_ids
  web_subnets    = module.vpc.vpc_dc_public_subnets
  api_subnets    = module.vpc.vpc_dc_public_subnets
  admin_subnets  = module.vpc.vpc_dc_public_subnets
  open_api_subnets  = module.vpc.vpc_dc_public_subnets
  gateway_subnets  = module.vpc.vpc_dc_public_subnets
  msn_open_env = var.msn_open_env
}

resource "aws_route53_zone" "msn_private_zone" {
  name = local.fqdn

  vpc {
    vpc_id = module.vpc.vpc_dc_id
  }
}
/*
resource "aws_route53_zone" "db_private_zone" {
  name = local.dns_zone_int

  vpc {
    vpc_id = module.vpc.vpc_dc_id
  }
}
*/
module "route53_aliases" {
  source = "./modules/route53"
  count                   = terraform.workspace == "PROD-US" ? 0 : 1
  aliases = contains(var.dr_env, terraform.workspace) ? {
    prv_db = {
      alias           = "db0.${local.fqdn}."
      parent_zone_id  = aws_route53_zone.msn_private_zone.zone_id
      target_dns_name = module.alb.db_dns_name_prv
      target_zone_id  = module.alb.db_zone_id_prv
    }
    prv_app = {
      alias           = "applb.${local.fqdn}."
      parent_zone_id  = aws_route53_zone.msn_private_zone.zone_id
      target_dns_name = module.alb.api_dns_name_prv
      target_zone_id  = module.alb.api_zone_id_prv
    }
  } : {
    pub_wide = {
      alias           = "*.${local.fqdn}."
      parent_zone_id  = module.variables.dns_zone_ids
      target_dns_name = module.alb.web_dns_name[local.deployment]
      target_zone_id  = module.alb.web_zone_id[local.deployment]
    }
    pub_admin = {
      alias           = "admin.${local.fqdn}."
      parent_zone_id  = module.variables.dns_zone_ids
      target_dns_name = module.alb.admin_dns_name[local.deployment]
      target_zone_id  = module.alb.admin_zone_id[local.deployment]
    }
    pub_app = {
      alias           = "app.${local.fqdn}."
      parent_zone_id  = module.variables.dns_zone_ids
      target_dns_name = module.alb.api_dns_name_pub[local.deployment]
      target_zone_id  = module.alb.api_zone_id_pub[local.deployment]
    }
    pub_api = {
      alias           = "api.${local.fqdn}."
      parent_zone_id  = module.variables.dns_zone_ids
      target_dns_name = module.alb.gateway_dns_name[local.deployment]
      target_zone_id  = module.alb.gateway_zone_id[local.deployment]
    }
    prv_db = {
      alias           = "db0.${local.fqdn}."
      parent_zone_id  = aws_route53_zone.msn_private_zone.zone_id
      target_dns_name = module.alb.db_dns_name_prv
      target_zone_id  = module.alb.db_zone_id_prv
    }
    prv_api = {
      alias           = "api.${local.fqdn}."
      parent_zone_id  = aws_route53_zone.msn_private_zone.zone_id
      target_dns_name = module.alb.open_api_dns_name[0]
      target_zone_id  = module.alb.open_api_zone_id[0]
    }
    prv_app = {
      alias           = "applb.${local.fqdn}."
      parent_zone_id  = aws_route53_zone.msn_private_zone.zone_id
      target_dns_name = module.alb.api_dns_name_prv
      target_zone_id  = module.alb.api_zone_id_prv
    }
  }
  records = contains(var.prod_env, terraform.workspace) ? {
    smtp = {
      alias          = "${local.fqdn}."
      parent_zone_id = module.variables.dns_zone_ids
      type           = "MX"
      ttl            = 1800
//      records        = ["10 mail-main.masimo.com", "20 smtp.masimo.com", "40 mail-wazzu.masimo.com"]
      records        = ["10 inbound-smtp.${local.region}.amazonaws.com"]
    }
  }:{
    smtp = {
      alias          = "${local.fqdn}."
      parent_zone_id = module.variables.dns_zone_ids
      type           = "MX"
      ttl            = 1800
      records        = ["10 mail-main.masimo.com", "20 smtp.masimo.com", "40 mail-wazzu.masimo.com"]
//      records        = ["10 inbound-smtp.${local.region}.amazonaws.com"]
    }
  }
}

module "kms_key" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=master"
  namespace               = "doctella"
  stage                   = local.environment
  name                    = "efs"
  description             = "KMS key for EFS"
  deletion_window_in_days = 10
  enable_key_rotation     = false
  alias                   = "alias/${local.environment}-MSN-CMK"
}

module "efs-web" {
  source          = "./modules/efs"
  namespace       = "doctella"
  stage           = local.environment
  name            = "web"
  encrypted       = true
  kms_key_id      = module.kms_key.key_arn
  region          = local.region
  vpc_id          = module.vpc.vpc_dc_id
  subnets         = [module.vpc.vpc_dc_private_subnets[0], module.vpc.vpc_dc_private_subnets[1]]
  security_groups = [module.sg.alb_web_sg_id]
  zone_id         = aws_route53_zone.msn_private_zone.zone_id
  dns_name        = "efs-web-${lower(local.environment)}"
}

module "efs-api" {
  source          = "./modules/efs"
  namespace       = "doctella"
  stage           = local.environment
  name            = "api"
  region          = local.region
  encrypted       = true
  kms_key_id      = module.kms_key.key_arn
  vpc_id          = module.vpc.vpc_dc_id
  subnets         = [module.vpc.vpc_dc_private_subnets[0], module.vpc.vpc_dc_private_subnets[1]]
  security_groups = [module.sg.alb_api_sg_id]
  zone_id         = aws_route53_zone.msn_private_zone.zone_id
  dns_name        = "efs-api-${lower(local.environment)}"
}

resource "aws_s3_bucket" "msk_bucket" {
  bucket = "${lower(local.environment)}-msn-open-msk-broker-logs"
  acl    = "private"
}

module "msk-cluster" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source  = "angelabad/msk-cluster/aws"

  cluster_name    = "${upper(local.environment)}-msn-open-msk"
  instance_type   = "kafka.m5.large"
  number_of_nodes = 2
  client_subnets  = [module.vpc.vpc_prv_subnet_a, module.vpc.vpc_prv_subnet_b]
  kafka_version   = "2.5.1"
  encryption_at_rest_kms_key_arn = module.kms_key.key_arn

  enhanced_monitoring = "PER_BROKER"

  s3_logs_bucket = aws_s3_bucket.msk_bucket.id
  s3_logs_prefix = "logs/${lower(local.environment)}-msn-open-"

  prometheus_jmx_exporter  = true
  prometheus_node_exporter = true

  extra_security_groups      = [module.sg.internal_sg_id]
  server_properties = {
    "auto.create.topics.enable" = "true"
    "default.replication.factor" = "2"
    "min.insync.replicas" = "1"
    "num.io.threads" = "8"
    "num.network.threads" = "5"
    "num.partitions" = "1"
    "num.replica.fetchers" = "2"
    "replica.lag.time.max.ms" = "30000"
    "socket.receive.buffer.bytes" = "102400"
    "socket.request.max.bytes" = "104857600"
    "socket.send.buffer.bytes" = "102400"
    "unclean.leader.election.enable" = "true"
    "zookeeper.session.timeout.ms" = "18000"
  }
  volume_size = 100
  tags = {
    Environment = "TF"
  }
}

resource "aws_eip" "bastion" {
  vpc = true
}

module "iam" {
  source = "./modules/iam"
  msn_open_env      = var.msn_open_env
  env    = local.environment
}

module "bastion" {
  source                      = "./modules/bastion"
  name                        = "${local.environment}-bastion"
  env                         = local.environment
  instance_type               = "t2.micro"
  ami                         = module.variables.ubuntu_amis
  region                      = local.region
  s3_bucket_name              = "bastion-stg-swift-cloud"
  vpc_id                      = module.vpc.vpc_dc_id
  subnet_ids                  = [module.vpc.vpc_dc_public_subnets[0]]
  associate_public_ip_address = true
  ssh_user                    = var.bastion_ssh_user
  key_name                    = aws_key_pair.bastion.key_name
  eip_ip                      = aws_eip.bastion.public_ip
  eip_id                      = aws_eip.bastion.id
  iam_instance_profile        = module.iam.api_kms_arn
}

module "web_asg" {
  source                  = "./modules/asg-lt"
  count                   = terraform.workspace == "PROD-US" ? 0 : 1
  ami                     = module.variables.ubuntu_amis //TODO: Remove this if possible - may cause drift issues
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-web", "${local.environment}-${var.index_to_deployment_map[1]}-msn-web"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "m5.large"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_web_sg_id]
  security_group_names    = [module.sg.alb_web_sg_name]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_web_arn[0]]
    1 = [module.alb.tg_web_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.web_kms_arn

  lt_tag = "msn-web-${local.environment}-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "api_asg" {
  source                  = "./modules/asg-lt"
  count                   = terraform.workspace == "PROD-US" ? 0 : 1
  ami                     = module.variables.ubuntu_amis // TODO See if you can remove this. Might cause drift issues
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-api-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-api-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "m5.large"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_api_sg_id]
  security_group_names    = [module.sg.alb_api_sg_name]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_api_arn_pub[0], module.alb.tg_api_arn_prv[0]]
    1 = [module.alb.tg_api_arn_pub[1], module.alb.tg_api_arn_prv[1]]
  }
  iam_instance_profile_arn = module.iam.api_kms_arn
  desired_capacity         = "2"
  min_size                 = "1"
  max_size                 = "2"
  lt_tag                   = "msn-api-${local.environment}-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "admin_asg" {
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-admin-app", "${local.environment}-${var.index_to_deployment_map[1]}-msn-admin-app"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_admin_sg_id]
  security_group_names    = [module.sg.alb_admin_sg_name]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_admin_arn[0]]
    1 = [module.alb.tg_admin_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.admin_kms_arn

  lt_tag = "${local.environment}-msn-admin-app"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "risk_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-risk-service-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-risk-service-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_risk_sg_id[0]]
  security_group_names    = [module.sg.alb_risk_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_risk_arn[0]]
    1 = [module.alb.tg_risk_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-risk-service-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "streaming_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-streaming-service-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-streaming-service-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_streaming_sg_id[0]]
  security_group_names    = [module.sg.alb_streaming_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_streaming_arn[0]]
    1 = [module.alb.tg_streaming_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-streaming-service-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "gateway_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-gateway-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-gateway-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_gateway_sg_id[0]]
  security_group_names    = [module.sg.alb_gateway_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_gateway_arn[0]]
    1 = [module.alb.tg_gateway_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-gateway-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "activity_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-activity-service-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-activity-service-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_activity_sg_id[0]]
  security_group_names    = [module.sg.alb_activity_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_activity_arn[0]]
    1 = [module.alb.tg_activity_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-activity-service-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "open_rest_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-open-rest-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-open-rest-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_open_rest_sg_id[0]]
  security_group_names    = [module.sg.alb_open_rest_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  alb_target_group_arn = {
    0 = [module.alb.tg_open_rest_arn[0]]
    1 = [module.alb.tg_open_rest_arn[1]]
  }
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-open-rest-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}

module "status_scheduler_asg" {
  count                   = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  source                  = "./modules/asg-lt"
  ami                     = module.variables.ubuntu_amis
  name                    = ["${local.environment}-${var.index_to_deployment_map[0]}-msn-status-scheduler-scale", "${local.environment}-${var.index_to_deployment_map[1]}-msn-status-scheduler-scale"]
  deployment_map          = ["BLUE","GREEN"]
  instance_type           = "t3.medium"
  key_name                = aws_key_pair.app_server.key_name
  vpc_security_group_ids  = [module.sg.alb_status_scheduler_sg_id[0]]
  security_group_names    = [module.sg.alb_status_scheduler_sg_name[0]]
  subnet_ids              = module.vpc.vpc_dc_private_subnets
  desired_capacity         = "1"
  min_size                 = "1"
  max_size                 = "4"
  iam_instance_profile_arn = module.iam.msn_open_kms_arn[0]

  lt_tag = "${local.environment}-msn-status-scheduler-scale"
  extra_tags = [
    {
      key                 = "Group"
      value               = local.environment
      propagate_at_launch = true
    },
  ]
}


resource "aws_launch_template" "mongo" {
  name          = "${local.environment}-MSN-mongo"
  image_id      = module.variables.ubuntu_amis
  instance_type = module.variables.db_instance_type
  key_name      = aws_key_pair.app_server.key_name

  lifecycle {
    ignore_changes = [
      tags, image_id, security_group_names, user_data, description, block_device_mappings, tag_specifications
    ]
  }
}

module "pan" {
  name            = "${local.environment}-Palo-Alto"
  source          = "./modules/pan"
  region          = local.region
  env             = local.environment
  count           = contains(var.pan_env, terraform.workspace) ? 1 : 0
  vpc_id          = module.vpc.vpc_dc_id
  server_key_name = aws_key_pair.app_server.key_name
  instance_size   = var.pan_instance_size
  volume_size     = var.pan_volume_size
  pan_pub_sg      = module.sg.pan_sg_id[0]
  pan_prv_sg      = module.sg.internal_sg_id
  vpc_cidr        = module.variables.vpc_cidrs
  bucket_name     = lower("${local.environment}-${local.region}-masimo-pan-config")

  plan = contains(var.prod_env, terraform.workspace) ? {
    pan_az1 = {
      mgt_subnet_id      = module.vpc.vpc_dc_public_subnets[0]
      pub_subnet_id      = module.vpc.vpc_dc_pan_subnets[0]
      app_subnet_id      = module.vpc.vpc_prv_subnet_a
      db_subnet_id      = module.vpc.vpc_db_prv_subnet_ids[0]
      sub1_subnet_id       = module.vpc.vpc_dc_private_subnets[4]
      app_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[0], module.vpc.vpc_dc_private_route_table_ids[2], module.vpc.vpc_dc_db_route_table_ids[0]]
      sub1_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[4]]
      sequence           = "a"
    }
    pan_az2 = {
      mgt_subnet_id      = module.vpc.vpc_dc_public_subnets[1]
      pub_subnet_id      = module.vpc.vpc_dc_pan_subnets[1]
      app_subnet_id      = module.vpc.vpc_prv_subnet_b
      db_subnet_id      = module.vpc.vpc_db_prv_subnet_ids[1]
      sub1_subnet_id       = module.vpc.vpc_dc_private_subnets[5]
      app_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[1], module.vpc.vpc_dc_private_route_table_ids[3], module.vpc.vpc_dc_db_route_table_ids[1]]
      sub1_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[5]]
      sequence           = "b"
    }
   } : {
    pan_az1 = {
      mgt_subnet_id      = module.vpc.vpc_dc_public_subnets[0]
      pub_subnet_id      = module.vpc.vpc_dc_pan_subnets[0]
      app_subnet_id      = module.vpc.vpc_prv_subnet_a
      db_subnet_id       = module.vpc.vpc_db_prv_subnet_ids[0]
      sub1_subnet_id       = module.vpc.vpc_dc_private_subnets[4]
      app_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[0], module.vpc.vpc_dc_private_route_table_ids[2], module.vpc.vpc_dc_db_route_table_ids[0], module.vpc.vpc_dc_db_route_table_ids[1], module.vpc.vpc_dc_private_route_table_ids[1], module.vpc.vpc_dc_private_route_table_ids[3], module.vpc.vpc_dc_private_route_table_ids[4], module.vpc.vpc_dc_private_route_table_ids[5]]
      sub1_route_table_id = [module.vpc.vpc_dc_private_route_table_ids[4]]
      sequence           = "a"
    }
  }
}

