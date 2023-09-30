provider "google" {
  project     = "avian-cosmos-400510"
  region      = "europe-west3"
  service_account_key = var.SERVICE_ACCOUNT_KEY
}

terraform {
 backend "gcs" {
   bucket  = "gcp_tfstate-bucket"
   prefix  = "terraform/state"
 }
}
