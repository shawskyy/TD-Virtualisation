variable "region" {
  description = "Région AWS (Paris, en Europe)"
  type        = string
  default     = "eu-west-3"
}

variable "availability_zones" {
  description = "Zones de disponibilité utilisées dans la région"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "ami_id" {
  description = "Image Debian 12 (amd64) officielle pour eu-west-3"
  type        = string
  default     = "ami-0f3f211ceb3461c37"
}

variable "vm_count" {
  description = "Nombre d'instances de la VM (haute disponibilité)"
  type        = number
  default     = 2
}
