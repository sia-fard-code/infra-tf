output "api_kms_arn" {
  value = aws_iam_instance_profile.api_kms.arn
}
output "web_kms_arn" {
  value = aws_iam_instance_profile.web_kms.arn
}
output "admin_kms_arn" {
  value = aws_iam_instance_profile.admin_kms.arn
}
output "msn_open_kms_arn" {
  value = var.msn_open_enabled ? aws_iam_instance_profile.msn_open_kms[0].arn : ""
}

output "msn_svc_kms_arn" {
  value = var.msn_svc_enabled ? aws_iam_instance_profile.msn_services_kms[0].arn : ""
}
