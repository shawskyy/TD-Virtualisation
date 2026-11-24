output "vm_public_ips" {
  description = "IP publiques des VM"
  value       = google_compute_instance.vm[*].network_interface[0].access_config[0].nat_ip
}

output "app_dns_name" {
  description = "Nom DNS de l'application"
  value       = google_dns_record_set.app.name
}

output "db_private_ip" {
  description = "IP privée de la base de données dans le VPC"
  value       = google_sql_database_instance.db.private_ip_address
}

output "db_password" {
  description = "Mot de passe de l'utilisateur admin de la base"
  value       = random_password.db_password.result
  sensitive   = true
}
