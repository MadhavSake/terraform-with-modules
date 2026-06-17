######################################
#  Fetch DB Password from Secret Manager
######################################

data "google_secret_manager_secret_version" "db_password" {
  secret  = var.db_password_secret
  version = "latest"
}

######################################
#  Cloud SQL Instance (HA Enabled)
######################################

resource "google_sql_database_instance" "instance" {
  name             = var.db_instance_name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  deletion_protection = false

  settings {
    tier = var.tier

    #  HA (Multi-zone)
    availability_type = "REGIONAL"

    disk_size       = var.disk_size
    disk_type       = var.disk_type
    disk_autoresize = true

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "12:00"
    }

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.private_network

      #  security
      ssl_mode = "ENCRYPTED_ONLY"
    }

    deletion_protection_enabled = false
  }
}

######################################
#  Database
######################################

resource "google_sql_database" "default_db" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
  project  = var.project_id
}

######################################
#  DB User
######################################

resource "google_sql_user" "db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = data.google_secret_manager_secret_version.db_password.secret_data
  project  = var.project_id
}
