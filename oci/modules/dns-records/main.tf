# variable "zone_name_or_id" {
#   default = "dev2-masimosn.com"
# }

# variable "web-domain" {
#   default = "*.dev2-masimosn.com"
# }

# variable "api-domain" {
#   default = "app.dev2-masimosn.com"
# }




resource "oci_dns_view" "priv_view" {
  compartment_id = var.CompartmentOCID
  display_name = "${terraform.workspace}-${var.color}-pv"
  scope          = "PRIVATE"
}

resource "oci_dns_zone" "pivate_zone" {
  compartment_id = var.CompartmentOCID
  name = "${var.zone_name_or_id}"
  scope = "PRIVATE"
  zone_type = "PRIMARY"
  # view_id = oci_dns_view.priv_view.id
  view_id = oci_dns_view.priv_view.id
}

resource oci_dns_resolver vcn2-dns-resolver {
  attached_views { view_id = oci_dns_view.priv_view.id }
  display_name = "${var.color}-resolver"
  resolver_id  = var.dns_resolver_id
  scope        = "PRIVATE"
}


resource "oci_dns_record" "api_int_record" {
    #Required
    zone_name_or_id = oci_dns_zone.pivate_zone.id
    domain = "app.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.api_int_lb_ip
    ttl = 20
}

resource "oci_dns_record" "gw_int_record" {
    #Required
    zone_name_or_id = oci_dns_zone.pivate_zone.id
    domain = "api.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.gw_int_lb_ip
    ttl = 20
}

resource "oci_dns_record" "db_record" {
    #Required
    zone_name_or_id = oci_dns_zone.pivate_zone.id
    domain = "db0.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.db_lb_ip
    ttl = 20
}


resource "oci_dns_record" "web-efs" {
    #Required
    zone_name_or_id = oci_dns_zone.pivate_zone.id
    domain = "efs-web-${terraform.workspace}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.mount_target_ip_address
    ttl = 20
}

resource "oci_dns_record" "api-efs" {
    #Required
    zone_name_or_id = oci_dns_zone.pivate_zone.id
    domain = "efs-api-${terraform.workspace}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.mount_target_ip_address
    ttl = 20
}


resource "oci_dns_record" "web_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "${var.www_prefix}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.web_lb_ip
    ttl = 20
}

resource "oci_dns_record" "admin_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "${var.admin_prefix}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.admin_lb_ip
    ttl = 20
}

resource "oci_dns_record" "api_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "${var.app_prefix}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.api_lb_ip
    ttl = 20
}

resource "oci_dns_record" "apigw_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "${var.api_prefix}.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.gw_lb_ip
    ttl = 20
}


