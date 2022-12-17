
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.CompartmentOCID
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}


/* Load Balancer */
##########################################################################################
## Variables
##########################################################################################
variable "load_balancer_shape" {
  default = "10Mbps"
}

variable "LBCount" {
  default = 1
}


##########################################################################################
## Load Balancer resources: LB, LB Listener, LB Backendset, LB Backends
##########################################################################################
# resource "oci_load_balancer" "lb" {
#   shape          = var.load_balancer_shape
#   compartment_id = var.CompartmentOCID
#   subnet_ids     = var.subnet_id
#   display_name   = "${terraform.workspace}-${var.lbname}-lb"
#   is_private     = false
# }


resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.CompartmentOCID
  display_name   = "${terraform.workspace}-${var.color}-${var.lbname}-lb"
  shape          = "flexible"
  subnet_ids     = var.subnet_id
  is_private     = var.lb_private
  

  dynamic "shape_details" {
    for_each =  [1]
    content {
      minimum_bandwidth_in_mbps = 10
      maximum_bandwidth_in_mbps = 100
    }
  }
}


resource "oci_load_balancer_backend_set" "lb-backendset" {
  count = length(var.backendset)
  name             = "${var.backendset[count.index]}"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port        = var.hc_port
    protocol    = var.hc_protocol
    return_code = "200"
    url_path    = var.hc_url

    # default interval_ms = 30000 (30 s)
    interval_ms = 5000

    # default timeout_in_millis = 3000 (3 s)
    timeout_in_millis = 3000

    # default retries = 3
    retries = 1
  }

   
  # session_persistence_configuration {
  #   cookie_name      = "lb-${var.appname}-session"
  #   disable_fallback = true
  # }
  # lifecycle {
  #   ignore_changes = [ssl_configuration[0].certificate_name]
  # }
}



resource "oci_load_balancer_certificate" "lb-cert" {
  load_balancer_id   = "${oci_load_balancer_load_balancer.lb.id}"
  ca_certificate     = file(var.certfile)
  certificate_name   = "${var.appname}-cert"
  private_key = file(var.private_key)
  public_certificate = file(var.public_certificate)

  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "oci_load_balancer_listener" "lb_listener_443" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "${var.appname}-https"
  default_backend_set_name = oci_load_balancer_backend_set.lb-backendset[0].name
  port                     = var.listener_port
  protocol                 = "HTTP"
  routing_policy_name = var.routing_policy_name
  connection_configuration {
    idle_timeout_in_seconds = "30"
  }
  # hostname_names = ["${var.appname}"]
  ssl_configuration {
        certificate_name = oci_load_balancer_certificate.lb-cert.certificate_name
        verify_peer_certificate = false
    }
  # lifecycle {
  #   ignore_changes = [ssl_configuration[0].certificate_name]
  # }
}

resource "oci_load_balancer_listener" "lb_listener_80" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "${var.appname}-http"
  default_backend_set_name = oci_load_balancer_backend_set.lb-backendset[0].name
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "300"
  }
}

resource "oci_load_balancer_path_route_set" "lb-routing" {
  #Required
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  name             = "lb-${var.appname}-${var.color}-routing"
  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backend_set.lb-backendset[0].name
    path             = "/"
    path_match_type {
      #Required
      match_type = "PREFIX_MATCH"
    }
  }
}

output "lb_is_public" {
  value = [oci_load_balancer_load_balancer.lb.ip_address_details[0].is_public]
}
