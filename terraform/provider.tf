provider "google" {
  project     = "avian-cosmos-400510"
  region      = "europe-west3"
}

terraform {
 backend "gcs" {
   bucket  = "gcp_tfstate-bucket"
   prefix  = "terraform/state"
 }
}
