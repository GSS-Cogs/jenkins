output "network_name" {
  value = google_compute_network.k8s.name
}

output "subnet_name" {
  value = google_compute_subnetwork.nodes.name
}
