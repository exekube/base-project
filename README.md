# Exekube Base Project

> :warning: This is a work in progress

The *Base Project* deploys a completely empty Exekube project onto the Google Cloud Platform. You can clone this project and add modules to customize it.

## What we're building

The goal of this minimal project is to see the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) of our cluster:

<p align="center">
  <img src="/screenshot.png" alt="The final result of the tutorial: nothing (a Kubernetes dashboard)."/>
</p>

## Table of Contents

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Exekube Base Project](#exekube-base-project)
	- [Table of Contents](#table-of-contents)
	- [Terraform Modules](#terraform-modules)
	- [Tutorial](#tutorial)
		- [Step 0: Prerequisites](#step-0-prerequisites)
		- [Step 1: Set the Google Cloud Platform *project name base*](#step-1-set-the-google-cloud-platform-project-name-base)
		- [Step 2: Initialize the project on Google Cloud Platform](#step-2-initialize-the-project-on-google-cloud-platform)
		- [Step 3: Create networking resources for the `live/dev` environement](#step-3-create-networking-resources-for-the-livedev-environement)
		- [Step 4: Create a Kubernetes cluster and all Kubernetes resources](#step-4-create-a-kubernetes-cluster-and-all-kubernetes-resources)
		- [Step 5: Destroy all Kubernetes resources and the cluster](#step-5-destroy-all-kubernetes-resources-and-the-cluster)
		- [Customizing the project](#customizing-the-project)

<!-- /TOC -->

## Terraform Modules

| Module | Version | Notes |
| --- | --- | --- |
| gcp-secret-mgmt | 0.3.0-google (unreleased) | Create GCS buckets and Cloud KMS encryption keys for storing secrets for an environment of the project |
| gke-network | 0.3.0-google (unreleased) | Create a network / subnets / static IP addresses / DNS zones and records |
| gke-cluster | 0.3.0-google (unreleased) | Create a Google Kubernetes Engine cluster `v1.9.6-gke.1`  |
| administration-tasks | 0.3.0-google (unreleased) | Install chart for managing common cluster administration tasks  |
| helm-initializer | 0.3.0-google (unreleased) | Securely install Tiller into any namespace (using mutual TLS authentication)  |
| cert-manager | 0.3.0-google (unreleased) | Manage TLS certificate issuers and certificates (including Let's Encrypt certs for ingress!) |

## Tutorial

> Exekube works from within a Docker container operated by [Docker Compose](https://docs.docker.com/compose/compose-file/). The container can be configured via the [`docker-compose.yaml`](https://github.com/exekube/base-project/blob/master/docker-compose.yaml) file.

### Step 0: Prerequisites

- You'll need a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you'll need to have [Docker Community Edition](https://www.docker.com/community-edition) installed

### Step 1: Set the Google Cloud Platform *project name base*

```yaml
TF_VAR_project_id: ${ENV:?err}-demo-apps-296e23
```

### Step 2: Initialize the live/dev environment on Google Cloud Platform

2a. Login into your account on the Google Cloud Platform:

```sh
docker-compose run --rm xk gcloud auth login
```

2b. Set variables for your live/dev environment:

```sh
export ORGANIZATION_ID=<your-gcp-organization-id>
export BILLING_ID=<your-gcp-billing-id>
export ENV=dev
```

2c. Initialize the live/dev environment:

```sh
docker-compose run --rm xk gcp-project-init
```

### Step 3: Create networking resources for the live/dev environement

```sh
docker-compose run --rm xk up live/dev/infra
```

---
⬇️ Below this line, we create **ephemeral** resources. You can create and destroy these resources *as often as you want* ⬇️

---

### Step 4: Create a Kubernetes cluster and all Kubernetes resources

4a. Create all resources:

```sh
docker-compose run --rm xk up
```

4b. Launch a `kubectl proxy` for your GKE cluster:

```sh
docker-compose up
```

4c. Go to your cluster dashboard: <http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/>

### Step 5: Destroy all Kubernetes resources and the cluster

```sh
docker-compose run --rm xk down
```

### Customizing the project

This project does absolutely nothing useful! You need to customize the project so that you can start taking advantage of cloud resources via Kubernetes and Terraform!
