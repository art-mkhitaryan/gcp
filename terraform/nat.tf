resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = "europe-west3"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]

  depends_on = [google_compute_network.main]
}

resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}

# resource "google_compute_global_address" "ucraft-app-ip" {
#   name         = "ucraft-app-ip"
#   address_type = "EXTERNAL"
#   depends_on = [google_project_service.compute]
# }

# resource "google_compute_global_address" "http-ucraft-app-ip" {
#   name         = "http-ucraft-app-ip"
#   address_type = "EXTERNAL"
#   depends_on = [google_project_service.compute]
# }