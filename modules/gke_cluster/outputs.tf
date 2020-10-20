output "kubernetes_cluster_name" {
  value       = google_container_cluster.jenkins.name
  description = "GKE Cluster Name"
}

output "public_endpoint" {
  value = google_container_cluster.jenkins.endpoint
}
