# base-project

The *base-project* is a minimal project that uses the [Exekube framework](https://github.com/exekube/exekube). You can use it as a boilerplate to jump-start your cloud projects.

```sh
git clone git@github.com:exekube/base-project.git my-new-project
cd my-new-project
```

## Full Tutorial

The project has a companion tutorial at https://docs.exekube.com/in-practice/getting-started

## Tutorial Rundown
1. `git clone https://github.com/exekube/base-project my-new-project`
2. `cd my-new-project`
3. `alias xk='docker-compose run --rm xk'`
4. `export ENV=dev`
5. `export ORGANIZATION_ID=<YOUR-GCP-ORGANIZATION-ID>`
6. `export BILLING_ID=<YOUR-GCP-BILLING-ID>`
7. In [`docker-compose.yaml`](/): `TF_VAR_project_id: <NEW-GCP-PROJECT-ID>`
8. `xk gcloud auth login`
9. `xk gcp-project-init`
10. `xk up live/dev/infra`
11. `xk up` (same as `xk up live/dev/k8s`)
12. `xk down`

## Architecture

The base-project has only 4 *project modules*:

```sh
modules/
├── administration-tasks
│   ├── main.tf
│   └── values.yaml
├── gke-cluster
│   └── main.tf
├── gke-network
│   ├── main.tf
│   └── variables.tf
└── helm-initializer
    └── main.tf
```

deployed into 1 environment (dev):

```sh
live/
├── dev
│   ├── infra
│   │   └── network
│   │       └── terraform.tfvars
│   ├── k8s
│   │   ├── cluster
│   │   │   └── terraform.tfvars
│   │   └── kube-system
│   │       ├── administration-tasks
│   │       │   └── terraform.tfvars
│   │       └── helm-initializer
│   │           └── terraform.tfvars
│   └── secrets
│       └── kube-system
│           ├── helm-tls
│           │   ├── ca.cert.pem.example
│           │   ├── helm.cert.pem.example
│           │   ├── helm.key.pem.example
│           │   ├── tiller.cert.pem.example
│           │   └── tiller.key.pem.example
│           └── owner.json.example
└── terraform.tfvars
```

> Note: Complex, production-grade cloud projects can have tens of project modules deployed into 5+ (dev, stg, prod, test, etc.) environments
