# Étape 0 : on déclare à Terraform quel provider il doit télécharger et utiliser.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project      = "polytech-dijon"
  region       = "europe-west1"
  access_token = "patate"
}
