resource "google_compute_router" "nat_router" {
  name    = var.router_name
  network = var.vpc_network
  region  = var.region
}

resource "google_compute_router_nat" "this" {
  name                                = var.nat_name
  router                              = google_compute_router.nat_router.name
  region                              = var.region
  nat_ip_allocate_option              = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.subnetworks_to_nat != [] ? "LIST_OF_SUBNETWORKS" : "ALL_SUBNETWORKS_ALL_IP_RANGES"

  dynamic "subnetwork" {
    for_each = var.subnetworks_to_nat
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }

  nat_ips = var.nat_ips

  log_config {
    enable = true
    filter = "ALL"
  }

  enable_endpoint_independent_mapping = true
}
