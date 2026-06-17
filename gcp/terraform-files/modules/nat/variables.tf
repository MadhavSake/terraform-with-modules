variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
  default     = "nat-router"
}

variable "nat_name" {
  description = "Name of the Cloud NAT configuration"
  type        = string
  default     = "cloud-nat"
}

variable "vpc_network" {
  description = "The VPC network to attach the router to (self_link)"
  type        = string
}

variable "region" {
  description = "The region where Cloud Router and NAT will be created"
  type        = string
}

variable "nat_ip_allocate_option" {
  description = "NAT IP allocation option (AUTO_ONLY or MANUAL_ONLY)"
  type        = string
  default     = "AUTO_ONLY"
}

variable "nat_ips" {
  description = "List of static IPs for Cloud NAT"
  type        = list(string)
  default     = []
}

variable "subnetworks_to_nat" {
  description = "List of subnetworks to NAT"
  type = list(object({
    name                    = string
    source_ip_ranges_to_nat = list(string)
  }))
  default = []
}

# Uncomment if you want to use static IPs manually
# variable "nat_ips" {
#   description = "List of static IP addresses to use for NAT"
#   type        = list(string)
#   default     = []
# }
