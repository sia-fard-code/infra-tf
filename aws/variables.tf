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
    PROD-CA = "PROD-CA"
    PROD-EU = "PROD-EU"
    PROD-FR = "PROD-FR"
    DR-US   = "DR-US"
    DR-EU   = "DR-EU"
    DR-FR   = "DR-FR"
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
    PROD-CA = "ca-central-1"
    DR-EU   = "eu-west-1"
    DR-FR   = "eu-west-1"
    PROD-FR = "eu-west-3"
    PROD-US = "us-west-2"
    DR-US   = "us-east-2"
  }
}

variable "pan_env" {
  default = [
    "PROD-EU",
    "PROD-CA",
    "DR-EU",
    "DR-US"
  ]
}
variable "msn_open_env" {
  default = [
    "DEV1",
    "PROD-US",
    "QA",
    "QA0",
    "QA1"
  ]
}

variable "vpc_enabled_env" {
  default = [
    "PROD-US"
  ]
}


variable "prod_env" {
  default = [
    "PROD-EU",
    "PROD-CA",
    "PROD-US",
    "PROD-FR",
  ]
}

variable "dr_env" {
  default = [
    "DR-EU",
    "DR-US",
    "DR-CA",
    "DR-DEV",
    "DR-FR"
  ]
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
