variable "mysql_secret" {
  type      = string
  sensitive = true
}

variable "gcp_project" {
  type      = string
  sensitive = true
}