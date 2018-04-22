# Exekube Base Project

> :warning: This is a work in progress

exekube/base-project is an empty Exekube project (possible `xk new` in a future release)

## Tutorial

Exekube works from within a Docker container operated via [Docker Compose](https://docs.docker.com/compose/compose-file/). All *project-scoped* configuration is inside the [`docker-compose.yaml`](https://github.com/exekube/base-project/blob/master/docker-compose.yaml) file.

### Step 0: Prerequisites

- You'll need a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you'll need to have [Docker Community Edition](https://www.docker.com/community-edition) installed

### Step 1: Set the project name on Google Cloud Platform

```yaml
# TF_VAR_project_id is used to create a GCP project for our environment
#   via the project-init script
# It's then used by modules as a space to create resources in
TF_VAR_project_id: ${ENV:?err}-demo-apps-296e23
```

### Step 2: Initialize the project on Google Cloud Platform

```sh
docker-compose run --rm xk gcp-project-init
```

### Step 3: Create networking resources for the `live/dev` environement

```sh
docker-compose run --rm xk up live/dev/infra
```

---
Below this line, we create **ephemeral** resources. You can create and destroy these resources *as often as you want*.


### Step 4: Create a Kubernetes cluster and all Kubernetes resources

```sh
docker-compose run --rm xk up
```

### Step 5: Destroy all Kubernetes resources and the cluster

```sh
docker-compose run --rm xk down
```

### Customizing the project

This project does absolutely nothing useful! You need to customize the project so that you can start taking advantage of cloud resources via Kubernetes and Terraform!
