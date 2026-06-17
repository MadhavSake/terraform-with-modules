######################################
# Global Settings
######################################
project_id = "project-platform"
region     = "australia-southeast2"
location   = "australia-southeast2"

######################################
# VPC Module
######################################
vpc_name     = "project-vpc-stage"
routing_mode = "REGIONAL"

######################################
# Subnet Module
######################################
subnet_name = "private-subnet"
subnet_cidr = "172.20.0.0/22"

private_ip_google_access = true

# Public Subnet
public_subnet_name = "public-subnet"
public_subnet_cidr = "172.20.16.0/21"

######################################
# GKE Module
######################################
cluster_name          = "project-gke-cluster-stage"
machine_type          = "e2-medium"
service_account_email = "gke-service-account-stage@project-platform.iam.gserviceaccount.com"
web_node_pool_name = "node-pool-stage"
web_node_pool_machine_type = "n2-highmem-8"
web_node_pool_machine_type_max_node_count = "10"

# GKE IP Ranges (non-overlapping)
pods_range      = "gke-pods-range"
pods_range_name = "gke-pods-range"
pods_ip_range   = "172.20.128.0/17"

services_range      = "gke-services-range"
services_range_name = "gke-services-range"
services_ip_range   = "172.21.0.0/19"

######################################
# Firewall Module
######################################
ssh_source_ip = "203.0.113.4/32"

######################################
# GCR (Artifact Registry) Module
######################################
repo_name = "gke-docker-repo-stage"

######################################
# Cloud Storage Bucket Module
######################################
bucket_name = "project-state-bucket"

######################################
# Project Services Module
######################################
enabled_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "sqladmin.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "iam.googleapis.com",
  "certificatemanager.googleapis.com"
]

######################################
# (Removed) Cloud NAT Configuration
######################################
# NAT is configured inline in module "nat" in main.tf.
