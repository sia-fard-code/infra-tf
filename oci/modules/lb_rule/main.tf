resource "oci_load_balancer_rule_set" "load_balancer_rule_set" {
  #Required
  items {
    #Required
    action = "REDIRECT"

    conditions {
      attribute_name = "PATH"
      attribute_value = "/"
      operator = "PREFIX_MATCH"
    }

    redirect_uri {
      protocol = "https"
      port = 443
    }
  }
  
  load_balancer_id = var.load_balancer_id
  name = "oci_load_balancer_rule_set"
}