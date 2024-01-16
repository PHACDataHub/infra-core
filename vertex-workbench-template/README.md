# Vertex Workbench Template

> [!WARNING]
> This documentation is still under development as this reference architecture is actively undergoing Security Assessment and Authorization (SA&A).

The purpose of the analytics environment template is to provide infectious disease surveillance teams with the tools to develop and maintain their own data ingestion, cleaning, and analysis process.

## Deployment Instructions

1. Clone this repo and checkout the appropriate branch (e.g. `git clone https://github.com/PHACDataHub/infra-core.git` --> `git checkout vertex-template`).
2. Create a service account for terraform in the GCP Project you want to deploy into. This service account must have the `Owner` role for the project.
3. Go to **APIs & Services** --> **Credentials** --> Click the terraform service account (this should look something like `terraform@<project-id>.iam.gserviceaccount.com`) --> Select **KEYS** --> **ADD KEY** --> **Create New Key** --> select **JSON** key type. **This JSON file should be treated as a sensitive value as it contains the private key for the service account**.
4. Place the service account key from Step 3 in the `example` directory. Rename it `terraform-sa-key.json` (**or another name that is explicitly `.gitignore`d**).
5. `cd example`
6. `touch terraform.auto.tfvars` (also `.gitignore`d). This file contains any overrides for default terraform variables. The code snippet inserted below these instructions shows an example that creates a single vertex notebook along with a single GCS bucket.
7. `terraform init`
8. `terraform lint`
9. `terraform plan`
10. If the plan looks good, then `terraform apply`.

**Example of `terraform.auto.tfvars`**

```hcl
project              = "<your project ID>"
zone                 = "northamerica-northeast1-b"  # `northamerica-northeast1` == Montreal
region               = "northamerica-northeast1"
vpc_network_name     = "data-analytics-vpc"
subnet_ip_cidr_range = "any valid RFC 1918 CIDR"  # E.g. `10.0.0.0/24`
gcs_bucket_name      = "nb-script"

notebooks = {
  "example-user-managed-instance" : {
    "instance_owner" : "<gcp email of notebook owner>"
    "metadata" : {}
    "type" : "user-managed-notebook",
  }
}

additional_vertex_nb_sa_roles = [
  "roles/dataproc.editor",
  "roles/dataproc.hubAgent"
]

# Only include this if you want to add a specific allow rule to the firewall policies.
# The example below allows egress to google.com
additional_fw_rules = [{
  name                    = "egress-allow-example-google"
  description             = "Allow egress example"
  direction               = "EGRESS"
  priority                = 65534
  ranges                  = ["142.250.178.14/32"] # google.com
  source_tags             = null
  source_service_accounts = null
  target_tags             = null
  target_service_accounts = null
  allow = [{
    protocol = "tcp"
    ports    = ["80"]
  }]
  deny = []
  log_config = {
    metadata = "INCLUDE_ALL_METADATA"
  }
}]
```

## Table of Contents

- [Networking Controls](./docs/network.md)
- [Storage Controls](./docs/bucket.md)
- [Jupyter and RStudio Images](./docs/jupyter-and-rstudio.md)
- [Policies and Procedures](./docs/policies-and-procedures.md)
- [Service Level Agreement](./docs/sla.md)

## Overview

Provinces and Territories email Excel files to PHAC Epidemiologists using [LiquidFiles](https://docs.liquidfiles.com/userguide.html). PHAC Epidemiologists upload these Excel files directly to a pre-configured [Google Cloud Storage (GCS) bucket](https://cloud.google.com/storage/docs/json_api/v1/buckets) via the Google Cloud Platform (GCP) console.

![analytics environment overview](./docs/diagrams/overview.svg)

PHAC Epidemiologists maintain Jupyter notebooks, Python scripts, and R scripts for the following purposes:

### 1. Data Cleaning

PHAC Epidemiologists often have no control over the upstream infectious disease surveillance data sent to PHAC by the provinces and territories. Therefore, it is often the case that each province and territory sends the same data with many significant differences in formatting and table schema. These differences require that PHAC epidemiologists have the ability to convert this data to a common schema with a common set of formatting conventions so that the data can be used for national-level analysis and reporting.

To this end, PHAC Epidemiologists maintain a series of data cleaning notebooks and scripts, leveraging common open source tools in the Python Data Science ecosystem such as [Pandas 2.0](https://pandas.pydata.org/docs/dev/whatsnew/v2.0.0.html) (leveraging [Apache Arrow](https://arrow.apache.org/) tables), and [Great Expectations](https://docs.greatexpectations.io/docs/).

All cleaned and validated data are written to a [Parquet](https://parquet.apache.org/) directory in the same GCS bucket.

### 2. Data Integration

In certain cases, after cleaning the upstream data sources received by the provinces and territories, there may be a data integration step. In this step, two or more data sources may be joined into a de-normalized analysis-ready table, and further data validations may be applied via Great Expectations.

The integrated data are written to another Parquet directory in the same GCS bucket.

### 3. Data Analysis

Once the upstream data have been cleaned, integrated, and validated, the data are ready to be analyzed by PHAC Epidemiologists.

The PHAC Epidemiologists are free to use whichever programming language they prefer. However, they often opt for the [R programming language](https://www.r-project.org/about.html) as there are many open-source packages in the R ecosystem that facilitate epidemiological modelling and analysis.

The PHAC Epidemiologists produce a variety of artifacts from their analysis, including reports, plots, and aggregate data tables, which are exported from the analysis environment and downloaded back to the PHAC Epidemiologist's workstation (connected over VPN or from an on-premisis network) for downstream use.

The downloaded data, by default, are non-sensitive (e.g. aggregate-level data). However, the [Policies and Procedures](./docs/policies-and-procedures.md) document outlines how sensitive data would be exported from the environment if this requirement arises.

## Acknowledgements

This terraform module is based off of the [datatonic google secure vertex workbench](https://github.com/teamdatatonic/terraform-google-secure-vertex-workbench/tree/main) Terraform module.

## Helpful Resources

- [Provision Infrastructure on GCP with Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
