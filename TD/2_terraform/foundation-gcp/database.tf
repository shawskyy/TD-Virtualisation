resource "google_compute_global_address" "db_private_ip_range" {
  name          = "td2-db-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "db_private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip_range.name]
}

resource "google_sql_database_instance" "db" {
  name                = "td2-db-instance"
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false

  depends_on = [google_service_networking_connection.db_private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }
}

resource "google_sql_database" "db" {
  name     = "td2db"
  instance = google_sql_database_instance.db.name
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.db.name
  password = random_password.db_password.result
}
