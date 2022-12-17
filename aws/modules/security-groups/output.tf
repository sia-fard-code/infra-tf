output "alb_bastion_sg_id" {
  value = aws_security_group.alb_bastion.id
}
output "internal_sg_id" {
  value = aws_security_group.internal.id
}


output "alb_web_sg_id" {
  value = aws_security_group.alb_web.id
}
output "alb_api_sg_id" {
  value = aws_security_group.alb_api.id
}
output "alb_admin_sg_id" {
  value = aws_security_group.alb_admin.id
}

output "alb_admin_sg_name" {
  value = aws_security_group.alb_admin.name
}
output "alb_risk_sg_id" {
  value = var.msn_open_enabled ? aws_security_group.alb_risk[0].id : ""
}

output "alb_risk_sg_name" {
  value = var.msn_open_enabled ? aws_security_group.alb_risk[0].name : ""
}
output "alb_open_rest_sg_id" {
  value = var.msn_open_enabled ? aws_security_group.alb_open_rest[0].id : ""
}

output "alb_open_rest_sg_name" {
  value = var.msn_open_enabled ? aws_security_group.alb_open_rest[0].name : ""
}

output "alb_open_api_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_open_api[0].id : ""
}

output "alb_open_api_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_open_api[0].name : ""
}

output "alb_streaming_sg_id" {
  value = var.msn_open_enabled ? aws_security_group.alb_streaming[0].id : ""
}

output "alb_streaming_sg_name" {
  value = var.msn_open_enabled ? aws_security_group.alb_streaming[0].name : ""
}
output "alb_gateway_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_gateway[0].id : ""
}

output "alb_gateway_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_gateway[0].name : ""
}
output "alb_activity_sg_id" {
  value = var.msn_open_enabled ? aws_security_group.alb_activity[0].id : ""
}

output "alb_activity_sg_name" {
  value = var.msn_open_enabled ? aws_security_group.alb_activity[0].name : ""
}

output "alb_status_scheduler_sg_id" {
  value = var.msn_open_enabled ? aws_security_group.alb_status_scheduler[0].id : ""
}

output "alb_status_scheduler_sg_name" {
  value = var.msn_open_enabled ? aws_security_group.alb_status_scheduler[0].name : ""
}
output "alb_system_events_rest_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_system_events_rest[0].id : ""
}

output "alb_system_events_rest_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_system_events_rest[0].name : ""
}
output "alb_external_integration_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_external_integration[0].id : ""
}

output "alb_external_integration_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_external_integration[0].name : ""
}


output "alb_vitals_rest_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_vitals_rest[0].id : ""
}

output "alb_vitals_rest_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_vitals_rest[0].name : ""
}

output "alb_vitals_data_capture_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_vitals_data_capture[0].id : ""
}

output "alb_vitals_data_capture_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_vitals_data_capture[0].name : ""
}

output "alb_system_events_consumer_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_system_events_consumer[0].id : ""
}

output "alb_system_events_consumer_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_system_events_consumer[0].name : ""
}

output "alb_legacy_data_capture_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_legacy_data_capture[0].id : ""
}

output "alb_legacy_data_capture_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_legacy_data_capture[0].name : ""
}

output "alb_hifi_download_sg_id" {
  value = var.msn_svc_enabled ? aws_security_group.alb_hifi_download[0].id : ""
}

output "alb_hifi_download_sg_name" {
  value = var.msn_svc_enabled ? aws_security_group.alb_hifi_download[0].name : ""
}

output "alb_telehealth_service_sg_id" {
  value = var.msn_th_enabled ? aws_security_group.alb_telehealth_service[0].id : ""
}

output "alb_telehealth_service_sg_name" {
  value = var.msn_th_enabled ? aws_security_group.alb_telehealth_service[0].name : ""
}

output "alb_patient_settings_sg_id" {
  value = var.msn_th_enabled ? aws_security_group.alb_patient_settings[0].id : ""
}

output "alb_patient_settings_sg_name" {
  value = var.msn_th_enabled ? aws_security_group.alb_patient_settings[0].name : ""
}
output "alb_notification_service_sg_id" {
  value = var.msn_th_enabled ? aws_security_group.alb_notification_service[0].id : ""
}

output "alb_notification_service_sg_name" {
  value = var.msn_th_enabled ? aws_security_group.alb_notification_service[0].name : ""
}
output "alb_web_sg_name" {
  value = aws_security_group.alb_web.name
}
output "alb_api_sg_name" {
  value = aws_security_group.alb_api.name
}

output "db_sg_id" {
  value = aws_security_group.db.id
}
/*
output "wide_sg_id" {
  value = aws_security_group.wide_open.id
}
*/
output "pan_sg_id" {
  value = aws_security_group.pan.*.id
}
