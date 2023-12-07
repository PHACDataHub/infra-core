resource "google_compute_network" "vpc_network" {
  project                         = var.project
  name                            = var.vpc_network_name
  auto_create_subnetworks         = false # Do not create auto-mode subnets for this VPC
  delete_default_routes_on_create = true  # Delete all default routes (0.0.0.0/0) upon creation of the VPC
}

resource "google_compute_subnetwork" "vertex_subnetwork" {
  name                     = "${var.vpc_network_name}-vertex-subnet"
  ip_cidr_range            = var.subnet_ip_cidr_range
  region                   = var.region
  project                  = var.project
  private_ip_google_access = true                                  # When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
  network                  = google_compute_network.vpc_network.id # VPC this subnet belongs to.
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.vpc_network_name}-private-ip-alloc"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24  # VPC Peering prefix should be less than the total subnet CIDR.
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "service_peering" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
