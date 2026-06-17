variable "project_id" {}
variable "region" {}
variable "cluster_name" {}
variable "network" {}
variable "subnetwork" {}
variable "pods_range" {}
variable "services_range" {}
variable "machine_type" {
  default = "e2-medium"
}
variable "service_account_email" {}
variable "web_node_pool_machine_type" {}
variable "web_node_pool_name" {}
variable "web_node_pool_machine_type_max_node_count" {}
