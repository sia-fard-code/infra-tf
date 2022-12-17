

zone_name_or_id = "dev3-masimosn.com"

web-domain = "*.dev3-masimosn.com"

api-domain  = "app.dev3-masimosn.com"

compartment_id = "ocid1.compartment.oc1..aaaaaaaahlpqhftlzqcxuh56mbzvxm27243f7pecselksvqyp2aiox33bbyq"
#compartment_id = "ocid1.compartment.oc1..aaaaaaaatkiufgkm4jl5xsbdqlyho6fd3n54mlau625y7w6i5qrgj5q7ocwq"

tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaaudc5ayyu4jojlwpprj66yfsnmpyggcvjjanh4cchpq6rfkhbsevq"

user_ocid = "ocid1.user.oc1..aaaaaaaabt3okstg5e2swtffxjwpldgw6e6xyytcuwdeofnhe4ay4yysv3rq"

fingerprint = "e9:b9:87:a1:06:72:5b:5a:75:ec:1d:5e:f5:40:e4:1c"

private_key_path = "../ssh_key/oci_dev_prv_key.pem"

compartment_name = "DEV3"

compartment_description = "DEV3 comp"

dns_zone_name = "dev3-masimosn.com"

bastion_ip = "150.230.246.193"

BLUEVCNCIDR = "10.100.0.0/16"

GREENVCNCIDR = "10.102.0.0/16"


COMMONVCNCIDR = "10.101.0.0/16"

PublicCIDR = "0.0.0.0/0"

PrivateSubnetCIDR = "10.101.1.0/24"

PublicSubnetCIDR = "10.101.2.0/24" 

BLUEPrivateSubnetCIDR = "10.100.0.0/24"

BLUEPublicSubnetCIDR = "10.100.1.0/24" 


GREENPrivateSubnetCIDR = "10.102.0.0/24"

GREENPublicSubnetCIDR = "10.102.1.0/24" 


BastionCOMMONSubnetCIDRs = ["10.101.10.0/28", "10.101.10.16/28", "10.101.10.32/28"]

BastionBLUESubnetCIDRs = ["10.100.10.0/28", "10.100.10.16/28", "10.100.10.32/28"]


mount_target_ip_address = "10.101.2.55"

bucket = "com.masimo.msn.tf.non-prod"

certfile = "../certs/DEV3/gd_bundle-g2-g1.crt"

private_key = "../certs/DEV3/star_dev3-masimosn.com.key"

public_certificate = "../certs/DEV3/1f151b589b3efb80.pem"

bastion_ssh_public_key = "../ssh_key/bastion.pub"

vault_key_id = "ocid1.key.oc1.me-jeddah-1.dfq2hwjcaadr2.abvgkljr4xvw2h5mlphdf5pzf7tn75yjfcuvifo7ynvd7vyxs2xw26cp74na"

TestServerShape = "VM.Standard2.2"

access_key = "AKIA4TU3CRCVKZBTMBFQ"

secret_key = "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"
