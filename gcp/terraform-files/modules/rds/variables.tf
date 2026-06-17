######################################
# Cloud SQL Variables
######################################

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for Cloud SQL"
  type        = string
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Instance tier"
  type        = string
  default     = "db-custom-2-4096"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "PD_SSD"
}

variable "enable_public_ip" {
  description = "Enable public IP"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "VPC self link"
  type        = string
}

variable "deletion_protection" {
  description = "Deletion protection"
  type        = bool
  default     = false
}

variable "db_instance_name" {
  description = "Instance name"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password_secret" {
  description = "Secret Manager secret name"
  type        = string
}
