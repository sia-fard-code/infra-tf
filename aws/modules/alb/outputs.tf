output "tg_db_arn" {
  value = aws_lb_target_group.mongo[*].arn
}
output "tg_web_arn" {
  value = aws_lb_target_group.web[*].arn
}
output "tg_admin_arn" {
  value = aws_lb_target_group.admin[*].arn
}

output "tg_api_arn_pub" {
  value = aws_lb_target_group.api_pub[*].arn
}
output "tg_api_arn_prv" {
  value = aws_lb_target_group.api_prv[*].arn
}

output "web_dns_name" {
  value = aws_lb.web[*].dns_name
}
output "web_zone_id" {
  value = aws_lb.web[*].zone_id
}
output "api_dns_name_pub" {
  value = aws_lb.api_pub[*].dns_name
}
output "api_zone_id_pub" {
  value = aws_lb.api_pub[*].zone_id
}
output "api_dns_name_prv" {
  value = aws_lb.api_prv[0].dns_name
}
output "api_zone_id_prv" {
  value = aws_lb.api_prv[0].zone_id
}

output "db_dns_name_prv" {
  value = aws_lb.mongo.dns_name
}
output "db_zone_id_prv" {
  value = aws_lb.mongo.zone_id
}
output "admin_dns_name" {
  value = aws_lb.admin[*].dns_name
}
output "admin_zone_id" {
  value = aws_lb.admin[*].zone_id
}


output "tg_risk_arn" {
  value = aws_lb_target_group.risk[*].arn
}
output "tg_activity_arn" {
  value = aws_lb_target_group.activity[*].arn
}


output "tg_streaming_arn" {
  value = aws_lb_target_group.streaming[*].arn
}

output "gateway_dns_name" {
  value = aws_lb.gateway[*].dns_name
}
output "gateway_zone_id" {
  value = aws_lb.gateway[*].zone_id
}
output "tg_gateway_arn" {
  value = aws_lb_target_group.gateway[*].arn
}

output "open_api_dns_name" {
  value = aws_lb.open_api_prv[*].dns_name
}
output "open_api_zone_id" {
  value = aws_lb.open_api_prv[*].zone_id
}

output "tg_open_rest_arn" {
  value = aws_lb_target_group.open_rest[*].arn
}

output "open_api_https_prv_arn" {
  value = contains(var.msn_open_env, terraform.workspace)? aws_lb_listener.open_api_https_prv[0].arn : ""
}

output "api_https_prv_arn" {
  value = aws_lb_listener.api_https_prv[0].arn
}
