### 2 buckets, 1 for each palo alto AZ
resource "aws_s3_bucket" "pan_buckets" {
  for_each  = var.plan
  bucket    = lower("${var.bucket_name}-${each.value.sequence}")
  acl       = "private"
  tags      = {
    Name = "${var.bucket_name}-${each.value.sequence}"
  }
}

### creating the folders structure

resource "aws_s3_bucket_object" "folders_config" {
  # for_each = contains(var.pan_env, terraform.workspace) ? toset(var.pan_folders) : []
  for_each     = var.plan
  bucket       = lower("${var.bucket_name}-${each.value.sequence}")
  key          = "config/"
  content_type = "application/x-directory"
}
resource "aws_s3_bucket_object" "folders_content" {
  for_each     = var.plan
  bucket       = lower("${var.bucket_name}-${each.value.sequence}")
  key          = "content/"
  content_type = "application/x-directory"
}
resource "aws_s3_bucket_object" "folders_license" {
  for_each     = var.plan
  bucket       = lower("${var.bucket_name}-${each.value.sequence}")
  key          = "license/"
  content_type = "application/x-directory"
}
resource "aws_s3_bucket_object" "folders_software" {
  for_each     = var.plan
  bucket       = lower("${var.bucket_name}-${each.value.sequence}")
  key          = "software/"
  content_type = "application/x-directory"
}

### creating the files
resource "aws_s3_bucket_object" "init_cfg" {
  for_each = var.plan
  bucket   = lower("${var.bucket_name}-${each.value.sequence}")
  key      = "config/init-cfg.txt"
  source   = "modules/pan/config/init-cfg.txt"
}

resource "aws_s3_bucket_object" "satellite_info" {
  for_each = var.plan
  bucket   = lower("${var.bucket_name}-${each.value.sequence}")
  key      = "config/satellite_info.xml"
  source   = "modules/pan/config/satellite_info.xml"
}

resource "aws_s3_bucket_object" "certificate_info" {
  for_each = var.plan
  bucket   = lower("${var.bucket_name}-${each.value.sequence}")
  key      = "config/certificate_info.xml"
  source   = "modules/pan/config/certificate_info.xml"
}

resource "aws_s3_bucket_object" "device_blacklist" {
  for_each = var.plan
  bucket   = lower("${var.bucket_name}-${each.value.sequence}")
  key      = "config/device_blacklist.xml"
  source   = "modules/pan/config/device_blacklist.xml"
}

resource "aws_iam_role" "pan" {
  # count = contains(var.pan_env, terraform.workspace) ? 1 : 0
  name  = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "PANRolePolicyS3" {
  for_each = var.plan
  name   = "PAN-role-policy-S3-${each.value.sequence}"
  role   = aws_iam_role.pan.id
  policy = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bucket_name}-${each.value.sequence}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bucket_name}-${each.value.sequence}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "pan" {
  # count = contains(var.pan_env, terraform.workspace) ? 1 : 0
  name = var.name
  role = aws_iam_role.pan.name
  path = "/"
}

resource "aws_eip" "management" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  vpc      = true
}

resource "aws_network_interface" "management" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  subnet_id         = each.value.mgt_subnet_id
  security_groups   = [var.pan_pub_sg]
  source_dest_check = false
  private_ips_count = 1
  description       = "PAN management network interface"
}

resource "aws_network_interface" "public" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  subnet_id         = each.value.pub_subnet_id
  security_groups   = [var.pan_prv_sg]
  source_dest_check = false
  private_ips_count = 1
  description       = "PAN outgoing network interface"

}

resource "aws_network_interface" "private_default" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  subnet_id         = each.value.app_subnet_id
  security_groups   = [var.pan_prv_sg]
  source_dest_check = false
  private_ips_count = 1
  description       = "PAN default network interface"
}

resource "aws_network_interface" "private_sub1" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  subnet_id         = each.value.sub1_subnet_id
  security_groups   = [var.pan_prv_sg]
  source_dest_check = false
  private_ips_count = 1
  description       = "PAN sub1 network interface"
}

resource "aws_eip_association" "management" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  depends_on = [
    aws_network_interface.private_default,
  ]
  network_interface_id = aws_network_interface.management[each.key].id
  allocation_id        = aws_eip.management[each.key].id
}

data "aws_subnet" "private_default" {
  for_each = var.plan
  id = each.value.app_subnet_id
}

resource "aws_s3_bucket_object" "bootstrap" {
  for_each = var.plan
  depends_on = [
    aws_network_interface.private_default,
  ]
  bucket   = lower("${var.bucket_name}-${each.value.sequence}")
  key      = "config/bootstrap.xml"
  # content   = templatefile("modules/pan/config/config.xml.tmpl", {hostname = "PAN-AWS-MSN-${var.region}-${each.value.sequence}", ip-address = cidrhost(data.aws_subnet.private_default[each.key].cidr_block,1), destination = var.vpc_cidr})
}

resource "aws_instance" "pan" {
  # for_each = contains(var.pan_env, terraform.workspace) ? var.plan : {}
  for_each = var.plan
  depends_on = [
    aws_s3_bucket_object.bootstrap,
  ]
  disable_api_termination              = false
  iam_instance_profile                 = aws_iam_instance_profile.pan.name
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = var.pan_fw_region_map[var.region]
  instance_type                        = var.instance_size
  user_data                            = <<EOF
    vmseries-bootstrap-aws-s3bucket=${lower("${var.bucket_name}-${each.value.sequence}")}
  EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  key_name   = var.server_key_name
  monitoring = true

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.management[each.key].id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.public[each.key].id
  }

 network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.private_sub1[each.key].id
  }

  network_interface {
    device_index         = 3
    network_interface_id = aws_network_interface.private_default[each.key].id
  }

  tags = {
    Name = "${var.name}-${each.value.sequence}"
    DataDog = "False"
  }
}

resource "aws_route" "pan_app_a" {
  # count                  = contains(var.pan_env, terraform.workspace) ? length(var.plan["pan_az1"].app_route_table_id) : 0
  count                  = length(var.plan["pan_az1"].app_route_table_id)
  route_table_id         = var.plan["pan_az1"].app_route_table_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_default["pan_az1"].id
}

resource "aws_route" "pan_app_b" {
  count                  = length(var.plan) > 1 ? length(var.plan["pan_az2"].app_route_table_id) : 0
#  count                  = length(var.plan["pan_az2"].app_route_table_id)
  route_table_id         = var.plan["pan_az2"].app_route_table_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_default["pan_az2"].id
}

resource "aws_route" "pan_sub1_a" {
  count                  = length(var.plan["pan_az1"].sub1_route_table_id)
  route_table_id         = var.plan["pan_az1"].sub1_route_table_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_sub1["pan_az1"].id
}

resource "aws_route" "pan_sub1_b" {
  count                  = length(var.plan) > 1 ? length(var.plan["pan_az2"].sub1_route_table_id) : 0
  route_table_id         = var.plan["pan_az2"].sub1_route_table_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_sub1["pan_az2"].id
}

