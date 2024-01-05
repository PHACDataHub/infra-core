resource "google_logging_project_sink" "logging_project_sink" {
  project                = var.project
  name                   = var.logging_project_sink_name
  destination            = "storage.googleapis.com/${google_storage_bucket.bucket.name}"
  filter                 = "resource.type = gce_instance AND severity >= WARNING"
  unique_writer_identity = true
}
