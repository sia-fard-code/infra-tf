resource "aws_launch_template" "lt" {
  count         = length(var.name)
  name          = var.name[count.index]
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }
  vpc_security_group_ids = var.vpc_security_group_ids
  //  security_group_names = var.security_group_names
  //  user_data = base64encode(var.user_data)
  lifecycle {
    ignore_changes = [
      tags, image_id, security_group_names, user_data, description, tag_specifications, iam_instance_profile,latest_version,
    ]
  }
}

data "aws_default_tags" "current" {}

resource "aws_autoscaling_group" "asg" {
  count = length(var.name)
  name  = var.name[count.index]

  vpc_zone_identifier = [var.subnet_ids[0], var.subnet_ids[1]]

  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_grace_period = "120"
  health_check_type         = "ELB"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_template {
    id      = aws_launch_template.lt[count.index].id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [
      desired_capacity, min_size, max_size, launch_template,target_group_arns, enabled_metrics
    ]
    create_before_destroy = true
  }
}

locals {
  arn_list = flatten([
    for type in keys(var.alb_target_group_arn) : [
      for arn in var.alb_target_group_arn[type] : {
        type = type
        arn  = arn
      }
    ]
  ])
}

resource "aws_autoscaling_attachment" "asg_attachment_web" {
  count                  = length(local.arn_list)
  autoscaling_group_name = aws_autoscaling_group.asg[local.arn_list[count.index].type].id
  alb_target_group_arn   = local.arn_list[count.index].arn
}
