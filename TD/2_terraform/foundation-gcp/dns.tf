resource "google_dns_managed_zone" "zone" {
  name     = "td2-zone"
  dns_name = "kiowy.com."
}

resource "google_dns_record_set" "app" {
  name         = "app.${google_dns_managed_zone.zone.dns_name}"
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance.vm.network_interface[0].access_config[0].nat_ip]
}
