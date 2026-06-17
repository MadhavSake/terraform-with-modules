######################################
# 🌍 Global Settings
######################################
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources (e.g. asia-south1)"
  type        = string
}

variable "location" {
  description = "GCP location for resources (same as region)"
  type        = string
}

######################################
# 🔌 VPC Module
######################################
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "routing_mode" {
  description = "VPC routing mode (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"
}

######################################
# 🌐 Subnet Module
######################################
variable "subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
}

variable "private_ip_google_access" {
  description = "Enable Private Google Access on subnet"
  type        = bool
  default     = true
}

# ✅ Public Subnet
variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
}

######################################
# ☸️ GKE Module
######################################
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "machine_type" {
  description = "Machine type for GKE node pool"
  type        = string
}

variable "web_node_pool_name" {
  description = "2nd node pool name for"
  type        = string
}

variable "web_node_pool_machine_type" {
  description = "Machine type for 2nd GKE node pool"
  type        = string
}

variable "web_node_pool_machine_type_max_node_count" {
  description = "Machine type for 2nd GKE node pool"
  type        = string
}

variable "service_account_email" {
  description = "Service account email used by GKE nodes"
  type        = string
}

# GKE Pod/Service Ranges
variable "pods_range" {
  description = "Secondary IP range name for pods"
  type        = string
}

variable "services_range" {
  description = "Secondary IP range name for services"
  type        = string
}

variable "pods_range_name" {
  description = "Name of the secondary IP range for pods"
  type        = string
}

variable "pods_ip_range" {
  description = "CIDR block for pods IP range"
  type        = string
}

variable "services_range_name" {
  description = "Name of the secondary IP range for services"
  type        = string
}

variable "services_ip_range" {
  description = "CIDR block for services IP range"
  type        = string
}

######################################
# 🔥 Firewall Module
######################################
variable "ssh_source_ip" {
  description = "CIDR IP allowed for SSH access"
  type        = string
}

######################################
# 🎯 Static IP Module
######################################
# variable "static_ip_names" {
#   description = "List of static IP names to create"
#   type        = list(string)
# }

######################################
# 📦 Artifact Registry Module
######################################
variable "repo_name" {
  description = "Artifact Registry repository name"
  type        = string
}

######################################
# ☁️ Cloud Storage Bucket Module
######################################
variable "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  type        = string
}

######################################
# 🔌 Project Services Module
######################################
variable "enabled_apis" {
  description = "List of Google APIs to enable for the project"
  type        = list(string)
}

######################################
# 🐘 Cloud SQL PostgreSQL Module
######################################
# variable "zone" {
#   type = string
# }

variable "database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "PD_SSD"
}

# variable "root_password" {
#   type      = string
#   sensitive = true
# }

variable "enable_private_ip" {
  type    = bool
  default = true
}

variable "enable_public_ip" {
  type    = bool
  default = false
}

variable "deletion_protection" {
  type    = bool
  default = false
}

# variable "private_network" {
#   type = string
# }

# variable "db_name" {
#   type = string
# }

# variable "db_user" {
#   type = string
# }

# variable "db_password" {
#   type      = string
#   sensitive = true
# }

######################################
# For the SQL Peering Module
######################################
# variable "peering_range_name" {
#   description = "Name of the allocated IP range for SQL peering"
#   type        = string
# }

variable "prefix_length" {
  description = "Prefix length for peering IP range"
  type        = number
  default     = 16
}

# variable "peering_range_address" {
#   description = "Base IP address for private IP range allocation for SQL peering in dev environment"
#   type        = string
# }
