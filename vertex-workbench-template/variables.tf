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

# Notebooks Variables

variable "notebooks" {
  description = "A map containing the containing the configuration for the desired Vertex AI Workbench User-Managed Notebooks"
  type = map(object({
    labels         = map(string),
    instance_owner = string,
    metadata       = map(string),
    type           = string,
    access_type    = optional(string)
  }))
  default = {}
}

variable "image_project" {
  description = "GCP Project conataining VM image for the Notebook instances"
  type        = string
  default     = "deeplearning-platform-release"
}

variable "image_family" {
  description = "Image family for the Notebook instances (https://cloud.google.com/compute/docs/images)"
  type        = string
  default     = "tf-2-3-cpu"
}

variable "machine_type" {
  description = "The Notebook Instance's machine type"
  type        = string
  default     = "n1-standard-4"
}

variable "boot_disk_type" {
  description = "Boot disk type for notebook instances. Possible values are DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD and PD_BALANCED"
  type        = string
  default     = "PD_STANDARD"
}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB attached to notebook instances, up to a maximum of 64 TB. The minimum recommended value is 100GB."
  type        = number
  default     = 100
}

variable "data_disk_size_gb" {
  description = "The size of the data disk in GB attached to notebook instances, up to a maximum of 64 TB. You can choose the size of the data disk based on how big your notebooks and data are."
  type        = number
  default     = 100
}

variable "no_remove_data_disk" {
  description = "If true, the data disk will not be auto deleted when deleting the instance."
  type        = bool
  default     = true
}

variable "install_gpu_driver" {
  description = "Whether the end user authorizes Google Cloud to install GPU driver on this instance. If this field is empty or set to false, the GPU driver won't be installed. Only applicable to instances with GPUs."
  type        = string
  default     = false
}

variable "accelerator_type" {
  description = "Type of accelerator. Possible values are ACCELERATOR_TYPE_UNSPECIFIED, NVIDIA_TESLA_K80, NVIDIA_TESLA_P100, NVIDIA_TESLA_V100, NVIDIA_TESLA_P4, NVIDIA_TESLA_T4, NVIDIA_TESLA_T4_VWS, NVIDIA_TESLA_P100_VWS, NVIDIA_TESLA_P4_VWS, NVIDIA_TESLA_A100, TPU_V2, and TPU_V3"
  type        = string
  default     = "ACCELERATOR_TYPE_UNSPECIFIED"
}


variable "accelerator_core_count" {
  description = "Count cores of accelerator."
  type        = number
  default     = 1
}

variable "access_type" {
  description = "Access type for Runtime Notebooks. Possible values are SINGLE_USER, SERVICE_ACCOUNT and RUNTIME_ACCESS_TYPE_UNSPECIFIED"
  type        = string
  default     = "SINGLE_USER"
}

# IAM Variables

variable "additional_vertex_nb_sa_roles" {
  description = "Additional roles that you may want to assign to the Vertex AI NB SA"
  type        = list(string)
  default     = []
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

# Firewall Rules Variables

variable "additional_fw_rules" {
  description = "Additional firewall rules that you may want to create to allow other traffic"
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = optional(object({
      metadata = string
    }))
  }))
  default = []
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

variable "workstation_users" {
  description = "List of workstation users"
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
