resource "google_storage_bucket" "bucket" {
  name                        = var.gcs_bucket_name
  project                     = var.project
  location                    = var.region
  labels                      = var.gcs_labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "analytics-bucket" {
  name     = "${var.project}-${var.analytics_bucket_name}"
  location = var.region
  project  = var.project
  # Enable data versioning
  versioning {
    enabled = true
  }
  # Disable public access
  public_access_prevention = "enforced"
  # Use uniform bucket-level access (i.e. all users in the GCP Project have the same access to the storage bucket)
  uniform_bucket_level_access = true
  # Do NOT force destroy buckets with data in them
  force_destroy = false
  # Use autoclass tiering of storage


}

resource "google_storage_bucket_object" "postscript" {
  name   = "post_startup_script.sh"
  source = "${path.module}/bootstrap_files/post_startup_script.sh"
  bucket = google_storage_bucket.bucket.name
}
