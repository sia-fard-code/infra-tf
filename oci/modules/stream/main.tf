resource "oci_streaming_stream_pool" "masimo_stream_pool" {
  compartment_id = var.CompartmentOCID
  name           = "COMMOM-MSN-stream-pool"
  private_endpoint_settings {

        #Optional
        subnet_id = var.subnet_id
    }
  kafka_settings {

        #Optional
        auto_create_topics_enable = true
    }

  custom_encryption_key {
        #Required
        kms_key_id = var.key_id
    }
}

resource "oci_streaming_stream" "msn_raw_hds_data" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_raw_hds_data"
    partitions = 10
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}

resource "oci_streaming_stream" "msn_system_events" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_system_events"
    partitions = 10
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_raw_hds_data_LEGACY_RETRY" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_raw_hds_data_LEGACY_RETRY"
    partitions = 5
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_hifi_downloads" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_hifi_downloads"
    partitions = 1
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_appointment_updates" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_appointment_updates"
    partitions = 10
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_system_events_RETRY" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_system_events_RETRY"
    partitions = 5
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_raw_hds_data_VDC_RETRY" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_raw_hds_data_VDC_RETRY"
    partitions = 5
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_patient_settings_updates" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_patient_settings_updates"
    partitions = 1
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}
resource "oci_streaming_stream" "msn_user_permission_updates" {
    #Required
    # compartment_id = var.CompartmentOCID
    name = "msn_user_permission_updates"
    partitions = 1
    stream_pool_id = oci_streaming_stream_pool.masimo_stream_pool.id
}