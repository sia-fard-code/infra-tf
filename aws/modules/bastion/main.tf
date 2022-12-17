module "bastion" {
  source        = "github.com/terraform-community-modules/tf_aws_bastion_s3_keys"
  name          = var.name
  allowed_cidr  = var.allowed_cidr
  allowed_ipv6_cidr = []
  instance_type = var.instance_type
  ami           = var.ami
  region        = var.region
  //  iam_instance_profile        = aws_iam_instance_profile.s3_readonly_allow_associateaddress.name
  iam_instance_profile        = var.iam_instance_profile
  s3_bucket_name              = var.s3_bucket_name
  vpc_id                      = var.vpc_id
  subnet_ids                  = var.subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  ssh_user                    = var.ssh_user
  key_name                    = var.key_name
  eip                         = var.eip_ip
  additional_user_data_script = <<EOF
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
snap install aws-cli
aws ec2 associate-address --region $REGION --instance-id $INSTANCE_ID --allocation-id ${var.eip_id}
apt update
apt install npm -y
EOF


}


# This is just a sample definition of IAM instance profile which is allowed to read-only from S3, and associate ElasticIP addresses.
resource "aws_iam_instance_profile" "s3_readonly_allow_associateaddress" {
  name = "s3_readonly_allow_associateaddress_${var.env}"
  role = aws_iam_role.s3_readonly_allow_associateaddress.name
}

resource "aws_iam_role" "s3_readonly_allow_associateaddress" {
  name = "s3_readonly_allow_associateaddress_role_${var.env}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

resource "aws_iam_role_policy" "s3_readonly_allow_associateaddress_policy" {
  name = "s3_readonly_allow_associateaddress_policy_${var.env}"
  role = aws_iam_role.s3_readonly_allow_associateaddress.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1425916919000",
            "Effect": "Allow",
            "Action": [
                "ec2:AssociateAddress",
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
