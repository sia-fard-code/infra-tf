# variable "zone_name_or_id" {
#   default = var.zone_name_or_id
# }

# variable "web-domain" {
#   default = var.web-domain
# }

# variable "api-domain" {
#   default = var.api-domain
# }

resource "oci_dns_zone" "publiczone" {
  compartment_id = var.CompartmentOCID
  name           = var.dns_zone_name
  zone_type      = "PRIMARY"
  lifecycle {
      ignore_changes = [id]
  }
}


# resource "oci_dns_view" "priv_view" {
#   compartment_id = var.CompartmentOCID
#   scope          = "PRIVATE"
# }

resource "oci_dns_record" "web_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = var.web-domain
    rtype = "CNAME"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = "www-b.${var.zone_name_or_id}"
    ttl = 20
}

resource "oci_dns_record" "app_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "app.${var.zone_name_or_id}"
    rtype = "CNAME"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = "app-b.${var.zone_name_or_id}"
    ttl = 20
}

resource "oci_dns_record" "apigw_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "api.${var.zone_name_or_id}"
    rtype = "CNAME"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = "api-b.${var.zone_name_or_id}"
    ttl = 20
}


resource "oci_dns_record" "admin_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "admin.${var.zone_name_or_id}"
    rtype = "CNAME"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = "admin-b.${var.zone_name_or_id}"
    ttl = 20
}



# resource "oci_dns_record" "db_record" {
#     #Required
#     zone_name_or_id = var.zone_name_or_id
#     domain = "db0.${var.zone_name_or_id}"
#     rtype = "A"

#     #Optional
#     compartment_id = var.CompartmentOCID
#     rdata = var.db_lb_ip
#     ttl = 20
# }

resource "oci_dns_record" "bastion_record" {
    #Required
    zone_name_or_id = var.zone_name_or_id
    domain = "bastion.${var.zone_name_or_id}"
    rtype = "A"

    #Optional
    compartment_id = var.CompartmentOCID
    rdata = var.bastion_ip
    ttl = 20
}