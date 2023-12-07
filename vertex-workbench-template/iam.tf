resource "google_service_account" "vertex_service_account" {
  project      = var.project
  account_id   = "vertex-nb-sa"
  display_name = "Vertex User Managed Service Account"
}