terraform {
  backend "s3" {
  }
}

provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    access_key     = var.access_key
    secret_key     = var.secret_key
    region         = "us-west-2"
    bucket         = var.bucket
    key            = "oci/${terraform.workspace}/common.tfstate"
  }
}




output "output_name" {
  value = data.terraform_remote_state.common.outputs
}

data "oci_core_vcn_dns_resolver_association" "private_dns_resolver_association" {
  vcn_id = module.network.vcn_id
}

data "oci_dns_resolver" "private_dns_resolver" {
  resolver_id = data.oci_core_vcn_dns_resolver_association.private_dns_resolver_association.dns_resolver_id
  scope       = "PRIVATE"
}

module "network" {
  source    = "../modules/network"
  CompartmentOCID = var.compartment_id
  VCNCIDR = var.GREENVCNCIDR
  PublicCIDR = var.PublicCIDR
  PrivateSubnetCIDR = var.GREENPrivateSubnetCIDR
  PublicSubnetCIDR = var.GREENPublicSubnetCIDR
  prv_route_rules = [{
    cidr_dest = var.COMMONVCNCIDR
    lpg_id = oci_core_local_peering_gateway.common_lpg.id},
    {
    cidr_dest = "0.0.0.0/0"
    lpg_id = module.network.natgw_id}]
  pub_route_rules = [{
    cidr_dest = var.COMMONVCNCIDR
    lpg_id = oci_core_local_peering_gateway.common_lpg.id},
    {
    cidr_dest = "0.0.0.0/0"
    lpg_id = module.network.intgw_id}
    ]
  color = "GREEN"
}

resource "oci_core_local_peering_gateway" "common_lpg" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = module.network.vcn_id

    #Optional
    display_name = "common_lpg"
    peer_id =  data.terraform_remote_state.common.outputs.green_lpg
    lifecycle {
      ignore_changes = all
  }
}

# module "web-compute" {
#     source = "../modules/compute"
#     CompartmentOCID = data.terraform_remote_state.common.outputs.compartment_id
#     TestServerShape = var.TestServerShape
#     tenancy_ocid = var.tenancy_ocid
#     private_id = module.network.private_id
#     WebVMCount = var.WebVMCount
#     ssh_public_key = var.ssh_public_key
#     WebServerBootStrap = var.WebServerBootStrap
#     bastion_host = data.terraform_remote_state.common.outputs.bastion_host_public_ip
#     ssh_private_key = var.ssh_private_key
#     servername = "web"
# }

# module "api-compute" {
#     source = "../modules/compute"
#     CompartmentOCID = data.terraform_remote_state.common.outputs.compartment_id
#     TestServerShape = var.TestServerShape
#     tenancy_ocid = var.tenancy_ocid
#     private_id = module.network.private_id
#     WebVMCount = var.WebVMCount
#     ssh_public_key = var.ssh_public_key
#     WebServerBootStrap = var.WebServerBootStrap
#     bastion_host = data.terraform_remote_state.common.outputs.bastion_host_public_ip
#     ssh_private_key = var.ssh_private_key
#     servername = "api"
# }

# module "admin-compute" {
#     source = "../modules/compute"
#     CompartmentOCID = data.terraform_remote_state.common.outputs.compartment_id
#     TestServerShape = var.TestServerShape
#     tenancy_ocid = var.tenancy_ocid
#     private_id = module.network.private_id
#     WebVMCount = var.WebVMCount
#     ssh_public_key = var.ssh_public_key
#     WebServerBootStrap = var.WebServerBootStrap
#     bastion_host = data.terraform_remote_state.common.outputs.bastion_host_public_ip
#     ssh_private_key = var.ssh_private_key
#     servername = "admin"
# }


module "lb-web" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "false"
    backendset = ["GREEN-web-bknd"]
    lbname = "web"
    appname = "web"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 443
    routing_policy_name = ""
    path_route_set_name = ""
    hc_port = 443
    hc_url = "/health"
    hc_protocol = "HTTP"
    subnet_id = module.network.pubsubnetids
}

module "lb-api" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "false"    
    backendset = ["GREEN-api-bknd"]
    lbname = "api"
    appname = "api"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 443
    routing_policy_name = ""
    path_route_set_name = ""
    hc_port = 8443
    hc_url = "/health"
    hc_protocol = "HTTP"
    subnet_id = module.network.pubsubnetids
}

module "lb-int-api" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "true"    
    backendset = ["GREEN-api-bknd"]
    lbname = "int-api"
    appname = "int-api"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 8443
    routing_policy_name = ""
    path_route_set_name = ""
    hc_port = 8443
    hc_url = "/health"
    hc_protocol = "HTTP"
    subnet_id = module.network.pubsubnetids
}

module "lb-int-gw" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "true"    
    backendset = ["GREEN-system-events-rest-bknd", "GREEN-vitals-rest-bknd", "GREEN-telehealth-service-bknd", "GREEN-system-consumer-bknd", "GREEN-notification-svc-bknd",
    "GREEN-legacy-data-capture-bknd", "GREEN-external-integration-bknd", "GREEN-hifi-download-bknd", "GREEN-vitals-data-capture-bknd", "GREEN-patient-settings-bknd"]

    lbname = "int-gw"
    appname = "int-gw"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 8443
    hc_url = "/actuator/health"
    hc_protocol = "HTTP"
    routing_policy_name = module.routing_policies.routing_policy_name
    path_route_set_name = ""
    hc_port = 8443
    subnet_id = module.network.pubsubnetids
}

module "lb-admin" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "false"
    backendset = ["GREEN-admin-bknd"]
    lbname = "admin-app"
    appname = "admin-app"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 443
    routing_policy_name = ""
    path_route_set_name = ""
    hc_port = 8443
    hc_url = "/actuator/health"
    hc_protocol = "HTTP"
    subnet_id = module.network.pubsubnetids
}

module "lb-gw" {
  source    = "../modules/lb"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lb_private = "false"
    backendset = ["GREEN-gateway-bknd"]
    lbname = "gateway"
    appname = "gateway"
    color = "GREEN"
    certfile = var.certfile
    private_key = var.private_key
    public_certificate = var.public_certificate
    vcn_id = module.network.vcn_id
    WebVMCount = var.WebVMCount
    listener_port = 443
    routing_policy_name = ""
    path_route_set_name = ""
    hc_port = 9000
    hc_url = "/actuator/health"
    hc_protocol = "HTTP"
    subnet_id = module.network.pubsubnetids
}

module "asg-web" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "web"
    appname = "web"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-web.instance_in_pool_info.private_ip
    # instance_id = module.web-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = module.lb-web.backend_set_name
    port = 443
    load_balancer_id = module.lb-web.load_balancer_id}]
    is_load_balancer_required = true
}

module "name" {
  source = "../modules/lb_rule"
  load_balancer_id = module.lb-web.load_balancer_id
}



module "asg-api" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "api"
    appname = "api"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-api.instance_in_pool_info.private_ip
    # instance_id = module.api-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = module.lb-api.backend_set_name
    port = 8443
    load_balancer_id = module.lb-api.load_balancer_id},
    {
    backend_set_name = module.lb-int-api.backend_set_name
    port = 8443
    load_balancer_id = module.lb-int-api.load_balancer_id}
    ]

    is_load_balancer_required = true
}

module "asg-admin" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "admin-app"
    appname = "admin-app"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = module.lb-admin.backend_set_name
    port = 8443
    load_balancer_id = module.lb-admin.load_balancer_id}]
    is_load_balancer_required = true
}


module "gateway" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "gateway"
    appname = "gateway"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.gateway.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = module.lb-gw.backend_set_name
    port = 9000
    load_balancer_id = module.lb-gw.load_balancer_id}]
    is_load_balancer_required = true
}


module "telehealth-service" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "telehealth-service"
    appname = "telehealth-service"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-telehealth-service-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "notification-service" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "notification-service"
    appname = "notification-service"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-notification-svc-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "system-events-rest" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "system-events-rest"
    appname = "system-events-rest"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-system-events-rest-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "system-events-consumer" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "system-events-consumer"
    appname = "system-events-consumer"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-system-consumer-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
    depends_on = [module.lb-int-gw]
}

module "vitals-rest" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "vitals-rest"
    appname = "vitals-rest"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-vitals-rest-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "legacy-data-capture" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "legacy-data-capture"
    appname = "legacy-data-capture"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-legacy-data-capture-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "external-integration" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "external-integration"
    appname = "external-integration"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-external-integration-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "hifi-download" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "hifi-download"
    appname = "hifi-download"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-hifi-download-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "patient-settings" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "patient-settings"
    appname = "patient-settings"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-patient-settings-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "vitals-data-capture" {
  source    = "../modules/asg"
    CompartmentOCID = var.compartment_id
    tenancy_ocid = var.tenancy_ocid
    lbname = "vitals-data-capture"
    appname = "vitals-data-capture"
    color = "GREEN"
    vcn_id = module.network.vcn_id
    routetableid = module.network.pubroutetableid
    dhcp_options_id = module.network.dhcp_options_id
    WebVMCount = var.WebVMCount
    # ip_address = module.asg-admin.instance_in_pool_info.private_ip
    # instance_id = module.admin-compute.instance_id
    primary_subnet_id = module.network.private_id
    subnet_id = module.network.pubsubnetid
    ssh_public_key = var.ssh_public_key
    TestServerShape = var.TestServerShape
    lbs = [{
    backend_set_name = "GREEN-vitals-data-capture-bknd"
    port = 8443
    load_balancer_id = module.lb-int-gw.load_balancer_id}]
    is_load_balancer_required = true
}

module "routing_policies" {
  source = "../modules/routing_policy"
  load_balancer_id = module.lb-int-gw.load_balancer_id  
  color = "GREEN"
}

module "path_routes" {
  source = "../modules/pathroute"
  color = "GREEN"
  load_balancer_id = module.lb-int-gw.load_balancer_id  
}


module "dns" {
  source = "../modules/dns-records"
  CompartmentOCID = var.compartment_id
  zone_name_or_id = var.zone_name_or_id
  mount_target_ip_address = var.mount_target_ip_address
  web_lb_ip = module.lb-web.lb_ip
  api_lb_ip = module.lb-api.lb_ip
  api_int_lb_ip = module.lb-int-api.lb_ip
  gw_lb_ip = module.lb-gw.lb_ip
  gw_int_lb_ip = module.lb-int-gw.lb_ip
  admin_lb_ip= module.lb-admin.lb_ip
  db_lb_ip = data.terraform_remote_state.common.outputs.db_lb_ip
  color = "GREEN"
  # view_id = data.oci_dns_resolver.private_dns_resolver.default_view_id
  dns_resolver_id = data.oci_core_vcn_dns_resolver_association.private_dns_resolver_association.dns_resolver_id
  www_prefix = "www-g"
  app_prefix = "app-g"
  api_prefix="api-g"
  admin_prefix="admin-g"
}

#module "tags" {
#  source = "../modules/tag"
#   CompartmentOCID = var.compartment_id
#}