######################################
#  Provider #
######################################
provider "google" {
  project = var.project_id
  region  = var.region
}

######################################
#  Locals ( IMPORTANT)
######################################
locals {
  name_prefix = "agrichain-${var.env}"
}

######################################
#  Static IP for NAT
######################################
resource "google_compute_address" "gke_egress_ip" {
  name   = "${local.name_prefix}-egress-ip"
  region = var.region
}

######################################
#  Enable APIs
######################################
module "project_services" {
  source       = "../../modules/project-services"
  enabled_apis = var.enabled_apis
}

######################################
#  VPC
######################################
module "vpc" {
  source       = "../../modules/vpc"
  vpc_name     = "${local.name_prefix}-vpc"
  routing_mode = var.routing_mode

  subnet_name              = "${local.name_prefix}-private-subnet"
  subnet_cidr              = var.subnet_cidr
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access

  public_subnet_name = "${local.name_prefix}-public-subnet"
  public_subnet_cidr = var.public_subnet_cidr

  pods_range_name     = var.pods_range_name
  pods_ip_range       = var.pods_ip_range
  services_range_name = var.services_range_name
  services_ip_range   = var.services_ip_range

  depends_on = [module.project_services]
}

######################################
#  Firewall
######################################
module "firewall" {
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.vpc.vpc_id
  name_prefix   = local.name_prefix
  ssh_source_ip = var.ssh_source_ip

  depends_on = [module.project_services]
}

######################################
#  GKE
######################################
module "gke_cluster" {
  source     = "../../modules/gke"
  project_id = var.project_id
  region     = var.region

  cluster_name          = "${local.name_prefix}-gke"
  network               = module.vpc.vpc_id
  subnetwork            = module.vpc.subnet_self_link
  pods_range            = module.vpc.pods_range_name
  services_range        = module.vpc.services_range_name
  machine_type          = var.machine_type
  service_account_email = var.service_account_email

  web_node_pool_name                        = "${local.name_prefix}-web-node"
  web_node_pool_machine_type                = var.web_node_pool_machine_type
  web_node_pool_machine_type_max_node_count = var.web_node_pool_machine_type_max_node_count

  depends_on = [module.project_services]
}

######################################
#  NAT
######################################
module "nat" {
  source      = "../../modules/nat"
  router_name = "${local.name_prefix}-nat-router"
  nat_name    = "${local.name_prefix}-nat"

  vpc_network = module.vpc.network_self_link
  region      = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.gke_egress_ip.self_link]

  subnetworks_to_nat = [
    {
      name                    = module.vpc.subnet_self_link
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  ]

  depends_on = [module.project_services]
}

######################################
#  Artifact Registry
######################################
module "gcr" {
  source     = "../../modules/gcr"
  project_id = var.project_id
  region     = var.region
  repo_name  = "${local.name_prefix}-repo"

  depends_on = [module.project_services]
}

######################################
#  Private Service Access
######################################
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-${local.name_prefix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

######################################
#  Cloud SQL
######################################
module "rds" {
  source = "../../modules/rds"

  project_id = var.project_id
  region     = var.region

  db_instance_name = "${local.name_prefix}-postgres"
  db_name          = var.db_name
  db_user          = var.db_user

  db_password_secret = "${local.name_prefix}-db-password"

  private_network = module.vpc.network_self_link

  database_version    = var.database_version
  disk_size           = var.disk_size
  disk_type           = var.disk_type
  enable_public_ip    = var.enable_public_ip
  deletion_protection = var.deletion_protection

  depends_on = [
    module.vpc,
    google_service_networking_connection.private_vpc_connection
  ]
}
