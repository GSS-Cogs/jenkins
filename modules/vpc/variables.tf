variable "project" {}

variable "env" {}

variable "region" {}

variable "subnet_name" {
  default = "nodes"
}

variable "k8s_subnetwork_nodes_cidr" {
  default = "10.110.0.0/16"
}

variable "k8s_subnetwork_pods_alias_cidr" {
  default = "10.120.0.0/16"
}

variable "k8s_subnetwork_services_alias_cidr" {
  default = "10.130.0.0/16"
}
