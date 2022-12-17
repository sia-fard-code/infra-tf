output "tg_web_arn" {
  value = !var.common_enabled ? aws_lb_target_group.web[0].arn : ""
}
output "tg_admin_arn" {
  value = !var.common_enabled ? aws_lb_target_group.admin[0].arn : ""
}

output "tg_api_arn_pub" {
  value = !var.common_enabled ? aws_lb_target_group.api_pub[0].arn : ""
}
output "tg_api_arn_prv" {
  value = !var.common_enabled ? aws_lb_target_group.api_prv[0].arn : ""
}

output "web_dns_name" {
  value = !var.common_enabled ? aws_lb.web[0].dns_name : ""
}
output "web_zone_id" {
  value = !var.common_enabled ? aws_lb.web[0].zone_id :""
}
output "api_dns_name_pub" {
  value = !var.common_enabled ? aws_lb.api_pub[0].dns_name : ""
}
output "api_zone_id_pub" {
  value = !var.common_enabled ? aws_lb.api_pub[0].zone_id : ""
}
output "api_dns_name_prv" {
  value = var.common_enabled ? aws_lb.api_prv[0].dns_name : ""
}
output "api_zone_id_prv" {
  value = var.common_enabled ? aws_lb.api_prv[0].zone_id : ""
}

output "db_dns_name_prv" {
  value = var.common_enabled && terraform.workspace != "PROD-US" ? aws_lb.mongo[0].dns_name : ""
}
output "db_zone_id_prv" {
  value = var.common_enabled && terraform.workspace != "PROD-US" ? aws_lb.mongo[0].zone_id : ""
}
output "admin_dns_name" {
  value = !var.common_enabled ? aws_lb.admin[0].dns_name : ""
}
output "admin_zone_id" {
  value = !var.common_enabled ? aws_lb.admin[0].zone_id : ""
}


output "tg_risk_arn" {
  value = !var.common_enabled && var.msn_open_enabled ? aws_lb_target_group.risk[0].arn : ""
}
output "tg_activity_arn" {
  value = !var.common_enabled && var.msn_open_enabled ? aws_lb_target_group.activity[0].arn : ""
}

output "tg_system_events_rest_arn" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb_target_group.system_events_rest[0].arn : ""
}

output "tg_vitals_rest_arn" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb_target_group.vitals_rest[0].arn : ""
}

output "tg_external_integration_arn" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb_target_group.external_integration[0].arn : ""
}

output "tg_streaming_arn" {
  value = !var.common_enabled && var.msn_open_enabled ? aws_lb_target_group.streaming[0].arn : ""
}

output "gateway_dns_name" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb.gateway[0].dns_name : ""
}
output "gateway_zone_id" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb.gateway[0].zone_id : ""
}
output "tg_gateway_arn" {
  value = !var.common_enabled && var.msn_svc_enabled ? aws_lb_target_group.gateway[0].arn : ""
}

output "tg_telehealth_service_arn" {
  value = !var.common_enabled && var.msn_th_enabled ? aws_lb_target_group.telehealth_service[0].arn : ""
}

output "tg_patient_settings_arn" {
  value = !var.common_enabled && var.msn_th_enabled ? aws_lb_target_group.patient_settings[0].arn : ""
}

output "tg_notification_service_arn" {
  value = !var.common_enabled && var.msn_th_enabled ? aws_lb_target_group.notification_service[0].arn : ""
}
output "open_api_dns_name" {
  value = (var.msn_svc_enabled || var.msn_open_enabled)  && var.common_enabled ? aws_lb.open_api_prv[0].dns_name : ""
}
output "open_api_zone_id" {
  value = (var.msn_svc_enabled || var.msn_open_enabled) && var.common_enabled ? aws_lb.open_api_prv[0].zone_id : ""
}

output "tg_open_rest_arn" {
  value = !var.common_enabled && (var.msn_svc_enabled || var.msn_open_enabled) ? aws_lb_target_group.open_rest[0].arn : ""
}

output "open_api_https_prv_arn" {
  value = var.common_enabled && (var.msn_svc_enabled || var.msn_open_enabled) ? aws_lb_listener.open_api_https_prv[0].arn : ""
}

output "api_https_prv_arn" {
  value = var.common_enabled ? aws_lb_listener.api_https_prv[0].arn : ""
}
