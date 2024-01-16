resource "google_cloudbuild_trigger" "build_trigger" {
  for_each = var.cloudbuild_triggers

  project       = var.project
  name          = each.key
  location      = var.region
  description   = each.value.description
  tags          = each.value.tags
  disabled      = false
  service_account = each.value.service_account

  git_file_source {
    path     = each.value.git_file_source.path
    repo_type = each.value.git_file_source.repo_type
  }

  github {
    owner = each.value.github.owner
    name  = each.value.github.repository

    dynamic "pull_request" {
      for_each = each.value.github.pull_request != null ? [each.value.github.pull_request] : []

      content {
        branch         = pull_request.value.branch
        invert_regex   = pull_request.value.invert_regex
        comment_control = pull_request.value.comment_control
      }
    }

    dynamic "push" {
      for_each = each.value.github.push != null ? [each.value.github.push] : []

      content {
        branch       = push.value.branch
        tag          = push.value.tag
        invert_regex = push.value.invert_regex
      }
    }
  }
}
