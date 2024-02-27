# Self Service Analytics Portal
## What and Why?
Provisioning and managing cloud infrastructure and applications can sometimes be daunting for an end-user (and for the platform team). This project is a PoC that addresses the problem by creating an [internal developer platform](https://internaldeveloperplatform.org/what-is-an-internal-developer-platform/) to simplify the process of requesting and managing cloud infrastructure and applications. It's a set of **self-served** services built by the platform team that supports and accelerates development or analysis, while taking care of managing the underlying infrastructure.

Building a centralized platform for infrastructure helps in achieving a separation of responsibilities between the platform team and the application / analytical teams. For example, an analytical team can request for a Vertex AI Notebook and a Cloud Storage bucket without worrying about the networking setup for these resources via the platform's predefined templates. Such templates also help in driving software development to follow best / standard practices or comply with the [Enterprise Architecture Framework](https://www.canada.ca/en/government/system/digital-government/policies-standards/government-canada-enterprise-architecture-framework.html), all while lowering the barrier to entry. In addition to this, it can serve as a single pane of glass to monitor and manage cloud costs via a [FinOps monitor](https://backstage.io/blog/2020/10/22/cost-insights-plugin/), host technical documentations via [TechDocs](https://backstage.io/docs/features/techdocs/), find the information you're looking for throughout the entire ecosystem via it's rich [search functionality](https://backstage.io/docs/features/search/), track project resources and the relevant metadata (ownership, links to code repositories, etc.) and more...

## How?
The portal is built on top of modern cloud-native technological blocks like microservices, declarative APIs, containers, and service meshes. It uses Kubernetes (GKE Autopilot) as the platform and [CNCF](https://www.cncf.io/) tools like:
- [Flux](https://fluxcd.io/flux/) for GitOps
- [Istio](https://istio.io/latest/docs/) for secure networking and observability
- [Cert-Manager](https://cert-manager.io/docs/) for automatic renewal of TLS certificates
- [Crossplane](https://docs.crossplane.io/) for managing infrastructure
- [Backstage](https://backstage.io/docs/overview/what-is-backstage/) for building the frontend of the platform

It aims to satisfy the following [core componenets of an Internal developer platform](https://internaldeveloperplatform.org/core-components/):
**Core Component** | **Short Description** | **Solution**
--- | --- | ---
[**Application Configuration Management**](https://internaldeveloperplatform.org/core-components/application-configuration-management/) | Manage application configuration in a dynamic, scalable and reliable way. | YAML versioned with Git / Github
[**Infrastructure Orchestration**](https://internaldeveloperplatform.org/core-components/infrastructure-orchestration/) | Orchestrate your infrastructure in a dynamic and intelligent way depending on the context. | Crossplane
[**Environment Management**](https://internaldeveloperplatform.org/core-components/environment-management/) | Enable developers to create new and fully provisioned environments whenever needed. | Depends on what "Environment" means for an application
[**Deployment Management**](https://internaldeveloperplatform.org/core-components/deployment-management/) | Implement a delivery pipeline for Continuous Delivery or even Continuous Deployment (CD). | Flux
[**Role-Based Access Control**](https://internaldeveloperplatform.org/core-components/role-based-access-control/) | Manage who can do what in a scalable way. | Backstage [Authn](https://backstage.io/docs/auth/) / [Authz](https://backstage.io/docs/permissions/overview)

### Why Backstage?

[Here's the reason](https://backstage.io/docs/overview/what-is-backstage#backstage-and-the-cncf)

## Setup
TODO

## Status
- PoC work was completed and presented internally in the DPI Deep Dive meeting
- Paused until contract goes through to bring on resources
