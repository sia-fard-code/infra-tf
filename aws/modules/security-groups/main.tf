resource "aws_security_group" "internal" {
  name        = "${var.env}-MasimoSafetyNet-internal"
  description = "MasimoSafetyNet ${var.env} internal security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-internal"
  }
}

resource "aws_security_group_rule" "alb_internal_ssh" {
  security_group_id = aws_security_group.internal.id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}

resource "aws_security_group_rule" "alb_allowed_cidr_egress" {
  security_group_id = aws_security_group.internal.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}


resource "aws_security_group" "alb_bastion" {
  name        = "${var.env}-MasimoSafetyNet-bastion-alb"
  description = "MasimoSafetyNet ${var.env} bastion alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-bastion-alb"
  }
}

resource "aws_security_group_rule" "alb_bastion_ssh" {
  security_group_id = aws_security_group.alb_bastion.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["50.59.0.128/25", "52.25.47.70/32", "64.222.252.131/32", "64.58.153.2/32"]
  description = "SSH"
}

resource "aws_security_group_rule" "alb_bastion_egress" {
  security_group_id = aws_security_group.alb_bastion.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}



resource "aws_security_group" "alb_web" {
  name        = "${var.env}-MasimoSafetyNet-web-alb"
  description = "MasimoSafetyNet ${var.env} web alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-web-alb"
  }
}

resource "aws_security_group_rule" "alb_web_https" {
  security_group_id = aws_security_group.alb_web.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_web" {
  security_group_id = aws_security_group.alb_web.id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_web_http" {
  security_group_id = aws_security_group.alb_web.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_web_egress" {
  security_group_id = aws_security_group.alb_web.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group" "alb_api" {
  name        = "${var.env}-MasimoSafetyNet-api-alb"
  description = "MasimoSafetyNet ${var.env} api alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-api-alb"
  }
}

resource "aws_security_group_rule" "alb_api_https" {
  security_group_id = aws_security_group.alb_api.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_api" {
  security_group_id = aws_security_group.alb_api.id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_api_http" {
  security_group_id = aws_security_group.alb_api.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_api_egress" {
  security_group_id = aws_security_group.alb_api.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group" "db" {
  name        = "${var.env}-MSN-MongoDB"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.allowed_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-mongo"
  }
}
/*
resource "aws_security_group" "wide_open" {
  name        = "sgWideOpen"
  description = "Wide open security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-WideOpen"
  }
}
*/
resource "aws_security_group" "pan" {
  count      = contains(var.pan_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MasimoSafetyNet-pan"
  description = "MasimoSafetyNet ${var.env} pan security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-pan"
  }
}

resource "aws_security_group_rule" "pan_https" {
  count      = contains(var.pan_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.pan[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["64.58.153.0/24","50.59.0.128/25"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "pan_ssh" {
  count      = contains(var.pan_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.pan[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["64.58.153.0/24", "50.59.0.128/25"]
  description = "PAN SSH"
}


resource "aws_security_group_rule" "pan_egress" {
  count      = contains(var.pan_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.pan[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group" "alb_admin" {
  name        = "${var.env}-MasimoSafetyNet-admin-alb"
  description = "MasimoSafetyNet ${var.env} admin alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-admin-app-alb"
  }
}

resource "aws_security_group_rule" "alb_admin_https" {
  security_group_id = aws_security_group.alb_admin.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_admin" {
  security_group_id = aws_security_group.alb_admin.id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_admin_http" {
  security_group_id = aws_security_group.alb_admin.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_admin_egress" {
  security_group_id = aws_security_group.alb_admin.id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== RISK SG =================
resource "aws_security_group" "alb_risk" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-risk-alb"
  description = "MasimoSafetyNet ${var.env} risk alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-risk-service-alb"
  }
}

resource "aws_security_group_rule" "alb_risk_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_risk[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_risk" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_risk[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_risk_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_risk[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_risk_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_risk[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}


####===================================== streaming SG =================
resource "aws_security_group" "alb_streaming" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-streaming-alb"
  description = "MasimoSafetyNet ${var.env} streaming alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-streaming-service-alb"
  }
}

resource "aws_security_group_rule" "alb_streaming_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_streaming[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_streaming" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_streaming[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_streaming_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_streaming[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_streaming_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_streaming[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== gateway SG =================
resource "aws_security_group" "alb_gateway" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-gateway-alb"
  description = "MasimoSafetyNet ${var.env} gateway alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-gateway-alb"
  }
}

resource "aws_security_group_rule" "alb_gateway_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_gateway[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_gateway" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_gateway[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_gateway_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_gateway[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_gateway_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_gateway[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== activity SG =================
resource "aws_security_group" "alb_activity" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-activity-alb"
  description = "MasimoSafetyNet ${var.env} activity alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-activity-service-alb"
  }
}

resource "aws_security_group_rule" "alb_activity_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_activity[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_activity" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_activity[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_activity_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_activity[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_activity_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_activity[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== open-rest SG =================
resource "aws_security_group" "alb_open_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-open-rest-alb"
  description = "MasimoSafetyNet ${var.env} open-rest alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-open-rest-alb"
  }
}

resource "aws_security_group_rule" "alb_open_rest_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_open_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_rest[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_rest_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_open_rest_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_rest[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== status-scheduler SG =================
resource "aws_security_group" "alb_status_scheduler" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-status-scheduler-alb"
  description = "MasimoSafetyNet ${var.env} status-scheduler alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-status-scheduler-alb"
  }
}

resource "aws_security_group_rule" "alb_status_scheduler_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_status_scheduler[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_status_scheduler" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_status_scheduler[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_status_scheduler" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_status_scheduler[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_status_scheduler_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_status_scheduler[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== open-api SG =================
resource "aws_security_group" "alb_open_api" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-open-api-alb"
  description = "MasimoSafetyNet ${var.env} open-api alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-open-api-alb"
  }
}

resource "aws_security_group_rule" "alb_open_api_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_api[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_open_api" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_api[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_api_http" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_api[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_open_api_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_open_api[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== system-event SG =================
resource "aws_security_group" "alb_system_events_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-system-events-rest-alb"
  description = "MasimoSafetyNet ${var.env} system_events_rest alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-system-events-rest-alb"
  }
}

resource "aws_security_group_rule" "alb_system_events_rest_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_system_events_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_rest[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_system_events_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_system_events_rest_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_rest[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== external_integration SG =================
resource "aws_security_group" "alb_external_integration" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-external-integration-alb"
  description = "MasimoSafetyNet ${var.env} external_integration alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-external-integration-alb"
  }
}

resource "aws_security_group_rule" "alb_external_integration_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_external_integration[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_external_integration" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_external_integration[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_external_integration" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_external_integration[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_external_integration_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_external_integration[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}



####===================================== vitals-rest SG =================
resource "aws_security_group" "alb_vitals_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-vitals-rest-alb"
  description = "MasimoSafetyNet ${var.env} vitals-rest alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-vitals-rest-alb"
  }
}

resource "aws_security_group_rule" "alb_vitals_rest_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_vitals_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_rest[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_vitals_rest" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_rest[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_vitals_rest_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_rest[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== system-events-consumer SG =================
resource "aws_security_group" "alb_system_events_consumer" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-system-events-consumer-alb"
  description = "MasimoSafetyNet ${var.env} system-events-consumer alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-system-events-consumer-alb"
  }
}

resource "aws_security_group_rule" "alb_system_events_consumer_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_consumer[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_system_events_consumer" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_consumer[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_system_events_consumer" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_consumer[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_system_events_consumer_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_system_events_consumer[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== vitals_data_capture SG =================
resource "aws_security_group" "alb_vitals_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-vitals-data-capture-alb"
  description = "MasimoSafetyNet ${var.env} vitals-data-capture alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-vitals-data-capture-alb"
  }
}

resource "aws_security_group_rule" "alb_vitals_data_capture_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_data_capture[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_vitals_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_data_capture[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_vitals_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_data_capture[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_vitals_data_capture_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_vitals_data_capture[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== alb_legacy_data_capture SG =================
resource "aws_security_group" "alb_legacy_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-legacy-data-capture-alb"
  description = "MasimoSafetyNet ${var.env} legacy-data-capture alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-legacy-data-capture-alb"
  }
}

resource "aws_security_group_rule" "alb_legacy_data_capture_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_legacy_data_capture[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_legacy_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_legacy_data_capture[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_legacy_data_capture" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_legacy_data_capture[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_legacy_data_capture_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_legacy_data_capture[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== hifi_download SG =================
resource "aws_security_group" "alb_hifi_download" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  name        = "${var.env}-MSN-hifi-download-alb"
  description = "MasimoSafetyNet ${var.env} hifi-download alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-hifi-download-alb"
  }
}

resource "aws_security_group_rule" "alb_hifi_download_https" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_hifi_download[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_hifi_download" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_hifi_download[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_hifi_download" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_hifi_download[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_hifi_download_egress" {
  count      = contains(var.msn_open_env, terraform.workspace)? 1 : 0
  security_group_id = aws_security_group.alb_hifi_download[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== telehealth SG =================
resource "aws_security_group" "alb_telehealth_service" {
  count      = var.msn_th_enabled? 1 : 0
  name        = "${var.env}-MSN-telehealth-service-alb"
  description = "MasimoSafetyNet ${var.env} telehealth-service alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-telehealth-service-alb"
  }
}

resource "aws_security_group_rule" "alb_telehealth_service_https" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_telehealth_service[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_telehealth_service" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_telehealth_service[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_telehealth_service" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_telehealth_service[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_telehealth_service_egress" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_telehealth_service[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== patient_settings SG =================
resource "aws_security_group" "alb_patient_settings" {
  count      = var.msn_th_enabled? 1 : 0
  name        = "${var.env}-MSN-patient-settings-alb"
  description = "MasimoSafetyNet ${var.env} patient-settings alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-patient-settings-alb"
  }
}

resource "aws_security_group_rule" "alb_patient_settings_https" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_patient_settings[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_patient_settings" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_patient_settings[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_patient_settings" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_patient_settings[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_patient_settings_egress" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_patient_settings[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

####===================================== notification_service SG =================
resource "aws_security_group" "alb_notification_service" {
  count      = var.msn_th_enabled? 1 : 0
  name        = "${var.env}-MSN-notification-service-alb"
  description = "MasimoSafetyNet ${var.env} notification-service alb security group"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-notification-service-alb"
  }
}

resource "aws_security_group_rule" "alb_notification_service_https" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_notification_service[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

resource "aws_security_group_rule" "alb_internal_notification_service" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_notification_service[count.index].id

  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = var.allowed_cidr
  description = "internal"
}


resource "aws_security_group_rule" "alb_open_notification_service" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_notification_service[count.index].id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}


resource "aws_security_group_rule" "alb_notification_service_egress" {
  count      = var.msn_th_enabled? 1 : 0
  security_group_id = aws_security_group.alb_notification_service[count.index].id

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

