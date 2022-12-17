locals {
  private_subnets  = [cidrsubnet(var.vpc_cidr, 7, 0), cidrsubnet(var.vpc_cidr, 7, 1), cidrsubnet(var.vpc_cidr, 7, 2), cidrsubnet(var.vpc_cidr, 7, 3), cidrsubnet(var.vpc_cidr, 9, 55), cidrsubnet(var.vpc_cidr, 9, 56)]
  database_subnets = [cidrsubnet(var.vpc_cidr, 7, 4), cidrsubnet(var.vpc_cidr, 7, 5)]
  public_subnets   = [cidrsubnet(var.vpc_cidr, 7, 6), cidrsubnet(var.vpc_cidr, 7, 7)]
  pan_subnets      = [cidrsubnet(var.vpc_cidr, 9, 50), cidrsubnet(var.vpc_cidr, 9, 51)]
  azs              = [var.azs_a, var.azs_b]
}


variable "pan_env" {
  default = [
    "QA0"
  ]
}


variable "vpc_cidr" {
  type = string
}
variable "rke_cluster_id" {
  default = "rke-tf"
}

variable "security_group_ids" {
  default = ""
}


variable "cluster_name" {
  type    = string
  default = "test-k8s"
}


variable "vpc_name" {
  default = "dc-us-vpc"
}

variable "azs_a" {
  type = string
}

variable "azs_b" {
  type = string
}

variable "azs_c" {
  type = string
}


variable "open_cidr" {
  default = "0.0.0.0/0"
}

variable "vpn_ext_cidr" {
  default = "52.33.22.34/32"
}

variable "vpn_remote_int_cidr" {
  default = "10.220.0.0/16"
}

variable "site-to-site-vpn-local-cidr" {
  default = "13.228.179.245/32"
}

variable "site-to-site-vpn-remote-cidr" {
  default = "34.211.31.64/32"
}

variable "env" {
  default = "dev"
}

variable "vpc_disabled_env" {
  default = [
    "PROD-US"
  ]
}


