# Network Overview

![network-diagram](./diagrams/network-overview.svg)

# Networking Components

## VPC and Subnet

The network for the Vertex Project Template consists of a single [custom-mode VPC network](https://cloud.google.com/vpc/docs/vpc) and a single [regional subnetwork](https://cloud.google.com/vpc/docs/subnets) resource, which is hard-coded to [`northamerica-northeast1`](https://cloud.google.com/compute/docs/regions-zones) (i.e. Montréal). All notebook virtual machines are in this subnet.

## Cloud Network Address Translation (NAT)

[GCP Cloud NAT](https://cloud.google.com/nat/docs/overview) allows certain resources to create **outbound** connections to the internet. Address translation is only supported for inbound **response** packets only; no unsolicited inbound connections are allowed. A **regional** (i.e. `northamerica-northeast1`) external IP address for the cloud NAT instance is [automatically provisioned](https://cloud.google.com/nat/docs/ports-and-addresses) when the Cloud NAT resource is provisioned.

## Firewall

All outgoing traffic is evaluated against VPC-wide [firewall rules](https://cloud.google.com/compute/docs/reference/rest/v1/firewalls), with a default deny rule for all egress. An exception is made for GitHub public IPs so that users can use GitHub for source control.

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

A number of Google APIs need to be accessed for various purposes.

| API | Purpose |
| --- | ------- |

# Network Flows

This section outlines the details of each network flow.

**Notes**

- The CIDR 10.0.0.0/XX is used as a stand-in for a dynamically allocated RFC 1918 private IP address from the subnet.

## Notebook Start Up and Authenticated Connection to Notebook Server

| **Source IP/CIDR**| **Source Port** | **Dest IP/CIDR** | **Dest Port** | **Protocol No.** | **Extra Details** |
| 10.0.0.0/XX | Ephemeral | 199.36.153.8/30 | 443 | 6 (TCP) | `forwarding-proxy-agent` initiates https connection to Google-managed proxy server via `private.googleapis.com` service. |
| 199.36.153.8/30 | Ephemeral | 10.0.0.0/XX | 443 | 6 (TCP) | Source IP is from Google-managed proxy server, forwarding https user traffic to notebook sever. |


**Notes**

- 199.36.153.8/30 refers to the [IP range for `private.googleapis.com`](https://cloud.google.com/vpc/docs/configure-private-google-access-hybrid). These IPs are only routable from within Google Cloud.

## Github Clone Repository

| **Source IP/CIDR**| **Source Port** | **Dest IP/CIDR** | **Dest Port** | **Protocol No.** | **Extra Details** |
| 10.0.0.0/XX | Ephemeral | 140.82.112.0/20 | 443 | 6 (TCP) | NAT from 10.0.0.0/XX to regional external IP. |
| 140.82.112.0/20 | 443 | 10.0.0.0/XX | Ephemeral | 6 (TCP) | NAT from regional external IP to 10.0.0.0/XX. |

**Notes**

- As per the [GitHub metadata API](https://api.github.com/meta), GitHub uses Public IP addresses from the range 140.82.112.0/20.
- All egress is routed through a NAT Gateway router, so all private source IPs are translated to a public IP via the NAT Gateway.