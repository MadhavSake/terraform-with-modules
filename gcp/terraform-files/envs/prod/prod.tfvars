######################################
# Global Settings
######################################
project_id = "project"
region     = "australia-southeast1"
location   = "australia-southeast1"

######################################
# VPC Module
######################################
vpc_name     = "vpc-prod"
routing_mode = "REGIONAL"

######################################
# Subnet Module
######################################
subnet_name = "private-subnet"
subnet_cidr = "172.20.0.0/22" # unchanged, okay

private_ip_google_access = true

# Public Subnet
public_subnet_name = "public-subnet"
public_subnet_cidr = "172.20.16.0/21" # unchanged, okay

######################################
# GKE Module
######################################
cluster_name          = "project-gke-cluster-prod"
machine_type          = "e2-medium"
service_account_email = "gke-service-account-prod@project-platform.iam.gserviceaccount.com"
web_node_pool_name = "node-pool-prod"
web_node_pool_machine_type = "n2-highmem-8"
web_node_pool_machine_type_max_node_count = "3"

# GKE IP Ranges (non-overlapping)
pods_range      = "gke-pods-range"
pods_range_name = "gke-pods-range"
pods_ip_range   = "172.20.128.0/17" # updated from 172.16.128.0/17 to avoid overlap

services_range      = "gke-services-range"
services_range_name = "gke-services-range"
services_ip_range   = "172.21.0.0/19" # updated from 172.17.0.0/19 to avoid overlap

######################################
# Firewall Module
######################################
ssh_source_ip = "203.0.113.4/32"

######################################
# Static IP Module
######################################
#static_ip_names = [
#"frontend-static-ip-dev",
#"frontend-static-ip-dev"
#]

######################################
# GCR (Artifact Registry) Module
######################################
repo_name = "gke-docker-repo-prod"

######################################
# Cloud Storage Bucket Module
######################################
bucket_name = "project-state-bucket-prod"

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
