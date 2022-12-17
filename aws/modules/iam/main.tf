resource "aws_iam_role" "api_kms" {
  name               = "${var.env}-api-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "api_kms" {
  name = "${var.env}-api-kms-msn"
  role = aws_iam_role.api_kms.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "ec2:AssociateAddress",
        "ec2:DescribeTags",
        "s3:List*",
        "s3:Get*",
        "kms:GenerateDataKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "api_kms" {
  name = "${var.env}-api-kms-msn"
  role = aws_iam_role.api_kms.name
}

##========================= WEB IAM ====================

resource "aws_iam_role" "web_kms" {
  name               = "${var.env}-web-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "web_kms" {
  name = "${var.env}-web-kms-msn"
  role = aws_iam_role.web_kms.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress",
        "ec2:DescribeTags",
        "s3:List*",
        "s3:Get*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "web_kms" {
  name = "${var.env}-web-kms-msn"
  role = aws_iam_role.web_kms.name
}

##========================= MSN_OPEN IAM ====================

resource "aws_iam_role" "msn_open_kms" {
  count      = var.msn_open_enabled ? 1 : 0
  name               = "${var.env}-msn-open-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "msn_open_kms" {
  count      = var.msn_open_enabled ? 1 : 0
  name = "${var.env}-msn-open-kms-msn"
  role = aws_iam_role.msn_open_kms[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "ec2:AssociateAddress",
        "ec2:DescribeTags",
        "s3:List*",
        "s3:Get*",
        "ssm:UpdateInstanceInformation",
        "kms:GenerateDataKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "msn_open_kms" {
  count      = var.msn_open_enabled ? 1 : 0
  name = "${var.env}-msn-open-kms-msn"
  role = aws_iam_role.msn_open_kms[count.index].name
}

##========================= ADMIN IAM ====================

resource "aws_iam_role" "admin_kms" {
  name               = "${var.env}-admin-app-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "admin_kms" {
  name = "${var.env}-admin-app-kms-msn"
  role = aws_iam_role.admin_kms.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "ec2:AssociateAddress",
        "ec2:DescribeTags",
        "s3:List*",
        "s3:Get*",
        "kms:GenerateDataKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "admin_kms" {
  name = "${var.env}-admin-app-kms-msn"
  role = aws_iam_role.admin_kms.name
}



##========================= DB IAM ====================

resource "aws_iam_role" "db_kms" {
  name               = "${var.env}-db-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "db_kms" {
  name = "${var.env}-db-kms-msn"
  role = aws_iam_role.db_kms.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
                "ssm:DescribeDocument",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ssmmessages:OpenControlChannel",
                "ssm:PutConfigurePackageResult",
                "ssm:ListInstanceAssociations",
                "ssm:GetParameter",
                "ssm:UpdateAssociationStatus",
                "ssm:GetManifest",
                "ec2:DescribeTags",
                "ec2messages:DeleteMessage",
                "ssm:UpdateInstanceInformation",
                "ec2messages:FailMessage",
                "ssmmessages:OpenDataChannel",
                "ssm:GetDocument",
                "ssm:PutComplianceItems",
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ec2messages:AcknowledgeMessage",
                "ssm:GetParameters",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssm:PutInventory",
                "ec2messages:SendReply",
                "ssm:ListAssociations",
                "ssm:UpdateInstanceAssociationStatus",
                "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "db_kms" {
  name = "${var.env}-db-kms-msn"
  role = aws_iam_role.db_kms.name
}


##========================= MSN_SVC IAM ====================

resource "aws_iam_role" "msn_services_kms" {
  count      = var.msn_svc_enabled ? 1 : 0
  name               = "${var.env}-msn-services-kms-msn"
  path               = "/"
  assume_role_policy = <<POLICY
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
POLICY
}
resource "aws_iam_role_policy" "msn_services_kms" {
  count      = var.msn_svc_enabled ? 1 : 0
  name = "${var.env}-msn-services-kms-msn"
  role = aws_iam_role.msn_services_kms[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "ec2:AssociateAddress",
        "s3:List*",
        "s3:Get*",
        "ec2:DescribeTags",
        "ssm:UpdateInstanceInformation",
        "kms:GenerateDataKey",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "msn_services_kms" {
  count      = var.msn_svc_enabled ? 1 : 0
  name = "${var.env}-msn-services-kms-msn"
  role = aws_iam_role.msn_services_kms[count.index].name
}
