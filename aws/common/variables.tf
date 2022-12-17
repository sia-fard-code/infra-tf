variable "workspace_to_environment_map" {
  default = {
    DEV     = "DEV"
    DEV1    = "DEV1"
    DOC-DEV = "DOC-DEV"
    DR      = "DR"
    DEV0    = "DEV0"
    QA0     = "QA0"
    QA      = "QA"
    QA1     = "QA1"
    INT0    = "INT0"
    INT1    = "INT1"
    PROD    = "PROD"
    PROD-US = "PROD-US"
    PROD-JP = "PROD-JP"
    PROD-CA = "PROD-CA"
    PROD-EU = "PROD-EU"
    PROD-FR = "PROD-FR"
    PROD-SG = "PROD-SG"
    DR-US   = "DR-US"
    DR-EU   = "DR-EU"
    DR-FR   = "DR-FR"
    DR-JP   = "DR-JP"
    DR-DEV  = "DR-DEV"
  }
}

variable "environment_to_region_map" {
  default = {
    DEV     = "us-west-1"
    DEV1    = "us-west-2"
    DOC-DEV = "us-west-2"
    DEV0    = "us-west-2"
    DR-DEV  = "us-west-1"
    DR      = "us-east-2"
    QA      = "us-west-2"
    QA0     = "us-west-2"
    QA1     = "us-west-2"
    INT0    = "us-west-2"
    INT1    = "us-west-2"
    INT     = "eu-central-1"
    PROD    = "us-west-1"
    PROD-EU = "eu-central-1"
    PROD-JP = "ap-northeast-1"
    PROD-SG = "ap-southeast-1"
    PROD-CA = "ca-central-1"
    DR-EU   = "eu-west-1"
    DR-FR   = "eu-west-1"
    DR-JP   = "ap-northeast-3"
    PROD-FR = "eu-west-3"
    PROD-US = "us-west-2"
    DR-US   = "us-east-2"
  }
}

variable "new_b_g_env" {
  default = [
    "DEV1",
    "DEV0",
    "QA",
    "PROD-CA",
    "PROD-EU",
    "PROD-JP",
    "PROD-FR",
    "PROD-US",
    "PROD-SG",
    "DR-JP",
    "DR-EU",
    "DR-FR",
    "DR-US",
    "QA1"
  ]
}


variable "pan_env" {
  default = [
  ]
}
variable "msn_open_env" {
  default = [
    "DEV1",
    "PROD-CA",
    "DR-EU",
    "DR-US",
    "DR-FR",
    "DEV0",
    "PROD-US",
    "PROD-JP",
    "PROD-FR",
    "PROD-EU",
    "PROD-SG",
    "QA",
    "QA0",
    "QA1"
  ]
}
variable "msn_svc_env" {
  default = [
    "DEV1",
    "DEV0",
    "PROD-US",
    "PROD-CA",
    "PROD-EU",
    "PROD-FR",
    "PROD-SG",
    "PROD-JP",
    "QA",
    "QA0",
    "DR-EU",
    "DR-US",
    "DR-FR",
    "QA1"
  ]
}
variable "msn_th_env" {
  default = [
    "DEV1",
    "QA",
    "QA1",
  ]
}


variable "msk_enable" {
  default = [
    "PROD-US",
    "PROD-FR",
    "PROD-SG",
    "PROD-EU",
    "PROD-JP",
    "PROD-CA",
    "DR-EU",
    "DR-US",
    "DR-FR",
    "DEV1",
    "DEV0",
    "QA",
    "QA1",
  ]
}


variable "prod_env" {
  default = [
    "PROD-EU",
    "PROD-CA",
    "PROD-US",
    "PROD-FR",
    "PROD-JP",
    "PROD-SG",
  ]
}

variable "dr_env" {
  default = [
    "DR-EU",
    "DR-US",
    "DR-CA",
    "DR-DEV",
    "DR-JP",
    "DR-FR"
  ]
}

variable "second_region_map" {
  default = {
    DEV     = "b"
    DEV1    = "b"
    DOC-DEV = "b"
    DEV0    = "b"
    DR-DEV  = "b"
    DR-QA   = "b"
    DR      = "b"
    QA      = "b"
    QA0     = "b"
    QA1     = "b"
    INT0    = "b"
    INT1    = "b"
    INT     = "b"
    PROD    = "b"
    PROD-EU = "b"
    PROD-CA = "b"
    PROD-SG = "b"
    DR-EU   = "b"
    DR-FR   = "b"
    PROD-FR = "b"
    PROD-US = "b"
    PROD-JP = "c"
    DR-JP   = "b"
    DR-US   = "b"
  }
}

variable "deployment_to_index_map" {
  default = {
    BLUE  = 0
    GREEN = 1
  }
}

variable "index_to_deployment_map" {
  default = {
    0 = "BLUE"
    1 = "GREEN"
  }
}

locals {
  environment = lookup(var.workspace_to_environment_map, terraform.workspace, "DEV")
  region      = lookup(var.environment_to_region_map, local.environment, "DEV")
  deployment  = lookup(var.deployment_to_index_map, var.deployment, "BLUE")
}

variable "deployment" {
  default     = "BLUE"
  description = "Type of Blue-Green deployment "
}

variable "mongo_journal_volume_size" {
  default     = "52"
  description = "Size specified in GB"
}

variable "mongo_data_volume_size" {
  default     = "256"
  description = "Size specified in GB"
}

variable "mongo_log_volume_size" {
  default     = "26"
  description = "Size specified in GB"
}

variable "rke_cluster_id" {
  default = "rke"
}

variable "env_type" {
  default = "non-prod"
}

variable "rke_asg_count" {
  default = "1"
}


variable "rke_asg_max" {
  default = "3"
}

variable "rke_inst_name" {
  default = "rke"
}

variable "cluster_name" {
  type    = string
  default = "k8s"
}

variable "vpc_name" {
  default = "MasimoSafetyNet"
}

variable "networking" {
  description = "Choice of networking provider (canal or flannel)"
  type        = string
  default     = "canal"
}

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "bastion_ssh_user" {
  default = "ubuntu"
}

variable "key_name_bastion" {
  default = "MasimoSafetyNet-Jump-Host"
}

variable "key_name_app_server" {
  default = "MSN"
}

variable "pan_instance_size" {
  default = "m5.4xlarge"
}

variable "pan_volume_size" {
  default = 60
}

variable "pan_instance_key" {
  default = "DR-MasimoSafetyNet"
}

variable "backend_aws_access_key" {
  default = ""
}

variable "backend_aws_secret_key" {
  default = ""
}


