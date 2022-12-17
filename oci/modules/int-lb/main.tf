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
resource "oci_load_balancer_load_balancer" "lb" {
  shape          = "flexible"
  compartment_id = var.CompartmentOCID
  subnet_ids     = var.subnet_id
  display_name   = "${terraform.workspace}-${var.appname}-${var.color}-int-lb"
  is_private     = true
  dynamic "shape_details" {
    for_each =  [1]
    content {
      minimum_bandwidth_in_mbps = 10
      maximum_bandwidth_in_mbps = 100
    }
  }
}

resource "oci_load_balancer_backend_set" "lb-backendset" {
  name             = "${var.backendset}"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port        = "80"
    protocol    = "HTTP"
    return_code = "200"
    url_path    = "/"

    # default interval_ms = 30000 (30 s)
    interval_ms = 5000

    # default timeout_in_millis = 3000 (3 s)
    timeout_in_millis = 2000

    # default retries = 3
    retries = 3
  }

  session_persistence_configuration {
    cookie_name      = "int-lb-${var.appname}-session"
    disable_fallback = true
  }
}

resource "oci_load_balancer_listener" "lb_listener_80" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "int-${var.appname}-${var.color}-http"
  default_backend_set_name = oci_load_balancer_backend_set.lb-backendset.name
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "300"
  }
}


resource "oci_load_balancer_path_route_set" "lb-routing" {
  #Required
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  name             = "int-lb-${var.appname}-${var.color}-routing"
  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backend_set.lb-backendset.name
    path             = "/"
    path_match_type {
      #Required
      match_type = "PREFIX_MATCH"
    }
  }
}

data "oci_load_balancer_load_balancers" "this" {
  compartment_id = var.CompartmentOCID

}


# resource "oci_load_balancer_backend" "lb-backend" {
#   count            = var.WebVMCount
#   load_balancer_id = oci_load_balancer.lb.id
#   backendset_name  = oci_load_balancer_backend_set.lb-backendset.name
#   ip_address       = var.ip_address
#   port             = 80
#   backup           = false
#   drain            = false
#   offline          = false
#   weight           = 1
# }