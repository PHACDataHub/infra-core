resource "google_project_service" "secret_manager_apis" {
  project = var.project
  service = "secretmanager.googleapis.com"

  depends_on = [ google_project_service.serviceusage_api ]

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}
