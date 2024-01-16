# Jupyter and RStudio Docker Images

Two main development environments are provided to users through this template: [Vertex Workbench Notebooks](https://cloud.google.com/vertex-ai-notebooks?hl=en) and [Cloud Workstations](https://cloud.google.com/workstations?hl=en). Both of these GCP products are based on OCI images, and both environments are launched as container instances from these OCI images. This template leverages [GCP Cloud Build](https://cloud.google.com/build?hl=en) triggers to build images specified with one or more `Dockerfile`s in a project-specific repository.

## Base Images

By default, the base images used for the Vertex Workbench Notebooks and Cloud Workstations are, respectively, the official [Python image](https://hub.docker.com/_/python) from Dockerhub based on Alpine Linux and the Dockerhub hosted [RStudio image](https://hub.docker.com/r/rocker/rstudio/tags) from the [Rocker Project](https://rocker-project.org/).

Projects are free to deviate from these base images if their projects have different requirements. Moreover, the review of the images used in a concrete instantiation of this template would be covered under the Security Assessment and Authorization (SA&A) process for the specific project instantiating this template.

## Vulnerability Scanning

This template supports one of two approaches for vulnerability scanning.

1. Build and scan images in the continuous integration pipeline of the project-specific repository. This could be achieved, for example, by using the [trivy-action](https://github.com/aquasecurity/trivy-action) GitHub Action based on [Aqua Security's Trivy](https://github.com/aquasecurity/trivy) vulnerability scanning tool.
2. Enable [Artifact analysis and vulnerability scanning](https://cloud.google.com/artifact-registry/docs/analysis) in the Artifact Registry repository of the GCP project.

The specific method of vulnerability scanning should be reviewed as part of the project-specific SA&A process. However, all projects must demonstrate that they undergo regular vulnerability scans on the OCI images they build and use.

## Image Builds

This template provisions a Cloud Build trigger to watch a project-specific Git repository. 

By default, we recommend using [Git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) to trigger image builds so that project teams can be intentional about upgrading their images. Moreover, if teams opt for a solution like Trivy for vulnerability scanning, they can defer tagging a commit until the CI pipeline for that commit passes the Trivy vulnerability scan. However, project teams are free to choose the mechanism through which image builds are triggered as this is a project-specific implementation detail.

GCP Cloud Build is always used to build the image and push it to the project's [Artifact regsitry](https://cloud.google.com/artifact-registry). The reason for this decision is that it eliminates the need for an external entity to authenticate with GCP and initiate an image push over the public internet. Instead, the image build occurs from an internal GCP service and the image push to the project's artifact registry occers over a private network connection rather than over the public internet.
