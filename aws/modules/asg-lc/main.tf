resource "aws_security_group" "asg" {
  name   = var.name
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr
  ipv6_cidr_blocks  = var.allowed_ipv6_cidr
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "ssh_sg_ingress" {
  count                    = length(var.allowed_security_groups)
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.asg.id
}
resource "aws_security_group_rule" "https_ingress" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr
  ipv6_cidr_blocks  = var.allowed_ipv6_cidr
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "https_sg_ingress" {
  count                    = length(var.allowed_security_groups)
  type                     = "ingress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.asg.id
}


resource "aws_security_group_rule" "asg_all_egress" {
  type      = "egress"
  from_port = "0"
  to_port   = "65535"
  protocol  = "all"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  ipv6_cidr_blocks = [
    "::/0",
  ]

  security_group_id = aws_security_group.asg.id
}

data "template_file" "user_data" {
  template = file("${path.module}/${var.user_data_file}")

  vars = {
    additional_user_data_script = var.additional_user_data_script
  }
}

//resource "aws_instance" "asg" {
//  ami                    = "${var.ami}"
//  instance_type          = "${var.instance_type}"
//  iam_instance_profile   = "${var.iam_instance_profile}"
//  subnet_id              = "${var.subnet_id}"
//  vpc_security_group_ids = ["${aws_security_group.asg.id}"]
//  user_data              = "${template_file.user_data.rendered}"
//
//  count                  = 1
//
//  tags {
//    Name = "${var.name}"
//  }
//}

resource "aws_launch_configuration" "asg" {
  name_prefix       = "${var.name}-"
  image_id          = var.ami
  instance_type     = var.instance_type
  user_data         = data.template_file.user_data.rendered
  enable_monitoring = var.enable_monitoring

  security_groups = compact(
    concat(
      [aws_security_group.asg.id],
      split(",", var.security_group_ids),
    ),
  )

  root_block_device {
    volume_size = var.instance_volume_size_gb
  }

  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = var.apply_changes_immediately ? aws_launch_configuration.asg.name : var.name

  vpc_zone_identifier = var.subnet_ids

  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.asg.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = concat(
    [
      {
        key                 = "Name"
        value               = var.name
        propagate_at_launch = true
      },
    ],
    var.extra_tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

