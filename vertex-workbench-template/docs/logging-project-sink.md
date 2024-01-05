# Google logging project sink

This document outlines the practices the project follows around creating a logging project sink.

### 1. Create a logging sink.

Use Terraform to create a [logging sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) that is dedicated to logs all activity to a cloud storage bucket.


```hcl
resource "google_logging_project_sink" "logging_project_sink" {
  name = "logging_project_sink"

  destination = "storage.googleapis.com/google_storage_bucket_name"

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type = gce_instance AND severity >= WARNING"

  # Use a unique writer
  unique_writer_identity = true
}
```