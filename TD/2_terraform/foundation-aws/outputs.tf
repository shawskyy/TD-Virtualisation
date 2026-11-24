output "vm_public_ips" {
  description = "IP publiques des VM"
  value       = aws_instance.vm[*].public_ip
}

output "app_dns_name" {
  description = "Nom DNS de l'application"
  value       = aws_route53_record.app.fqdn
}

output "db_endpoint" {
  description = "Adresse de la base de données dans le VPC"
  value       = aws_db_instance.db.address
}

output "db_password" {
  description = "Mot de passe de l'utilisateur admin de la base"
  value       = random_password.db_password.result
  sensitive   = true
}
