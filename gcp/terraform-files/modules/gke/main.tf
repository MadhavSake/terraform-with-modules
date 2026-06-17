resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  

  ip_allocation_policy {
    #use_ip_aliases                = true
    cluster_secondary_range_name  = var.pods_range
    services_secondary_range_name = var.services_range
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  deletion_protection = false
}

# 🔹 Default Node Pool
resource "google_container_node_pool" "default" {
  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  project    = var.project_id

  node_locations     = ["${var.region}-a"]
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    machine_type    = var.machine_type
    disk_size_gb    = 30
    service_account = var.service_account_email

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
      enable-metadata-server   = "true"
    }

    labels = {
      type = "default"
    }

    taint {
      key    = "role"
      value  = "default"
      effect = "NO_SCHEDULE"
    }
  }
}

# 🔹 Web Node Pool
resource "google_container_node_pool" "web_node_pool" {
  name       = var.web_node_pool_name
  cluster    = google_container_cluster.primary.name
  location   = var.region
  project    = var.project_id

  node_locations     = ["${var.region}-a"]
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = var.web_node_pool_machine_type_max_node_count
  }

  node_config {
    machine_type    = var.web_node_pool_machine_type
    disk_size_gb    = 100
    service_account = var.service_account_email

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
      enable-metadata-server   = "true"
    }

    labels = {
      type = "web"
    }

    tags = ["web-service"]
  }
}
