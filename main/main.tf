terraform {
  required_version = ">= v0.13.2, < 0.14.0"
  backend "gcs" {
    bucket = "terraform-state-optimum-bonbon-257411"
  }
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
