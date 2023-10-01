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
 
  metadata_startup_script = "${file("install_mysql.sh")}"
  
  depends_on = [google_project_service.compute]

}
