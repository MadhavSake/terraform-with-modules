######################################
#  Environment #
######################################
env = "test"

######################################
#  Global Settings #
######################################
project_id = "project-platform"
region     = "asia-south2"
location   = "asia-south2"

######################################
#  VPC Module #
######################################
routing_mode = "REGIONAL"

######################################
#  Subnet Module
######################################
subnet_cidr = "172.20.0.0/22"

private_ip_google_access = true

public_subnet_cidr = "172.20.16.0/21"

######################################
#  GKE Module
######################################
machine_type = "e2-medium"

web_node_pool_machine_type                = "e2-medium"
web_node_pool_machine_type_max_node_count = "1"
service_account_email = "gke-service-account-test@project-platform.iam.gserviceaccount.com"

# GKE IP Ranges
pods_range_name = "gke-pods-range"
pods_ip_range   = "172.20.128.0/17"

services_range_name = "gke-services-range"
services_ip_range   = "172.21.0.0/19"

######################################
#  Firewall Module
######################################
ssh_source_ip = "172.20.0.0/22"

######################################
#  Artifact Registry Module
######################################
# (name handled via locals)

######################################
#  Project Services Module
######################################
enabled_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "sqladmin.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "iam.googleapis.com",
  "certificatemanager.googleapis.com",
  "servicenetworking.googleapis.com",
  "secretmanager.googleapis.com"
]

######################################
#  Cloud SQL PostgreSQL
######################################
db_name = "testdb"
db_user = "testuser"
