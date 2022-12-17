zone_name_or_id = "masimosafetynet.sa"

web-domain = "*.masimosafetynet.sa"

api-domain  = "app.masimosafetynet.sa"

compartment_name = "msn-prod"

compartment_id = "ocid1.compartment.oc1..aaaaaaaaewqe7y2isaogggu6widpfa5qyitpg3syt7hn6cmpe3v7wj3qj54a"

compartment_description = "msn-prod comp"

dns_zone_name = "masimosafetynet.sa"

bastion_ip = "144.24.208.70"

COMMONVCNCIDR = "10.120.0.0/16"

BLUEVCNCIDR = "10.121.0.0/16"

GREENVCNCIDR = "10.122.0.0/16"
  
PublicCIDR = "0.0.0.0/0"

PrivateSubnetCIDR = "10.120.1.0/24"

PublicSubnetCIDR = "10.120.2.0/24" 

BLUEPrivateSubnetCIDR = "10.121.0.0/24"

BLUEPublicSubnetCIDR = "10.121.1.0/24" 

GREENPrivateSubnetCIDR = "10.122.2.0/24"

GREENPublicSubnetCIDR = "10.122.3.0/24" 


BastionCOMMONSubnetCIDRs = ["10.120.10.0/28", "10.120.10.16/28", "10.120.10.32/28"]

BastionBLUESubnetCIDRs = ["10.121.10.0/28", "10.121.10.16/28", "10.121.10.32/28"]


mount_target_ip_address = "10.120.2.165"

bucket = "com.masimo.msn.tf.prod"

certfile = "../certs/PROD-SA/bundle-prod.crt"

private_key = "../certs/PROD-SA/prodcert.key"

public_certificate = "../certs/PROD-SA/prodcert.pem"

bastion_ssh_public_key = "../ssh_key/bastion.pub"

# zone_name_or_id = "ocid1.dns-zone.oc1..aaaaaaaaun4h6rv2fvu4h2z5bohtxxqv5hk6xbmkjiqxbs33xiqazy5jg66q"

vault_key_id = "ocid1.key.oc1.me-jeddah-1.djralk4baae6e.abvgkljrusecelatuuwo75pyd75igyfpwwwfgu2jmr3kpqmvp5uqmqfdm67q"

access_key = "AKIAZY25E7Q72BBRZ4N4"

secret_key = "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"

tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaaajqn5vtxsap42gqlmvtr46sluvvdzyxxlapoqips2aygucxtgwyq"

user_ocid = "ocid1.user.oc1..aaaaaaaafc4nk6y7vq3ona5dqkhx643ggcsepjlxntbmy64iulifcg7s4buq"

fingerprint = "49:cd:a0:93:d3:9a:5c:f6:88:47:c8:fe:5f:90:3f:c9"

private_key_path = "../ssh_key/msn-prod-api-pvt-key.pem"
