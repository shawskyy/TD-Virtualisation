# Étape 1 : le VPC qui contiendra la VM et la base de données.
resource "google_compute_network" "vpc" {
  name                    = "td2-vpc"
  auto_create_subnetworks = false
}

# Un VPC GCP est global : c'est le sous-réseau qui le place en Europe.
resource "google_compute_subnetwork" "subnet" {
  name          = "td2-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}
