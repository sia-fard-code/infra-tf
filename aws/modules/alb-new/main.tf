
#======================================== Target Groups ===================
resource "aws_lb_target_group" "web" {
  count    = var.common_enabled ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-WEB"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/health"
    protocol = "HTTPS"
    matcher  = "200"
  }
}

resource "aws_lb_target_group" "api_pub" {
  count    = var.common_enabled ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-API-PUB"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/health"
    protocol = "HTTPS"
    matcher  = "200"
  }

}

resource "aws_lb_target_group" "api_prv" {
  count    = var.common_enabled ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-API-PRV"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/health"
    protocol = "HTTPS"
    matcher  = "200"
  }

}

resource "aws_lb_target_group" "admin" {
  count    = var.common_enabled ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-ADMIN-APP"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "risk" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-risk"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}
resource "aws_lb_target_group" "open_rest" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-open-rest"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}
resource "aws_lb_target_group" "activity" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-activity"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "gateway" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-gateway"
  port     = 9000
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "streaming" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-streaming"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "system_events_rest" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-system-events-rest"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "vitals_rest" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-vitals-rest"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "external_integration" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-ext-integration"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}


resource "aws_lb_target_group" "telehealth_service" {
  count    = var.msn_th_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-telehealth-service"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "patient_settings" {
  count    = var.msn_th_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-patient-settings"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}

resource "aws_lb_target_group" "notification_service" {
  count    = var.msn_th_enabled && !var.common_enabled ? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-notification-service"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    interval = 15
    path     = "/actuator/health"
    protocol = "HTTPS"
    matcher  = "200,400"
  }
}


resource "aws_lb_target_group" "mongo" {
  count    =  var.common_enabled && terraform.workspace != "PROD-US" ? 1 : 0 
  name     = "${var.env}-MONGO"
  port     = 27017
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    interval = 10
    protocol = "TCP"
  }
}


#======================================== WEB ALB ===================
resource "aws_lb" "web" {
  count              = var.common_enabled  ? 0 : length(var.type)
  name               = "${var.env}-${var.type[count.index]}-WEB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_web_sg_ids
  subnets            = var.web_subnets
  tags = {
    TYPE = var.type[count.index]
    service-name = "web"
    internal = "false"
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "web_http" {
  count              = var.common_enabled  ? 0 : length(var.type)
  load_balancer_arn = aws_lb.web[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "web_https" {
  count              = var.common_enabled  ? 0 : length(var.type)
  load_balancer_arn = aws_lb.web[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web[count.index].arn
  }
}


#===================================== API ALB PUB =========================

resource "aws_lb" "api_pub" {
  count              = var.common_enabled  ? 0 : length(var.type)
  name               = "${var.env}-${var.type[count.index]}-API-PUB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_api_sg_ids
  subnets            = var.api_subnets
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }
  tags = {
    TYPE = var.type[count.index]
    service-name = "api"
    internal = "false"
  }
}

resource "aws_lb_listener" "api_http_pub" {
  count              = var.common_enabled  ? 0 : length(var.type)
  load_balancer_arn = aws_lb.api_pub[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "api_https_pub" {
  count              = var.common_enabled  ? 0 : length(var.type)
  load_balancer_arn = aws_lb.api_pub[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_pub[count.index].arn
  }
}


#===================================== API ALB PRV =========================

resource "aws_lb" "api_prv" {
  count              = var.common_enabled ? 1 : 0
  name               = "${var.env}-API-PRV"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.alb_api_sg_ids
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }
  tags = {
    service-name = "api"
    internal = "true"
  }

  subnets = var.api_subnets
}

resource "aws_lb_listener" "api_http_prv" {
  count              = var.common_enabled ? 1 : 0
  load_balancer_arn = aws_lb.api_prv[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "8443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "api_https_prv" {
  count             = var.common_enabled ? 1 : 0
  load_balancer_arn = aws_lb.api_prv[count.index].arn
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Wrong Routing"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "static" {
  count        = var.common_enabled ? 0 : length(var.type)
  listener_arn = var.api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_prv[count.index].arn
  }

  condition {
    source_ip {
      //      values = [var.vpc_prv_subnet_cidr_blocks[2 * count.index], var.vpc_prv_subnet_cidr_blocks[2 * count.index + 1]]
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

#======================================== ADMIN ALB ===================
resource "aws_lb" "admin" {
  count              = var.common_enabled ? 0 : length(var.type)
  name               = "${var.env}-${var.type[count.index]}-ADMIN-APP"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_admin_sg_ids
  subnets            = var.admin_subnets
  tags = {
    TYPE = var.type[count.index]
    service-name = "admin"
    internal = "false"
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "admin_http" {
  count             = var.common_enabled ? 0 : length(var.type)
  load_balancer_arn = aws_lb.admin[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "admin_https" {
  count             = var.common_enabled ? 0 : length(var.type)
  load_balancer_arn = aws_lb.admin[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin[count.index].arn
  }
}


#===================================== OPEN API ALB PRV =========================

resource "aws_lb" "open_api_prv" {
  count    = (var.msn_svc_enabled || var.msn_open_enabled)  && var.common_enabled ? 1 : 0
  name               = "${var.env}-OPEN-API-PRV"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.alb_open_api_sg_ids
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }
  tags = {
    service-name = "open-api"
    internal = "true"
  }


  subnets = var.open_api_subnets
}

resource "aws_lb_listener" "open_api_http_prv" {
  count    = (var.msn_svc_enabled || var.msn_open_enabled) && var.common_enabled ? 1 : 0
  load_balancer_arn = aws_lb.open_api_prv[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "8443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "open_api_https_prv" {
  count    = (var.msn_svc_enabled || var.msn_open_enabled) && var.common_enabled ? 1 : 0
  load_balancer_arn = aws_lb.open_api_prv[count.index].arn
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Wrong Routing"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "activity" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.activity[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/activity/api/*"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

resource "aws_lb_listener_rule" "system_events_rest" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.system_events_rest[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/api/mobile/v1/system/events"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

resource "aws_lb_listener_rule" "vitals_rest" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vitals_rest[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/api/mobile/v1/data/hds"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

resource "aws_lb_listener_rule" "external_integration" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_integration[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/api/v1/integration/*", "*/api/v1/site/*"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

resource "aws_lb_listener_rule" "open_rest" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.open_rest[count.index].arn
  }
  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }

  condition {
    path_pattern {
      values = ["*/msn/api/*"]
    }
  }
}

resource "aws_lb_listener_rule" "risk" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.risk[count.index].arn
  }
  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }

  condition {
    path_pattern {
      values = ["*/open/api/*","*/open/mobile/api/*"]
    }
  }
}

resource "aws_lb_listener_rule" "patient_settings" {
  count    = var.msn_th_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient_settings[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/api/mobile/patient/settings/v1/*"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

resource "aws_lb_listener_rule" "telehealth_service" {
  count    = var.msn_th_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = var.open_api_https_prv_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.telehealth_service[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/api/telehealth/v1/*", "*/api/mobile/telehealth/v1/*", "*/api/v1/org/*"]
    }
  }

  condition {
    source_ip {
      values = lookup(var.vpc_prv_subnet_cidr_blocks, var.type[count.index])
    }
  }
}

#======================================== gateway ALB ===================
resource "aws_lb" "gateway" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  name               = "${var.env}-${var.type[count.index]}-gateway"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_gateway_sg_ids
  subnets            = var.gateway_subnets
  tags = {
    TYPE = var.type[count.index]
    service-name = "gateway"
    internal = "false"
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "gateway_http" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  load_balancer_arn = aws_lb.gateway[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "gateway_https" {
  count    = var.msn_svc_enabled && !var.common_enabled ? length(var.type) : 0
  load_balancer_arn = aws_lb.gateway[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gateway[count.index].arn
  }
}

resource "aws_lb_listener_rule" "streaming" {
  count    = var.msn_open_enabled && !var.common_enabled ? length(var.type) : 0
  listener_arn = aws_lb_listener.gateway_https[count.index].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.streaming[count.index].arn
  }

  condition {
    path_pattern {
      values = ["*/msn/ws/*"]
    }
  }
}


#======================================== MONGODB NLB ===================
resource "aws_lb" "mongo" {
  name               = "${var.env}-MONGO"
  count              = var.common_enabled && terraform.workspace != "PROD-US" ? 1 : 0
  internal           = true
  load_balancer_type = "network"
  subnets            = var.db_subnets
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

  tags = {
    APP = "mongodb"
    service-name = "mongo"
    internal = "true"
  }
}

resource "aws_lb_listener" "mongo" {
  count              = var.common_enabled && terraform.workspace != "PROD-US" ? 1 : 0
  load_balancer_arn = aws_lb.mongo[count.index].arn
  port              = "27017"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mongo[count.index].arn
  }
}


