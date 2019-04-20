terraform {
  backend "gcs" {}
}

variable "project_id" {}
variable "serviceaccount_key" {}

module "gke_cluster" {
  source             = "/exekube-modules/gke-cluster"
  project_id         = "${var.project_id}"
  serviceaccount_key = "${var.serviceaccount_key}"

  initial_node_count = 2
  node_type          = "g1-small"
  kubernetes_version = "1.12.7-gke.7"

  master_auth_username = ""
  master_auth_password = ""

  issue_client_certificate = false

  main_compute_zone = "europe-north1-a"
  additional_zones  = []

  oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}
