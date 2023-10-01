# read latest password version from secret manager
data "google_secret_manager_secret_version" "passwd" {
 secret   = "MYSQL_ROOT_PASSWORD"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_compute_instance" "mysql-test" {
  name         = "mysql-test"
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
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
 
  metadata = {
    startup-script = <<-EOF
  #!/bin/bash
  MYSQL_ROOT_PASSWORD=${data.google_secret_manager_secret_version.passwd.secret_data}
  echo $MYSQL_ROOT_PASSWORD >> /var/log/install_mysql_script.log
  dnf install -y mysql-server
  systemctl start mysqld
  systemctl enable mysqld
  mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
  systemctl restart mysqld
  EOF
  }
  depends_on = [google_project_service.compute]

}
