locals {
  default_vertex_nb_sa_roles = [
    "roles/storage.objectAdmin",
    "roles/logging.logWriter",
    "roles/artifactregistry.reader",
  ]
  vertex_nb_sa_roles = concat(local.default_vertex_nb_sa_roles)

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

resource "google_project_iam_member" "project_principals_iam" {
  for_each = { for idx, binding in local.association_list : idx => binding }
  # for_each = local.association_list
  project = var.project
  role    = each.value.role
  member  = "user:${each.value.user}"
}
