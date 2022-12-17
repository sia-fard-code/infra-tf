variable "allowed_cidr" {
  type = list(string)

  default = [
    "0.0.0.0/0",
  ]

  description = "A list of CIDR Networks to allow ssh access to."
}


variable "vpc_id" {
}
variable "msn_open_env" {
  default = ""
}

variable "pan_env" {
  default = ""
}
variable "env" {
  default = "dev"
}

variable "msn_svc_enabled" {
  default = false
}

variable "msn_open_enabled" {
  default = false
}

variable "msn_th_enabled" {
  default = false
}
