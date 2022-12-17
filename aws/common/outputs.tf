// ------------------------ VPC outputs ---------------------

output "vpc_dc_private_subnets" {
  value = module.vpc.vpc_dc_private_subnets
}
output "vpc_dc_private_subnets_blue" {
  value = module.vpc.vpc_dc_private_subnets_blue
}
output "vpc_dc_private_subnets_green" {
  value = module.vpc.vpc_dc_private_subnets_green
}


output "vpc_dc_public_subnets" {
  value = module.vpc.vpc_dc_public_subnets
}
output "vpc_dc_pan_subnets" {
  value = module.vpc.vpc_dc_pan_subnets
}

output "vpc_dc_id" {
  value = module.vpc.vpc_dc_id
}
output "vpc_prv_subnet_a" {
  value = module.vpc.vpc_prv_subnet_a
}

output "vpc_prv_subnet_b" {
  value = module.vpc.vpc_prv_subnet_b
}

output "vpc_db_prv_subnet_ids" {
  value = module.vpc.vpc_db_prv_subnet_ids
}

output "vpc_db_prv_subnet_cidr_blocks" {
  value = module.vpc.vpc_db_prv_subnet_cidr_blocks
}
output "vpc_prv_subnet_cidr_blue" {
  value = module.vpc.vpc_prv_subnet_cidr_blue
}
output "vpc_prv_subnet_cidr_green" {
  value = module.vpc.vpc_prv_subnet_cidr_green
}

output "vpc_dc_private_route_table_ids" {
  value = module.vpc.vpc_dc_private_route_table_ids
}

output "vpc_dc_db_route_table_ids" {
  value = module.vpc.vpc_dc_db_route_table_ids
//  value = aws_route_table.db_zone2.*.id
}

output "kms_key_arn" {
  value = module.kms_key.key_arn
}

output "prv_dns_zone_id" {
  value = module.variables.dns_zone_ids
}

// ------------------------ IAM outputs ---------------------

output "iam_api_kms_arn" {
  value = module.iam.api_kms_arn
}
output "iam_web_kms_arn" {
  value = module.iam.web_kms_arn
}
output "iam_admin_kms_arn" {
  value = module.iam.admin_kms_arn
}
output "iam_msn_open_kms_arn" {
  value = module.iam.msn_open_kms_arn
}
output "iam_msn_svc_kms_arn" {
  value = module.iam.msn_svc_kms_arn
}

// ---------------------------------------------------------------
output "acm_certificate_arn" {
//    value = data.aws_acm_certificate.cert.arn
//    value = terraform.workspace == "PROD-US" ? data.aws_acm_certificate.cert[0].arn : module.external-certificate[0].acm_certificate_arn
    value = terraform.workspace == "PROD-US" ? data.aws_acm_certificate.cert[0].arn : module.external-certificate.acm_certificate_arn
}

output "app_server_key_name" {
    value = aws_key_pair.app_server.key_name
}

output "bastion_key_name" {
    value = aws_key_pair.bastion.key_name
}


// ------------------------ security group outputs ---------------------
output "alb_bastion_sg_id" {
  value = module.sg.alb_bastion_sg_id
}
output "internal_sg_id" {
  value = module.sg.internal_sg_id
}


output "alb_web_sg_id" {
  value = module.sg.alb_web_sg_id
}
output "alb_api_sg_id" {
  value = module.sg.alb_api_sg_id
}
output "alb_admin_sg_id" {
  value = module.sg.alb_admin_sg_id
}

output "alb_admin_sg_name" {
  value = module.sg.alb_admin_sg_name
}
output "alb_risk_sg_id" {
  value = module.sg.alb_risk_sg_id
}

output "alb_risk_sg_name" {
  value = module.sg.alb_risk_sg_name
}
output "alb_open_rest_sg_id" {
  value = module.sg.alb_open_rest_sg_id
}

output "alb_open_rest_sg_name" {
  value = module.sg.alb_open_rest_sg_name
}

output "alb_open_api_sg_id" {
  value = module.sg.alb_open_api_sg_id
}

output "alb_open_api_sg_name" {
  value = module.sg.alb_open_api_sg_name
}

output "alb_streaming_sg_id" {
  value = module.sg.alb_streaming_sg_id
}

output "alb_streaming_sg_name" {
  value = module.sg.alb_streaming_sg_name
}
output "alb_gateway_sg_id" {
  value = module.sg.alb_gateway_sg_id
}

output "alb_gateway_sg_name" {
  value = module.sg.alb_gateway_sg_name
}
output "alb_activity_sg_id" {
  value = module.sg.alb_activity_sg_id
}

output "alb_activity_sg_name" {
  value = module.sg.alb_activity_sg_name
}

output "alb_status_scheduler_sg_id" {
  value = module.sg.alb_status_scheduler_sg_id
}

output "alb_status_scheduler_sg_name" {
  value = module.sg.alb_status_scheduler_sg_name
}

output "alb_system_events_rest_sg_id" {
  value = module.sg.alb_system_events_rest_sg_id
}
output "alb_system_events_rest_sg_name" {
  value = module.sg.alb_system_events_rest_sg_name
}
output "alb_system_events_consumer_sg_id" {
  value = module.sg.alb_system_events_consumer_sg_id
}
output "alb_system_events_consumer_sg_name" {
  value = module.sg.alb_system_events_consumer_sg_name
}
output "alb_external_integration_sg_id" {
  value = module.sg.alb_external_integration_sg_id
}
output "alb_external_integration_sg_name" {
  value = module.sg.alb_external_integration_sg_name
}
output "alb_vitals_rest_sg_id" {
  value = module.sg.alb_vitals_rest_sg_id
}
output "alb_vitals_rest_sg_name" {
  value = module.sg.alb_vitals_rest_sg_name
}
output "alb_vitals_data_capture_sg_id" {
  value = module.sg.alb_vitals_data_capture_sg_id
}
output "alb_vitals_data_capture_sg_name" {
  value = module.sg.alb_vitals_data_capture_sg_name
}
output "alb_legacy_data_capture_sg_id" {
  value = module.sg.alb_legacy_data_capture_sg_id
}
output "alb_legacy_data_capture_sg_name" {
  value = module.sg.alb_legacy_data_capture_sg_name
}
output "alb_hifi_download_sg_id" {
  value = module.sg.alb_hifi_download_sg_id
}
output "alb_hifi_download_sg_name" {
  value = module.sg.alb_hifi_download_sg_name
}

output "alb_telehealth_service_sg_id" {
  value = module.sg.alb_telehealth_service_sg_id
}
output "alb_telehealth_service_sg_name" {
  value = module.sg.alb_telehealth_service_sg_name
}

output "alb_patient_settings_sg_id" {
  value = module.sg.alb_patient_settings_sg_id
}
output "alb_patient_settings_sg_name" {
  value = module.sg.alb_patient_settings_sg_name
}

output "alb_notification_service_sg_id" {
  value = module.sg.alb_notification_service_sg_id
}
output "alb_notification_service_sg_name" {
  value = module.sg.alb_notification_service_sg_name
}
output "alb_web_sg_name" {
  value = module.sg.alb_web_sg_name
}
output "alb_api_sg_name" {
  value = module.sg.alb_api_sg_name
}

output "db_sg_id" {
  value = module.sg.db_sg_id
}

output "pan_sg_id" {
  value = module.sg.pan_sg_id
}

// ------------------------ ALB outputs ---------------------

output "open_api_https_prv_arn" {
  value = module.alb_common[0].open_api_https_prv_arn 
}

output "api_https_prv_arn" {
  value = module.alb_common[0].api_https_prv_arn 
}

