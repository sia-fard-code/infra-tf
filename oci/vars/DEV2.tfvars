zone_name_or_id = "dev2-masimosn.com"

web-domain = "*.dev2-masimosn.com"

api-domain  = "app.dev2-masimosn.com"

compartment_name = "DEV2"

compartment_description = "DEV2 comp"

dns_zone_name = "dev2-masimosn.com"

bastion_ip = "193.122.74.196"

COMMONVCNCIDR = "10.91.0.0/16"

BLUEVCNCIDR = "10.90.0.0/16"

GREENVCNCIDR = "10.92.0.0/16"
  
PublicCIDR = "0.0.0.0/0"

PrivateSubnetCIDR = "10.91.1.0/24"

PublicSubnetCIDR = "10.91.2.0/24" 

BLUEPrivateSubnetCIDR = "10.90.0.0/24"

BLUEPublicSubnetCIDR = "10.90.1.0/24" 

GREENPrivateSubnetCIDR = "10.92.2.0/24"

GREENPublicSubnetCIDR = "10.92.3.0/24" 


BastionCOMMONSubnetCIDRs = ["10.91.10.0/28", "10.91.10.16/28", "10.91.10.32/28"]

BastionBLUESubnetCIDRs = ["10.90.10.0/28", "10.90.10.16/28", "10.00.10.32/28"]


mount_target_ip_address = "10.91.2.165"

bucket = "com.masimo.msn.tf.non-prod"

certfile = "../certs/DEV3/gd_bundle-g2-g1.crt"

private_key = "../certs/DEV2/star_dev2-masimosn.com.key"

public_certificate = "../certs/DEV2/2d5436d91234b0d6.pem"

bastion_ssh_public_key = "../ssh_key/bastion.pub"

