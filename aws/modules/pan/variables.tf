variable "plan" {
  type = map(object({
    mgt_subnet_id      = string
    pub_subnet_id      = string
    app_subnet_id      = string
    db_subnet_id      = string
    sub1_subnet_id      = string
    app_route_table_id = list(string)
    sub1_route_table_id = list(string)
    sequence           = string
  }))
}

# variable "pan_folders" {
#   default = [
#     "config/",
#     "content/",
#     "license/",
#     "software/"
#   ]
# }

# variable "files_to_upload" {
#   type = list(string)
# }

variable "pan_env" {
  default = [
    "QA0"
  ]
}

data "aws_availability_zones" "available" {}
variable "region" {
  default = ""
}
variable "vpc_id" {
  default = ""
}
variable "vpc_cidr" {
}

variable "server_key_name" {
  default = ""
}
variable "instance_size" {
  default = ""
}
variable "volume_size" {
  default = ""
}
variable "pan_pub_sg" {
  default = ""
}
variable "pan_prv_sg" {
  default = ""
}
variable "name" {
  default = "Palo Alto"
}
variable "bucket_name" {
  default = ""
}
variable "pan_fw_region_map" {
  default = {
    us-west-2    = "ami-004065389303a6ada",
    us-east-2    = "ami-02a6e3a3db23bef95"
    eu-central-1 = "ami-0650e21e30a07335d"
    eu-west-1    = "ami-01ba9318a26544dfa"
    ca-central-1 = "ami-0d4e1ef886083f3aa"
    us-west-1    = "ami-090762cb90892c713"
  }
}
variable "env" {
  default = ""
}

