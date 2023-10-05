resource "google_compute_firewall" "allow-all-from-main-network" {
  name    = "allow-all-from-main-network"
  network = google_compute_network.main.name

  allow {
    protocol = "all"
    ports    = []
  }

   source_ranges = ["141.136.90.244/32" , "10.0.0.0/8"]
   
}

resource "google_compute_firewall" "allow-ssh-from-clonsole" {
  name    = "allow-ssh-from-clonsole"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

   source_ranges = ["35.235.240.0/20"]
   
}

