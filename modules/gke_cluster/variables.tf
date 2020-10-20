variable "project" {}

variable "env" {}

variable "region" {}

variable "network_name" {}

variable "subnet_name" {}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
