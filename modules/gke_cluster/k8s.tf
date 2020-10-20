# GKE cluster
resource "google_container_cluster" "jenkins" {
  name     = "jenkins"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnet_name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "jenkins" {
  name       = google_container_cluster.jenkins.name
  location   = var.region
  cluster    = google_container_cluster.jenkins.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.env
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["web", "gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
