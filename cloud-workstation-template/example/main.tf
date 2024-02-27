module "private_cloud_workstation_instances" {
  source                                  = "../"
  project                                 = var.project
  zone                                    = var.zone
  region                                  = var.region
  vpc_network_name                        = var.vpc_network_name
  subnet_ip_cidr_range                    = var.subnet_ip_cidr_range
  vpc_sc_enabled                          = false
  gcs_bucket_name                         = var.gcs_bucket_name
  analytics_bucket_name                   = var.analytics_bucket_name
  gcs_labels                              = var.gcs_labels
  notification_channels_email             = var.notification_channels_email
  logging_project_sink_name               = var.logging_project_sink_name
  cloudbuild_repo                         = var.cloudbuild_repo
  github_pat                              = var.github_pat
  github_cloudbuild_installation_id       = var.github_cloudbuild_installation_id
  repository_id                           = var.repository_id
  vulnerability_scanning                  = var.vulnerability_scanning
  google_cloud_workstation_clusters       = var.google_cloud_workstation_clusters
  google_cloud_workstation_configurations = var.google_cloud_workstation_configurations
  google_cloud_workstations               = var.google_cloud_workstations
  project_principals                      = var.project_principals
}
