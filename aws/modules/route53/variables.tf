variable "aliases" {
  type = map(object({
    alias           = string
    parent_zone_id  = string
    target_dns_name = string
    target_zone_id  = string
  }))
}

variable "records" {
  type = map(object({
    alias          = string
    parent_zone_id = string
    type           = string
    records        = list(string)
  }))
}


/*
variable "aliases" {
  type        = list(string)
  description = "List of aliases"
  default     = []
}
variable "records" {
  type        = list(string)
  description = "List of records"
  default     = []
}

*/

variable "parent_zone_id" {
  type        = string
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  type        = string
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "private_zone" {
  type        = bool
  default     = false
  description = "Is this a private hosted zone?"
}

variable "target_dns_name" {
  type        = list(string)
  default     = []
  description = "DNS name of target resource (e.g. ALB, ELB)"
}

variable "target_zone_id" {
  type        = list(string)
  default     = [""]
  description = "ID of target resource (e.g. ALB, ELB)"
}

variable "evaluate_target_health" {
  type        = bool
  default     = false
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "enabled_alias" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources"
}

variable "enabled_record" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources"
}


variable "ipv6_enabled" {
  type        = bool
  default     = false
  description = "Set to true to enable an AAAA DNS record to be set as well as the A record"
}
variable "ignore_items" {
  type    = string
  default = ""
}
