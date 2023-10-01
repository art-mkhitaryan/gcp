resource "google_secret_manager_secret" "mysql_secret" {
  secret_id = "mysql_secret"

}

resource "google_secret_manager_secret_version" "mysql_secret" {
  secret = google_secret_manager_secret.mysql_secret.id
  secret_data = var.mysql_secret
}

data "google_secret_manager_secret_version" "mysql_secret" {
 secret   = "mysql_secret"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_compute_instance" "mysql_01" {
  name         = "mysql_01"
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
    network = "main"
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

  depends_on = [google_secret_manager_secret_version.mysql_secret]

}
