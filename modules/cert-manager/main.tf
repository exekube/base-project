terraform {
  backend "gcs" {}
}

variable "secrets_dir" {}

# cert-manager Helm release
module "cert_manager" {
  source           = "/exekube-modules/helm-release"
  tiller_namespace = "kube-system"
  client_auth      = "${var.secrets_dir}/kube-system/helm-tls"

  release_name      = "cert-manager"
  release_namespace = "kube-system"

  chart_repo    = "stable"
  chart_name    = "cert-manager"
  chart_version = "0.2.8"
}

resource "null_resource" "cert_manager_resources" {
  depends_on = ["module.cert_manager"]

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/resources/"

    # command = "kubectl -n base apply -f ${var.secrets_dir}/base/letsencrypt.yaml"
  }

  provisioner "local-exec" {
    when = "destroy"

    command = "kubectl delete -f ${path.module}/resources/"

    # command = "kubectl -n base delete -f ${var.secrets_dir}/base/letsencrypt.yaml"
  }
}
