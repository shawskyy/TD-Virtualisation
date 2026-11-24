variable "project_id" {
  description = "ID du projet GCP dans lequel on déploie"
  type        = string
  default     = "polytech-dijon"
}

variable "region" {
  description = "Région GCP (en Europe, comme demandé dans le schéma)"
  type        = string
  default     = "europe-west1"
}
