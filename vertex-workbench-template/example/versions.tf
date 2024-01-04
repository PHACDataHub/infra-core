terraform {
  required_version = ">= 0.14.5"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 0.14.5"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 0.14.5"
    }
  }
}

provider "google" {
  credentials = file("terraform-sa-key.json") # .gitignored local service account key.

  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  credentials = file("terraform-sa-key.json") # .gitignored local service account key.

  project = var.project
  region  = var.region
  zone    = var.zone
}