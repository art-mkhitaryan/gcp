provider "google" {
  project     = var.gcp_project
  region      = "europe-west3"
}

terraform {
 backend "gcs" {
   bucket  = "gcp_tfstate-bucket"
   prefix  = "terraform/state"
 }
}
