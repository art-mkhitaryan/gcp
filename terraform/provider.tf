provider "google" {
  project     = "avian-cosmos-400510"
  region      = "europe-west3"
  impersonate_service_account = var.SERVICE_ACCOUNT_KEY
}

# resource "google_storage_bucket" "gcp_tfstate-bucket" {
#   name          = "gcp_tfstate-bucket"
#   location      = "EU"
#   force_destroy = false

#   public_access_prevention = "enforced"
# }

terraform {
 backend "gcs" {
   bucket  = "gcp_tfstate-bucket"
   prefix  = "terraform/state"
 }
}