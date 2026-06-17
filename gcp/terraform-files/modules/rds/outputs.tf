output "instance_name" {
  value = google_sql_database_instance.instance.name
}

output "connection_name" {
  value = google_sql_database_instance.instance.connection_name
}

output "private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "self_link" {
  value = google_sql_database_instance.instance.self_link
}
