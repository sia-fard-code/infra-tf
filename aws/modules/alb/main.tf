
#======================================== Target Groups ===================
resource "aws_lb_target_group" "web" {
  count    = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-MSN-WEB"
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
  count    = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-MSN-API-PUB"
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
  count    = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  name     = "${var.env}-${var.type[count.index]}-MSN-API-PRV"
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
  count    = length(var.type)
  name     = "${var.env}-${var.type[count.index]}-MSN-ADMIN-APP"
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-MSN-risk"
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-MSN-open-rest"
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-MSN-activity"
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-MSN-gateway"
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name     = "${var.env}-${var.type[count.index]}-MSN-streaming"
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
  name     = "${var.env}-MSN-MONGO"
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
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  name               = "${var.env}-${var.type[count.index]}-MSN-WEB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_web_sg_ids
  subnets            = var.web_subnets
  tags = {
    Env  = var.env
    TYPE = var.type[count.index]
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "web_http" {
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
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
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
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
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  name               = "${var.env}-${var.type[count.index]}-MSN-API-PUB"
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
    Env  = var.env
    TYPE = var.type[count.index]
  }
}

resource "aws_lb_listener" "api_http_pub" {
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
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
  count              = terraform.workspace == "PROD-US" ? 0 : length(var.type)
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
  count              = terraform.workspace == "PROD-US" ? 0 : 1
  name               = "${var.env}-MSN-API-PRV"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.alb_api_sg_ids
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

  subnets = var.api_subnets
}

resource "aws_lb_listener" "api_http_prv" {
  count              = terraform.workspace == "PROD-US" ? 0 : 1
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
  count              = terraform.workspace == "PROD-US" ? 0 : 1
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
  count        = terraform.workspace == "PROD-US" ? 0 : length(var.type)
  listener_arn = aws_lb_listener.api_https_prv[0].arn

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
  count              = length(var.type)
  name               = "${var.env}-${var.type[count.index]}-MSN-ADMIN-APP"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_admin_sg_ids
  subnets            = var.admin_subnets
  tags = {
    Env  = var.env
    TYPE = var.type[count.index]
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "admin_http" {
  count             = length(var.type)
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
  count             = length(var.type)
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
  count    = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name               = "${var.env}-MSN-OPEN-API-PRV"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.alb_open_api_sg_ids
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

  subnets = var.open_api_subnets
}

resource "aws_lb_listener" "open_api_http_prv" {
  count    = contains(var.msn_open_env, terraform.workspace)? 1 : 0
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
  count    = contains(var.msn_open_env, terraform.workspace)? 1 : 0
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  listener_arn = aws_lb_listener.open_api_https_prv[0].arn

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

resource "aws_lb_listener_rule" "open_rest" {
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  listener_arn = aws_lb_listener.open_api_https_prv[0].arn

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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  listener_arn = aws_lb_listener.open_api_https_prv[0].arn

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


#======================================== gateway ALB ===================
resource "aws_lb" "gateway" {
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
  name               = "${var.env}-${var.type[count.index]}-MSN-gateway"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_gateway_sg_ids
  subnets            = var.gateway_subnets
  tags = {
    Env  = var.env
    TYPE = var.type[count.index]
  }
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

}

resource "aws_lb_listener" "gateway_http" {
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
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
  count    = contains(var.msn_open_env, terraform.workspace)? length(var.type) : 0
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
  name               = "${var.env}-MSN-MONGO"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.db_subnets
  lifecycle {
    ignore_changes = [
      access_logs,
    ]
  }

  tags = {
    Env = var.env
    APP = "mongodb"
  }
}

resource "aws_lb_listener" "mongo" {
  count             = length(var.type)
  load_balancer_arn = aws_lb.mongo.arn
  port              = "27017"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mongo.arn
  }
}


