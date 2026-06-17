######################################
#  Environment
######################################
variable "env" {
  description = "Environment (test, sample)"
  type        = string
}

######################################
#  Global Settings
######################################
variable "project_id" { type = string }
variable "region"     { type = string }
variable "location"   { type = string }

######################################
#  VPC
######################################
variable "routing_mode" {
  type    = string
  default = "REGIONAL"
}

######################################
#  Subnet
######################################
variable "subnet_cidr" { type = string }

variable "private_ip_google_access" {
  type    = bool
  default = true
}

variable "public_subnet_cidr" { type = string }

######################################
#  GKE
######################################
variable "machine_type" { type = string }

variable "web_node_pool_machine_type" { type = string }

variable "web_node_pool_machine_type_max_node_count" {
  type = string
}

variable "pods_range_name" { type = string }
variable "pods_ip_range"   { type = string }

variable "services_range_name" { type = string }
variable "services_ip_range"   { type = string }

variable "service_account_email" {
  description = "Service account for GKE nodes"
  type        = string
}

######################################
#  Firewall
######################################
variable "ssh_source_ip" { type = string }

######################################
#  Project Services
######################################
variable "enabled_apis" {
  type = list(string)
}

######################################
#  Cloud SQL
######################################
variable "db_name" { type = string }
variable "db_user" { type = string }

variable "database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "disk_type" {
  type    = string
  default = "PD_SSD"
}

variable "enable_public_ip" {
  type    = bool
  default = false
}

variable "deletion_protection" {
  type    = bool
  default = false
}
