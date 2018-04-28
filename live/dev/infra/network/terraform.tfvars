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


# dns_zones = {
#   example-com = "example.com."
# }


# dns_records = {
#   example-com = "*.example.com."
# }

