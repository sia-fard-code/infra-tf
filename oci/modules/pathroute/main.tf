resource "oci_load_balancer_path_route_set" "path_route_set" {
    #Required
    load_balancer_id = var.load_balancer_id
    name = "telehealth_path_route_set"
    path_routes {
        #Required
        backend_set_name = "${var.color}-telehealth-service-bknd"
        path = "/api/telehealth/v1"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-telehealth-service-bknd"
        path = "/api/mobile/v1/telehealth"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-vitals-rest-bknd"
        path = "/api/mobile/v1/data/hds"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-external-integration-bknd"
        path = "/api/v1/integration"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-external-integration-bknd"
        path = "/api/v1/provider"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-system-events-rest-bknd"
        path = "/api/mobile/v1/system/events"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-patient-settings-bknd"
        path = "/api/mobile/patient/settings/v1"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
    path_routes {
        #Required
        backend_set_name = "${var.color}-notification-svc-bknd"
        path = "/api/notification/telehealth/v1"
        path_match_type {
            #Required
            match_type = "FORCE_LONGEST_PREFIX_MATCH"
        }
    }
}