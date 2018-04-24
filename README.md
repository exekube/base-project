# base-project

> :warning:
>
> This is a work in progress
>
> :warning:

The *base-project* is a minimal project that uses the [Exekube framework](https://github.com/exekube/exekube).

```sh
git clone git@github.com:exekube/base-project.git my-new-project
cd my-new-project
```

## What we're building

The goal of this minimal project is to see the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) of our cluster. Closer to the end of this tutorial, we'll also author a new Terraform module for the project: an nginx app called *myapp*.

<p align="center">
  <img src="/screenshot.png" alt="The final result of the tutorial: nothing (a Kubernetes dashboard)."/>
</p>

## Table of Contents

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [base-project](#base-project)
	- [What we're building](#what-were-building)
	- [Table of Contents](#table-of-contents)
	- [Terraform Modules](#terraform-modules)
	- [Tutorial](#tutorial)
		- [Step 0: Prerequisites](#step-0-prerequisites)
		- [Step 1: Set the Google Cloud Platform project name base](#step-1-set-the-google-cloud-platform-project-name-base)
		- [Step 2: Initialize the live/dev environment on Google Cloud Platform:](#step-2-initialize-the-livedev-environment-on-google-cloud-platform)
		- [Step 3: Create networking resources for the live/dev environement](#step-3-create-networking-resources-for-the-livedev-environement)
		- [Step 4: Create a Kubernetes cluster and all Kubernetes resources](#step-4-create-a-kubernetes-cluster-and-all-kubernetes-resources)
		- [Step 5: (Optional) Deploy an nginx app](#step-5-optional-deploy-an-nginx-app)
		- [Step 6: Destroy all Kubernetes resources and the cluster](#step-6-destroy-all-kubernetes-resources-and-the-cluster)

<!-- /TOC -->

## Terraform Modules

| Module | Version | Notes |
| --- | --- | --- |
| gcp-secret-mgmt | 0.3.0-google | Create GCS buckets and Cloud KMS encryption keys for storing secrets for an environment of the project |
| gke-network | 0.3.0-google | Create a network / subnets / static IP addresses / DNS zones and records |
| gke-cluster | 0.3.0-google | Create a Google Kubernetes Engine cluster `v1.9.6-gke.1`  |
| administration-tasks | 0.3.0-google | Install chart for managing common cluster administration tasks  |
| helm-initializer | 0.3.0-google | Securely install Tiller into any namespace (using mutual TLS authentication)  |
| cert-manager | 0.3.0-google | Manage TLS certificate issuers and certificates (including Let's Encrypt certs for ingress!) |

## Tutorial

> Exekube works from within a Docker container operated by [Docker Compose](https://docs.docker.com/compose/compose-file/). The container can be configured via the [`docker-compose.yaml`](https://github.com/exekube/base-project/blob/master/docker-compose.yaml) file.

### Step 0: Prerequisites

- You'll need a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you'll need to have [Docker Community Edition](https://www.docker.com/community-edition) installed

### Step 1: Set the Google Cloud Platform project name base

We'll create a unique GCP project for every *environment* (dev, stg, prod). Set the *project name base* in `docker-compose.yaml`:

```yaml
TF_VAR_project_id: ${ENV}-demo-apps-296e23
```

### Step 2: Initialize the live/dev environment on Google Cloud Platform:

2a. Set variables for the project's live/dev environment (in your shell):

```sh
export ORGANIZATION_ID=<your-gcp-organization-id>
export BILLING_ID=<your-gcp-billing-id>
export ENV=dev
```

2b. Login into your account on the Google Cloud Platform:

```sh
docker-compose run --rm xk gcloud auth login
```

> All gcloud config be saved to `.config/dev/gcloud`. This is configured via the `docker-compose.yaml` file.

2c. Initialize the live/dev environment:

```sh
docker-compose run --rm xk gcp-project-init
```

### Step 3: Create networking resources for the live/dev environement

```sh
docker-compose run --rm xk up live/dev/infra
```

### Step 4: Create a Kubernetes cluster and all Kubernetes resources

4a. Create all resources:

```sh
docker-compose run --rm xk up
```

4b. Launch a `kubectl proxy` for the cluster:

```sh
docker-compose up -d
```

4c. Go to your cluster dashboard: <http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/>

### Step 5: (Optional) Deploy an nginx app

Let's add a basic Terraform module and a Helm chart to deploy *myapp*, an nginx app, into our Kubernetes cluster:

1. First, let's create the project module:
    ```sh
    mkdir modules/myapp
    touch modules/myapp/main.tf
    ```
    ```tf
    # modules/myapp/main.tf
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
    ```

2. Next, we will create a local Helm chart and release values for it:

    ```sh
    # Create a brand-new Helm chart
    docker-compose run --rm xk helm create nginx-app

    # Move the chart into modules/myapp
    mv nginx-app modules/myapp/

    # Create values.yaml for myapp Helm release
    cp modules/myapp/nginx-app/values.yaml modules/myapp/
    ```

3. Add the module into live/dev environment:
    ```sh
    mkdir -p live/dev/k8s/default/myapp
    touch live/dev/k8s/default/myapp/terraform.tvars
    ```
    ```tf
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
    ```

4. Update your cluster:
    ```sh
    docker-compose run --rm xk up
    ```

5. Go to <http://localhost:8001/api/v1/namespaces/default/services/myapp-nginx-app:80/proxy/>

### Step 6: Destroy all Kubernetes resources and the cluster

```sh
docker-compose run --rm xk down
```
