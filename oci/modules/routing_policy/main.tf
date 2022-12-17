resource "oci_load_balancer_load_balancer_routing_policy" "rt" {
  condition_language_version = "V1"
  load_balancer_id = var.load_balancer_id
  name             = "routing_policy_1"

  rules {
    name      = "routing_rule_1"
    condition = "all(http.request.url.path sw (i '/api/telehealth/v1'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-telehealth-service-bknd"
    }
  }
  rules {
    name      = "routing_rule_14"
    condition = "all(http.request.url.path sw (i '/api/v1/org'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-telehealth-service-bknd"
    }
  } 
  rules {
    name      = "routing_rule_2"
    condition = "all(http.request.url.path sw (i '/api/mobile/telehealth/v1'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-telehealth-service-bknd"
    }
  }
  rules {
    name      = "routing_rule_8"
    condition = "all(http.request.url.path sw (i '/api/mobile/patient/diagnostics/v1'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-patient-settings-bknd"
    }
  }
  rules {
    name      = "routing_rule_11"
    condition = "all(http.request.url.path sw (i '/api/mobile/patient/settings/v1/'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-patient-settings-bknd"
    }
  }
  rules {
    name      = "routing_rule_13"
    condition = "all(http.request.url.path sw (i '/api/patient/settings/v1/'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-patient-settings-bknd"
    }
  }
  rules {
    name      = "routing_rule_7"
    condition = "all(http.request.url.path sw (i '/api/mobile/patient/settings/v1'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-patient-settings-bknd"
    }
  }
  rules {
    name      = "routing_rule_4"
    condition = "all(http.request.url.path sw (i '/api/v1/integration'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-external-integration-bknd"
    }
  }
  rules {
    name      = "routing_rule_5"
    condition = "all(http.request.url.path sw (i '/api/v1/provider'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-external-integration-bknd"
    }
  }
  rules {
    name      = "routing_rule_6"
    condition = "all(http.request.url.path sw (i '/api/mobile/v1/system/events'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-system-events-rest-bknd"
    }
  }
  rules {
    name      = "routing_rule_9"
    condition = "all(http.request.url.path sw (i '/api/notification/telehealth/v1'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-notification-svc-bknd"
    }
  }
  rules {
    name      = "routing_rule_3"
    condition = "all(http.request.url.path sw (i '/api/mobile/v1/data/hds'))"
    actions {
        name             = "FORWARD_TO_BACKENDSET"
        backend_set_name = "${var.color}-vitals-rest-bknd"
    }
  }

}
