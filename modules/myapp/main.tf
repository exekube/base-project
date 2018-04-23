terraform {
  backend "gcs" {}
}

variable "secrets_dir" {}

module "myapp" {
  source           = "/exekube-modules/helm-release"
  tiller_namespace = "kube-system"
  client_auth      = "${var.secrets_dir}/kube-system/helm-tls"

  release_name      = "myapp"
  release_namespace = "default"

  chart_name = "nginx-app/"
}
