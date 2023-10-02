resource "google_secret_manager_secret" "mysql_secret" {
  secret_id = "mysql_secret"
  
  replication {
    auto {}
  }
  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "mysql_secret" {
  secret = google_secret_manager_secret.mysql_secret.id
  secret_data = var.mysql_secret

  depends_on = [google_secret_manager_secret.mysql_secret]
}

data "google_secret_manager_secret_version" "mysql_secret" {
 secret   = "mysql_secret"

 depends_on = [google_secret_manager_secret_version.mysql_secret]
}

resource "google_compute_instance" "mysql01" {
  name         = "mysql01"
  machine_type = "e2-small"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "projects/rocky-linux-cloud/global/images/rocky-linux-9-optimized-gcp-v20230912"
      size  = 20
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.private.name
  }
 
  metadata = {
    startup-script = <<-EOF
  #!/bin/bash
  MYSQL_ROOT_PASSWORD=${data.google_secret_manager_secret_version.mysql_secret.secret_data}
  dnf install -y mysql-server
  systemctl start mysqld
  systemctl enable mysqld
  mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
  systemctl restart mysqld
  EOF
  }

  depends_on = [
    google_project_service.compute,
    google_compute_subnetwork.private,
    google_compute_network.main,
    google_secret_manager_secret_version.mysql_secret
  ]
}
