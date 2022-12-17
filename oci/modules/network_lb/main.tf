
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.CompartmentOCID
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

resource "oci_network_load_balancer_network_load_balancer" "network_load_balancer" {
    #Required
    compartment_id = var.CompartmentOCID
    display_name   = "${terraform.workspace}-${var.color}-${var.lbname}-netlb"
    subnet_id     = var.subnet_id
    is_private     = var.lb_private
    # is_preserve_source_destination = var.network_load_balancer_is_preserve_source_destination
    # network_security_group_ids = var.network_load_balancer_network_security_group_ids
    # reserved_ips {

    #     #Optional
    #     id = var.network_load_balancer_reserved_ips_id
    # }
}

resource "oci_network_load_balancer_backend_set" "lb-backendset" {
  count = length(var.backendset)
  name             = "${var.backendset[count.index]}"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.network_load_balancer.id
  policy           = "FIVE_TUPLE"
  # is_preserve_source       = true

  health_checker {
    port        = var.hc_port
    protocol    = var.hc_protocol
    return_code = "200"

  }
}

resource "oci_network_load_balancer_listener" "lb_listener_27017" {
  network_load_balancer_id         = oci_network_load_balancer_network_load_balancer.network_load_balancer.id
  name                     = "${var.appname}-mongo"
  default_backend_set_name = oci_network_load_balancer_backend_set.lb-backendset[0].name
  port                     = 27017
  protocol                 = "TCP"
}