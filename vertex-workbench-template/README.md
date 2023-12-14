# Vertex Workbench Template

> [!WARNING]
> This documentation is still under development as this reference architecture is actively undergoing Security Assessment and Authorization.

The purpose of the analytics environment template is to provide infectious disease surveillance teams with the tools to develop and maintain their own data ingestion, cleaning, and analysis process.

![analytics environment overview](./diagrams/overview.svg)

## Table of Contents

- [Networking Controls](./docs/network.md)
- [Storage Controls](./docs/bucket.md)

## Overview

Provinces and Territories email Excel files to PHAC Epidemiologists using [LiquidFiles](https://docs.liquidfiles.com/userguide.html). PHAC Epidemiologists upload these files 

## Acknowledgements

This terraform module is based off of the [datatonic google secure vertex workbench](https://github.com/teamdatatonic/terraform-google-secure-vertex-workbench/tree/main) Terraform module.

## Helpful Resources
- [Provision Infrastructure on GCP with Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
