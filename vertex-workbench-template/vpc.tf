resource "google_compute_network" "vpc_network" {
  project                         = var.project
  name                            = var.vpc_network_name
  auto_create_subnetworks         = false # Do not create auto-mode subnets for this VPC
  delete_default_routes_on_create = true  # Delete all default routes (0.0.0.0/0) upon creation of the VPC
}