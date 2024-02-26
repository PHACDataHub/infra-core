# Common Variables

variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "zone" {
  description = "The GCP Zone for Vertex Notebook User-Managed Instances"
  type        = string
  default     = "northamerica-northeast1-b"
}

variable "region" {
  description = "The GCP region for the GCS bucket and Artifact Registry"
  type        = string
  default     = "northamerica-northeast1"
}

# VPC Network Variables

variable "vpc_network_name" {
  description = "The name of your VPC Network"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "The name of your VPC Subnetwork"
  type        = string
  default     = "10.0.0.0/21"
}

# DNS Variables

variable "vpc_sc_enabled" {
  description = "A boolean flag to signal whether this enviornment is inside a VPC SC Perimeter"
  type        = bool
  default     = false
}

# GCS Bucket Name

variable "gcs_bucket_name" {
  description = "Name of the GCS Bucket that will contain the post startup script"
  type        = string
}

variable "analytics_bucket_name" {
  description = "Name of the GCS Bucket for user data."
  type        = string
}

variable "gcs_labels" {
  description = "Labels to attach to the GCS Bucket. Useful for labelling resources for billing purposes"
  type        = map(string)
  default     = null
}

variable "notification_channels_email" {
  description = "Email address to send notifications for Alert Policies"
  type        = string
}

variable "logging_project_sink_name" {
  description = "Logging project sink name"
  type        = string
}

variable "google_cloud_workstation_clusters" {
  description = "A map containing properties of Google Cloud Workstation clusters to create"
  type = map(object({
    display_name = optional(string)
    labels       = map(string)
    annotations  = map(string)
  }))
}

variable "google_cloud_workstation_configurations" {
  description = "A map containing configurations for all necessary Google Cloud Workstation instances"
  type = map(object({
    display_name           = optional(string)
    workstation_cluster_id = string
    idle_timeout           = string
    running_timeout        = string
    replica_zones          = optional(list(string), [])
    annotations            = optional(map(string), {})
    labels                 = optional(map(string), {})
    host = object({
      gce_instance = object({
        machine_type      = optional(string)
        boot_disk_size_gb = optional(number)
        service_account   = string
        pool_size         = optional(string, 0)
      })
    })
    container = object({
      image       = string
      command     = optional(list(string), [])
      args        = optional(list(string), [])
      working_dir = optional(string)
      env         = optional(map(string), {})
      run_as_user = optional(string)
    })
  }))
}

variable "google_cloud_workstations" {
  description = "A map containing properties for every instance of Google Cloud Workstation to create"
  type = map(object({
    display_name           = optional(string)
    workstation_cluster_id = string
    workstation_config_id  = string
    labels                 = map(string)
    env                    = map(string)
    annotations            = map(string)
  }))
}

variable "project_principals" {
  description = "List of principals who will access the resources in the project"
  type        = list(string)
}

# Cloud Build variables

variable "cloudbuild_repo" {
  description = "GitHub repository where the RStudio image is specified"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_cloudbuild_installation_id" {
  description = "Installation ID of Cloud Build GitHub application."
  type        = string
}

variable "repository_id" {
  description = "The GCP Artifact Registry repository to create for the project."
  type        = string
}