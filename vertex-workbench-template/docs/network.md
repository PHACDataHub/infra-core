# Network Overview

![network-diagram](./diagrams/network-overview.svg)

# Networking Components

## VPC and Subnet

The network for the Vertex Project Template consists of a single [custom-mode VPC network](https://cloud.google.com/vpc/docs/vpc) and a single [regional subnetwork](https://cloud.google.com/vpc/docs/subnets) resource, which is hard-coded to [`northamerica-northeast1`](https://cloud.google.com/compute/docs/regions-zones) (i.e. Montréal). All notebook virtual machines are in this subnet.

## Cloud Network Address Translation (NAT)

[GCP Cloud NAT](https://cloud.google.com/nat/docs/overview) allows certain resources to create **outbound** connections to the internet. Address translation is only supported for inbound **response** packets only; no unsolicited inbound connections are allowed. A **regional** (i.e. `northamerica-northeast1`) external IP address for the cloud NAT instance is [automatically provisioned](https://cloud.google.com/nat/docs/ports-and-addresses) when the Cloud NAT resource is provisioned.

## Firewall

All outgoing traffic is evaluated against VPC-wide [firewall rules](https://cloud.google.com/compute/docs/reference/rest/v1/firewalls), with a default deny rule for all egress. An exception is made for GitHub public IPs so that users can use GitHub for source control.


| FW Rule Name                        | Direction | Priority | Ranges                           | Ports     | Description                                                                                                                                                                                                                                                                                                                                                                           |
| ----------------------------------- | --------- | -------- | -------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `egress-deny-all`                   | egress    | 65535    | `0.0.0.0/0`                      | all       | All egress is denied by default.                                                                                                                                                                                                                                                                                                                                                      |
| `ingress-deny-all`                  | ingress   | 65535    | `0.0.0.0/0`                      | all       | All ingress is denied by default.                                                                                                                                                                                                                                                                                                                                                     |
| `ingress-allow-tcp-git`             | ingress   | 65534    | `140.82.112.0/20`                | `80, 443` | As per the [GitHub metadata API](https://api.github.com/meta), GitHub uses Public IP addresses from the range 140.82.112.0/20. The purpose of this rule is to allow users to initiate requests from IPs associated with https://github.com.                                                                                                                                           |
| `egress-allow-tcp-git`              | egress    | 65534    | `140.82.112.0/20`                | `80, 443` | Corresponding rule to `ingress-allow-tcp-git`.                                                                                                                                                                                                                                                                                                                                        |
| `egress-allow-private-gcp-services` | egress    | 65534    | `199.36.153.8/30`                | all       | Allow egress from instances on this network to the [IP range for `private.googleapis.com`](https://cloud.google.com/vpc/docs/configure-private-google-access-hybrid), which is only routable from within Google Cloud.                                                                                                                                                                |
| `egress-allow-pypi-fastly`          | egress    | 65534    | `151.101.64.223, 199.232.36.223` | `443`     | Allow egress from instances in this network to PyPI and Fastly IPs. At the time of writing, these are the specific IPs resolved for the closest CDN for PyPI and Fastly from the Montreal datacenter, where the notebook instances run. We have to periodically review and update these IP addresses, as they may change due to infrastructure updates or CDN provider modifications. |
 
**Notes**:

- The whitelisted IP address for [pypi.org](https://pypi.org) was obtained with a `dig` query, and the whitelisted IP address for Fastly can be found from their [public IP list](https://api.fastly.com/public-ip-list). The purpose of whitelisting these IP addresses is that the `post_startup_script.sh` shell script can be used to install project-specific Python packages so they are available in the base Python virtual environment. **TODO**: In the future, this could be changed to proxy package installs through an artifact registry (e.g. [Artifactory](https://jfrog.com/artifactory/) or similar product) rather than installing directly from the upstream source.

## Access via Authenticated HTTPS Proxy

To the best of our knowledge, [User Managed Notebooks](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/introduction) in [Vertex Workbench](https://cloud.google.com/vertex-ai/docs/workbench/introduction) use an [Inverting Proxy](https://github.com/google/inverting-proxy) to enable `https` connections between a user on the public internet and a notebook on the private subnetwork. The diagram below (borrowed from Inverting Proxy documentation) shows the high-level request flow when a client accesses the notebook via the inverting proxy.

```
+--------+         +-------+         +-------+         +---------+
| Client |         | Proxy | <-(1)-- | Agent |         | Backend |
|        | --(2)-> |       |         |       |         |         |
|        |         |       | --(3)-> |       |         |         |
|        |         |       |         |       | --(4)-> |         |
|        |         |       |         |       | <-(5)-- |         |
|        |         |       | <-(6)-- |       |         |         |
|        | <-(7)-- |       |         |       |         |         |
|        |         |       | --(8)-> |       |         |         |
+--------+         +-------+         +-------+         +---------+
```

Neither the `proxy-forwarding-agent` ("Agent") nor the JupyterLab server ("Backend") are accessible from the public internet. The `proxy-forwarding-agent` initiates an outgoing request to a Google-managed proxy server, and this proxy server waits for incoming client requests on the public internet.

As part of the startup process of the Jupyterlab server (also managed by Google), the `proxy-forwarding-agent` sets up a connection with a Google-managed proxy server, and the proxy server provides a public URL that it is listening for requests on. The format of this URL will look something like `https://<random characters>-dot-<region>.notebooks.googleusercontent.com`. Users who visit this URL are taken though an [OAuth2.0 flow](https://oauth.net/2/) for authentication and authorization.

Authenticated and authorized users have their request to the proxy server forwarded to the `proxy-forwarding-agent` that initiated the original request. The `proxy-forwarding-agent` forwards traffic to the Jupyterlab server. The Jupyterlab server responds to the `proxy-forwarding-agent`, which responds to the proxy server, which responds to the client that made the request.

## DNS

Following the example of Datatonic's [terrafrom-google-secure-vertex-workbench](https://github.com/teamdatatonic/terraform-google-secure-vertex-workbench/tree/main) terraform module, we create private [DNS response policy rules](https://cloud.google.com/dns/docs/zones/manage-response-policies) to map DNS records to GCP's [IP range for `private.googleapis.com`](https://cloud.google.com/vpc/docs/configure-private-google-access-hybrid) rather than using Google's public IP ranges.

Specifically, DNS queries matching `*.googleapis.com`, `*.gcr.io`, `*.pkg.dev`, or `*.notebooks.cloud.google.com` are routed to an IP address in `199.36.153.8/30`.

# Network Flows

This section outlines the details of each network flow.

**Notes**

- The CIDR 10.0.0.0/XX is used as a stand-in for a dynamically allocated RFC 1918 private IP address from the subnet.

## Notebook Start Up and Authenticated Connection to Notebook Server

| **Source IP/CIDR** | **Source Port** | **Dest IP/CIDR** | **Dest Port** | **Protocol No.** | **Extra Details**                                                                                                        |
| ------------------ | --------------- | ---------------- | ------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------ |
| 10.0.0.0/XX        | Ephemeral       | 199.36.153.8/30  | 443           | 6 (TCP)          | `forwarding-proxy-agent` initiates https connection to Google-managed proxy server via `private.googleapis.com` service. |
| 199.36.153.8/30    | Ephemeral       | 10.0.0.0/XX      | 443           | 6 (TCP)          | Source IP is from Google-managed proxy server, forwarding https user traffic to notebook sever.                          |


**Notes**

- 199.36.153.8/30 refers to the [IP range for `private.googleapis.com`](https://cloud.google.com/vpc/docs/configure-private-google-access-hybrid). These IPs are only routable from within Google Cloud.

## Installation of PyPI packages in Notebook VM 

| **Source IP/CIDR** | **Source Port** | **Dest IP/CIDR** | **Dest Port** | **Protocol No.** | **Extra Details**                             |
| ------------------ | --------------- | ---------------- | ------------- | ---------------- | --------------------------------------------- |
| 10.0.0.0/XX        | Ephemeral       | 151.101.64.223  | 443           | 6 (TCP)          | VM instance initiates HTTPS connection to PyPI for package metadata and information |
| 151.101.64.223    | 443             | 10.0.0.0/XX      | Ephemeral     | 6 (TCP)          | Response from PyPI to VM instance for package metadata |
| 10.0.0.0/XX        | Ephemeral       | 199.232.36.223  | 443           | 6 (TCP)          | VM instance initiates HTTPS connection to Fastly server for the source code files/distribution archives of packages to install |
| 199.232.36.223    | 443             | 10.0.0.0/XX      | Ephemeral     | 6 (TCP)          | Response from CDN containing files for installation |


## Github Clone Repository

| **Source IP/CIDR** | **Source Port** | **Dest IP/CIDR** | **Dest Port** | **Protocol No.** | **Extra Details**                             |
| ------------------ | --------------- | ---------------- | ------------- | ---------------- | --------------------------------------------- |
| 10.0.0.0/XX        | Ephemeral       | 140.82.112.0/20  | 443           | 6 (TCP)          | NAT from 10.0.0.0/XX to regional external IP. |
| 140.82.112.0/20    | 443             | 10.0.0.0/XX      | Ephemeral     | 6 (TCP)          | NAT from regional external IP to 10.0.0.0/XX. |

**Notes**

- As per the [GitHub metadata API](https://api.github.com/meta), GitHub uses Public IP addresses from the range 140.82.112.0/20.
- All egress is routed through a NAT Gateway router, so all private source IPs are translated to a public IP via the NAT Gateway.

## Attribution

- [R Icon SVG](https://www.r-project.org/logo/Rlogo.svg) borrowed from R Project website.
- [GCP Cloud Workstation Icon SVG](https://cloud.google.com/docs) borrowed from GCP documentation.
