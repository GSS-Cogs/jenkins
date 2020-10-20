terraform {
  required_version = ">= v0.13.2, < 0.14.0"
  backend "gcs" {
    bucket = "terraform-state-optimum-bonbon-257411"
  }
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  load_config_file = false
}

provider "google" {
  version = "3.37.0"
  project = var.project
  region  = var.region
}

module "vpc" {
  source  = "../modules/network"
  env     = var.env
  project = var.project
  region  = var.region
}

module "gke_cluster" {
  source  = "../modules/gke_cluster"
  env     = var.env
  project = var.project
  region  = var.region
  network_name = module.vpc.network_name
  subnet_name = module.vpc.subnet_name
}
