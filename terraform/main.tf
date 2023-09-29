provider "google" {
  project     = "avian-cosmos-400510"
  region      = "europe-west3"
}

resource "google_storage_bucket" "gcp_tfstate" {
  name          = "gcp_tfstate-bucket"
  location      = "EU"
  force_destroy = true

  public_access_prevention = "enforced"
}

terraform {
 backend "gcs" {
   bucket  = "gcp_tfstate-bucket"
   prefix  = "terraform/state"
 }
}