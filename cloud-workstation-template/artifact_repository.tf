resource "google_artifact_registry_repository" "project-image-repository" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for this project."
  format        = "DOCKER"
}