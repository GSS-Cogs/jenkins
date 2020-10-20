resource "google_compute_network" "k8s" {
  name        = "k8s"
  description = "VPC for kubernetes cluster"

  auto_create_subnetworks = false
  project                 = var.project
}


resource "google_compute_router" "nat" {
  name    = "nat"
  region  = var.region
  network = google_compute_network.k8s.name
}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  region = var.region

  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat.self_link]
  router                             = google_compute_router.nat.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_address" "nat" {
  name   = "nat"
  region = var.region
}

resource "google_compute_subnetwork" "nodes" {
  name                     = var.subnet_name
  ip_cidr_range            = var.k8s_subnetwork_nodes_cidr
  network                  = join("", google_compute_network.k8s[*].self_link)
  region                   = var.region
  private_ip_google_access = "1"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.k8s_subnetwork_pods_alias_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.k8s_subnetwork_services_alias_cidr
  }
}
