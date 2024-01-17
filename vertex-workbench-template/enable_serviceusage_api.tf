resource "google_project_service" "serviceusage_api" {
  project = var.project
  service = "serviceusage.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}