resource "google_project_service" "container_registry" {
  service = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_registry" "gcr-eu" {
  project = var.gcp_project
  location = "EU"
  depends_on = [google_project_service.container_registry]
}

resource "google_artifact_registry_repository" "gar-eu-repo" {
  location      = "europe-west3"
  repository_id = "gar-eu-repo"
  format        = "DOCKER"
}

resource "google_compute_instance" "nfs01" {
  name         = "nfs01"
  machine_type = "e2-small"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "projects/rocky-linux-cloud/global/images/rocky-linux-9-optimized-gcp-v20230912"
      size  = 30
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.private.name
  }
 
  metadata_startup_script = <<-EOF
    #!/bin/bash
    dnf install -y nfs-utils
    systemctl enable --now nfs-server rpcbind
    firewall-cmd --add-service={nfs,nfs3,mountd,rpc-bind} --permanent 
    firewall-cmd --reload
    mkdir /share
    echo "/share *(rw,sync,no_subtree_check)" > /etc/exports
    chown nobody:nobody /share
    exportfs -a
    EOF
  

  depends_on = [
    google_project_service.compute,
    google_compute_subnetwork.private,
    google_compute_network.main,
  ]
  
}