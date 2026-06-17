output "router_name" {
  description = "Name of the Cloud Router"
  value       = var.router_name
}

output "nat_name" {
  description = "Name of the Cloud NAT configuration"
  value       = google_compute_router_nat.this.name
}

output "region" {
  description = "Region of the NAT"
  value       = google_compute_router_nat.this.region
}
