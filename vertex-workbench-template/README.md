# Vertex Workbench Template

> [!WARNING]
> This documentation is still under development as this reference architecture is actively undergoing Security Assessment and Authorization (SA&A).

The purpose of the analytics environment template is to provide infectious disease surveillance teams with the tools to develop and maintain their own data ingestion, cleaning, and analysis process.

## Table of Contents

- [Networking Controls](./docs/network.md)
- [Storage Controls](./docs/bucket.md)
- [Jupyter Notebook](./docs/notebook.md)
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
