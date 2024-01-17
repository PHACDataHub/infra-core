resource "google_project_service" "cloud_build_apis" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  depends_on = [ google_project_service.serviceusage_api ]

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}