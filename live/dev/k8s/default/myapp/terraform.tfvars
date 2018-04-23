# ↓ Module metadata
terragrunt = {
  terraform {
    source = "/project/modules//myapp"
  }

  dependencies {
    paths = [
      "../../kube-system/helm-initializer",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ↓ Module configuration (empty means all default)

