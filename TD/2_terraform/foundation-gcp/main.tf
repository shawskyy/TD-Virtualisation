resource "google_compute_network" "vpc" {
  name                    = "td2-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "td2-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_instance" "vm" {
  count = var.vm_count

  name         = "td2-vm-${count.index}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }
}

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

resource "google_dns_managed_zone" "zone" {
  name     = "td2-zone"
  dns_name = "kiowy.com."
}

resource "google_dns_record_set" "app" {
  name         = "app.${google_dns_managed_zone.zone.dns_name}"
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = google_compute_instance.vm[*].network_interface[0].access_config[0].nat_ip
}
