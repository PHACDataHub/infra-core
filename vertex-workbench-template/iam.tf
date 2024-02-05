locals {
  default_vertex_nb_sa_roles = [
    "roles/storage.objectAdmin",
    "roles/logging.logWriter",
    "roles/artifactregistry.reader",
  ]
  vertex_nb_sa_roles = concat(local.default_vertex_nb_sa_roles, var.additional_vertex_nb_sa_roles)

  default_principal_roles = [
    "roles/storage.objectAdmin",
    "roles/viewer"
  ]

  service_account_principals = [for email in var.project_principals : "user:${email}"]

  association_list = flatten([
    for user in var.project_principals : [
      for role in local.default_principal_roles : {
        user = user
        role = role
      }
    ]
  ])
}

resource "google_service_account" "vertex_service_account" {
  project      = var.project
  account_id   = "vertex-nb-sa"
  display_name = "Vertex User Managed Service Account"
}

resource "google_project_iam_member" "vertex_nb_sa" {
  for_each = toset(local.vertex_nb_sa_roles)
  project  = var.project
  role     = each.key
  member   = "serviceAccount:${google_service_account.vertex_service_account.email}"
  depends_on = [
    google_service_account.vertex_service_account
  ]
}

resource "google_project_iam_member" "project_principals_iam" {
  for_each = { for idx, binding in local.association_list : idx => binding }
  # for_each = local.association_list
  project = var.project
  role    = each.value.role
  member  = "user:${each.value.user}"
}

resource "google_service_account_iam_binding" "vertex_nb_sa_principals" {
  service_account_id = google_service_account.vertex_service_account.name
  role               = "roles/iam.serviceAccountUser"
  members            = local.service_account_principals

  depends_on = [google_service_account.vertex_service_account]
}
