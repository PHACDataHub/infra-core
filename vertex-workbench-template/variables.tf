# Common variables

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

# VPC variables

variable "vpc_network_name" {
  description = "The name of your VPC Network"
  type        = string
  default     = "data-analytics-vpc"
}

variable "subnet_ip_cidr_range" {
  description = "The name of your VPC Subnetwork"
  type        = string
  default     = "10.0.0.0/21" # Default is 2,048 addresses
}


# Notebooks Variables

variable "machine_type" {
  description = "The Notebook Instance's machine type"
  type        = string
  default     = "n1-standard-4"
}

variable "image_family" {
  description = "Image family for the Notebook instances (https://cloud.google.com/compute/docs/images)"
  type        = string
  default     = "common-cpu"
}

variable "image_project" {
  description = "GCP Project conataining VM image for the Notebook instances"
  type        = string
  default     = "deeplearning-platform-release"
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