provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
module "project_services" {
  source       = "../../modules/project-services"
  enabled_apis = var.enabled_apis
}

resource "google_compute_address" "gke_egress_ip_dev" {
  name   = "gke-egress-ip-dev"
  region = var.region
}

# VPC and subnets
module "vpc" {
  source                   = "../../modules/vpc"
  vpc_name                 = var.vpc_name  
  routing_mode             = var.routing_mode
  subnet_name              = var.subnet_name
  subnet_cidr              = var.subnet_cidr
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access
  pods_range_name          = var.pods_range_name
  pods_ip_range            = var.pods_ip_range
  services_range_name      = var.services_range_name
  services_ip_range        = var.services_ip_range
  public_subnet_name       = var.public_subnet_name
  public_subnet_cidr       = var.public_subnet_cidr

  depends_on = [module.project_services]
}

# Firewall rules
module "firewall" {
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.vpc.vpc_id
  name_prefix   = "dev"
  ssh_source_ip = var.ssh_source_ip

  depends_on = [module.project_services]
}

# GKE cluster
module "gke_cluster" {
  source                = "../../modules/gke"
  project_id            = var.project_id
  region                = var.region
  cluster_name          = var.cluster_name
  network               = module.vpc.vpc_id
  subnetwork            = module.vpc.subnet_self_link
  pods_range            = module.vpc.pods_range_name
  services_range        = module.vpc.services_range_name
  machine_type          = var.machine_type
  service_account_email = var.service_account_email
  web_node_pool_machine_type = var.web_node_pool_machine_type
  web_node_pool_name = var.web_node_pool_name
  web_node_pool_machine_type_max_node_count = var.web_node_pool_machine_type_max_node_count

  depends_on = [module.project_services]
}

# Commented out: Not required
# module "cloud_sql" {
#   source           = "../../modules/cloud_sql"
#   project_id       = var.project_id
#   zone             = var.zone
#   database_version = var.database_version
#   disk_size        = var.disk_size
#   disk_type        = var.disk_type
#   root_password    = var.root_password
#   enable_private_ip = var.enable_private_ip
#   enable_public_ip = var.enable_public_ip
#   deletion_protection = var.deletion_protection
#   private_network  = var.private_network
#   db_name          = var.db_name
#   db_user          = var.db_user
#   db_password      = var.db_password
#   depends_on       = [module.sql_peering]
# }

# Cloud NAT
module "nat" {
  source                 = "../../modules/nat"
  router_name            = "dev-nat-router"
  nat_name               = "dev-nat-config"
  vpc_network            = module.vpc.network_self_link
  region                 = var.region
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.gke_egress_ip_dev.self_link]

  subnetworks_to_nat = [
    {
      # IMPORTANT: use the self_link, not just the name
      name                    = module.vpc.subnet_self_link
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  ]

  depends_on = [module.project_services]
}

# Container Registry
module "gcr" {
  source     = "../../modules/gcr"
  project_id = var.project_id
  region     = var.region
  repo_name  = var.repo_name
  depends_on = [module.project_services]
}

/*
module "static_ip" {
  source     = "../../modules/static_ip"
  project_id = var.project_id
  static_ips = var.static_ip_names
}
*/

# Commented out: Not required
# module "sql_peering" {
#   source = "../../modules/sql_peering"
#   project_id            = var.project_id
#   # region             = var.region
#   vpc_network_self_link = module.vpc.vpc_self_link
#   peering_range_name    = "sql-private-ip-range"
#   prefix_length         = 16
#   peering_range_address = var.peering_range_address
# }
