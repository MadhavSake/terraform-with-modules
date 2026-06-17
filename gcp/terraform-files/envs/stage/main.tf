provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "gke_egress_ip_stage" {
  name   = "gke-egress-ip-stage"
  region = var.region
}

# Enable required APIs
module "project_services" {
  source       = "../../modules/project-services"
  enabled_apis = var.enabled_apis
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
  name_prefix   = "stage"
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

# Cloud NAT (uses static IP and scopes to private subnet)
module "nat" {
  source                 = "../../modules/nat"
  router_name            = "stage-nat-router"
  nat_name               = "stage-nat-config"
  vpc_network            = module.vpc.network_self_link
  region                 = var.region
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.gke_egress_ip_stage.self_link]

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
