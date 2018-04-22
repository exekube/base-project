# ↓ Module metadata

terragrunt = {
  terraform {
    source = "/project/modules//gke-network"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ↓ Module configuration (empty means all default)

# Comment out to create a regional static IP for nginx / istio / traefic ingress
create_static_ip_address = false

# dns_zones = {
#   example-com = "example.com."
# }

dns_records = {
  example-com = "*.example.com."
}
