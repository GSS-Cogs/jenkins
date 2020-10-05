resource "google_compute_network" "vpc" {
  name        = "${var.env}-${var.project}"
  description = "VPC for Jenkins resources"

  auto_create_subnetworks = false
  project                 = var.project
}
