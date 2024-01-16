variable "project" {
  description = "Your GCP Project ID"
  type        = string
}

variable "zone" {
  description = "The GCP Zone for Vertex Notebook User-Managed Instances"
  type        = string
}

variable "region" {
  description = "The GCP region for the GCS bucket and Artifact Registry"
  type        = string
}

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

variable "additional_vertex_nb_sa_roles" {
  description = "Additional roles that you may want to assign to the Vertex AI NB SA"
  type        = list(string)
  default     = []
}

variable "vpc_network_name" {
  description = "The name of your VPC Network"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "The name of your VPC Subnetwork"
  type        = string
  default     = "10.0.0.0/21"
}

variable "gcs_bucket_name" {
  description = "Name of the GCS Bucket that will contain the post startup script"
  type        = string
}

variable "gcs_labels" {
  description = "Labels to attach to the GCS Bucket. Useful for labelling resources for billing purposes"
  type        = map(string)
  default     = null
}

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

variable "analytics_bucket_name" {
  description = "Name of the GCS Bucket for user data."
  type        = string
}

variable "logging_project_sink_name" {
  description = "Logging project sink name"
  type        = string
}

variable "cloudbuild_triggers" {
  description = "Configuration for cloud build triggers"
  type = map(object({
    description     = optional(string)
    tags            = optional(list(string), [])
    service_account = optional(string)
    
    git_file_source = object({
      path     = string
      repo_type = optional(string, "GITHUB")
    })

    github = object({
      owner = string
      repository = string
      
      pull_request = optional(object({
        branch         = optional(string)
        invert_regex   = optional(bool)
        comment_control = optional(string)
      }))

      push = optional(object({
        branch       = optional(string)
        tag          = optional(string)
        invert_regex = optional(bool)
      }))
    })
  }))
}
