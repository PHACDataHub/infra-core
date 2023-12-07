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
  default     = "10.0.0.0/21"
}
