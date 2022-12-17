terraform {
  backend "s3" {
    
  }
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}


# data "oci_core_vcn_dns_resolver_association" "private_dns_resolver_association" {
#   vcn_id = module.network.vcn_id
# }

# data "oci_dns_resolver" "private_dns_resolver" {
#   resolver_id = data.oci_core_vcn_dns_resolver_association.private_dns_resolver_association.dns_resolver_id
#   scope       = "PRIVATE"
  
# }


#module "compartment" {
  
#  source = "../modules/compartment"
#  tenancy_id = var.tenancy_ocid
#  user_ocid = var.user_ocid
#  fingerprint = var.fingerprint
#  private_key_path = var.private_key_path
#  CompartmentOCID = var.CompartmentOCID
#  compartment_name = var.compartment_name
#  compartment_description = var.compartment_description
#}

module "network" {
  source    = "../modules/network"
#  CompartmentOCID = module.compartment.compartment_id
  CompartmentOCID = var.compartment_id

  VCNCIDR = var.COMMONVCNCIDR
  PublicCIDR = var.PublicCIDR
  PrivateSubnetCIDR = var.PrivateSubnetCIDR
  PublicSubnetCIDR = var.PublicSubnetCIDR
  prv_route_rules = [{
    cidr_dest = var.BLUEVCNCIDR
    lpg_id = oci_core_local_peering_gateway.blue_lpg.id},
    {
    cidr_dest = var.GREENVCNCIDR
    lpg_id = oci_core_local_peering_gateway.green_lpg.id},
    {
    cidr_dest = "0.0.0.0/0"
    lpg_id = module.network.natgw_id}
    ]
  pub_route_rules = [{
    cidr_dest = var.BLUEVCNCIDR
    lpg_id = oci_core_local_peering_gateway.blue_lpg.id},
    {
    cidr_dest = var.GREENVCNCIDR
    lpg_id = oci_core_local_peering_gateway.green_lpg.id},
    {
    cidr_dest = "0.0.0.0/0"
    lpg_id = module.network.intgw_id}
    ]
  color = "COMMON"
}


resource "oci_core_local_peering_gateway" "blue_lpg" {
    #Required
    # compartment_id = module.compartment.compartment_id
    compartment_id = var.compartment_id
    vcn_id = module.network.vcn_id

    #Optional
    display_name = "blue_lpg"
    # peer_id = oci_core_local_peering_gateway.blue_lpg.id
}

resource "oci_core_local_peering_gateway" "green_lpg" {
    #Required
    #compartment_id = module.compartment.compartment_id
    compartment_id = var.compartment_id
    vcn_id = module.network.vcn_id

    #Optional
    display_name = "green_lpg"
    # peer_id = oci_core_local_peering_gateway.blue_lpg.id
}


module "bastion" {
    source = "../modules/bastion"
    #CompartmentOCID = module.compartment.compartment_id
    CompartmentOCID = var.compartment_id
    region = var.region
    color = "COMMON"
    # BastionSubnetCIDRs = var.BastionCOMMONSubnetCIDRs
    subnet_id = module.network.pubsubnetid
    TestServerShape = var.TestServerShape
    InstanceImageOCID = var.InstanceImageOCID
    BastionServerBootStrap = var.BastionServerBootStrap
    BastionVMCount = var.BastionVMCount
    vcn_id = module.network.vcn_id
    intgw_id = module.network.intgw_id
    dhcp_options_id = module.network.dhcp_options_id
    bastion_ssh_public_key = var.bastion_ssh_public_key
}


module "fss" {
  source = "../modules/fss"
  count = 1
  #CompartmentOCID = module.compartment.compartment_id
  CompartmentOCID = var.compartment_id
  fss_count = 1
  subnet_id = module.network.pubsubnetid
  mount_target_ip_address = var.mount_target_ip_address
  export_path_fs_1 = "/web"
  export_path_fs_2 = "/api"
}


module "policy" {
  source = "../modules/policy"
  count = 1
  #CompartmentOCID = module.compartment.compartment_id
  CompartmentOCID = var.compartment_id
  compartment_name = var.compartment_name

}

module "vault" {
  source = "../modules/vault"
  count = 1
  compartment_id = var.compartment_id
}



module "streaming" {
  source = "../modules/stream"
  count = 1
  CompartmentOCID = var.compartment_id
  subnet_id = module.network.privsubnetids
  stream_partitions = 2
  key_id = var.vault_key_id

}

module "lb-db" {
  source    = "../modules/network_lb"
    #CompartmentOCID = module.compartment.compartment_id
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "true"
    lbname = "db"
    backendset = ["mongo"]
    appname = "db"
    color = "COMMON"
    hc_port = 27017
    hc_protocol = "TCP"
    vcn_id = module.network.vcn_id
    subnet_id = module.network.privsubnetids
}

# module "db" {
#   source    = "../modules/asg"
#     CompartmentOCID = module.compartment.compartment_id
#     tenancy_ocid = var.tenancy_ocid
#     lbname = "db"
#     appname = "db"
#     color = "COMMON"
#     vcn_id = module.network.vcn_id
#     routetableid = module.network.pubroutetableid
#     dhcp_options_id = module.network.dhcp_options_id
#     WebVMCount = var.WebVMCount
#     ip_address = module.db.instance_in_pool_info.private_ip
#     # instance_id = module.admin-compute.instance_id
#     primary_subnet_id = module.network.private_id
#     subnet_id = module.network.pubsubnetid
#     ssh_public_key = var.ssh_public_key
#     TestServerShape = var.TestServerShape
#     lbs = [{
#     backend_set_name = module.lb-db.backend_set_name
#     port = 8443
#     load_balancer_id = module.lb-db.load_balancer_id}]
#     is_load_balancer_required = true
# }


module "pub-dns" {
  
  source = "../modules/dns"
  count = 1
  #CompartmentOCID = module.compartment.compartment_id
  CompartmentOCID = var.compartment_id
  zone_name_or_id = var.zone_name_or_id
  dns_zone_name = var.dns_zone_name
  web-domain = var.web-domain
  api-domain  = var.api-domain
  # depends_on = [ module.compartment[0] ]
  bastion_ip = var.bastion_ip
  # db_lb_ip = module.lb-db.lb_ip
}

# module "asg-db" {
#   source    = "../modules/asg"
#     CompartmentOCID = module.compartment.compartment_id
#     tenancy_ocid = var.tenancy_ocid
#     lbname = "db"
#     appname = "db"
#     color = "COMMON"
#     vcn_id = module.network.vcn_id
#     routetableid = module.network.pubroutetableid
#     dhcp_options_id = module.network.dhcp_options_id
#     WebVMCount = var.WebVMCount
#     ip_address = module.asg-db.instance_in_pool_info.private_ip
#     instance_id = module.compute.instance_id
#     primary_subnet_id = module.network.private_id
#     subnet_id = module.network.commonsubnetids
#     ssh_public_key = var.ssh_public_key
#     TestServerShape = var.TestServerShape
#     lbs = [{
#     backend_set_name = module.lb-db.backend_set_name
#     port = 443
#     load_balancer_id = module.lb-db.load_balancer_id}]
#     is_load_balancer_required = true
# }

