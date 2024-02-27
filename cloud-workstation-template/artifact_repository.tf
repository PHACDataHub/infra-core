resource "google_artifact_registry_repository" "project-image-repository" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for this project."
  format        = "DOCKER"
}

resource "google_project_service" "vulnerability_scanning" {
  count = var.vulnerability_scanning == "disabled" ? 0 : 1

  project = var.project
  service = "${var.vulnerability_scanning == "automated" ? "containerscanning" : "ondemandscanning"}.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}