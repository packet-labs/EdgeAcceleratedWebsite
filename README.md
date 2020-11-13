![](https://img.shields.io/badge/Stability-Experimental-red.svg)

# Bare Metal Edge Accelerated Website 
Website accelerated using the Bare Metal Edge Accelerator Terraform Module

This repository is [Experimental](https://github.com/packethost/standards/blob/master/experimental-statement.md) meaning that it's based on untested ideas or techniques and not yet established or finalized or involves a radically new and innovative style! This means that support is best effort (at best!) and we strongly encourage you to NOT use this in production.

## Overview

This is a full environment demo'ing a web accelerated network using nginx across Packet locations.
It uses the [Packet Edge Accelerator Terraform Module](https://github.com/packet-labs/EdgeAccelerator)
to deploy the network of web accelerators (web proxies) running nginx. These
web accelerators, located at edge locations, cache content from the origin web server for
delivery to the end user. This improves performance by reducing load on the origin server
and reduces latency by delivering from an edge location closer to the end user.

Both IPv4 and IPv6 are supported for the edge delivery and the origin requests. The origin
server can even be IPv4 and the edge delivery via IPv6 as an IPv4 to IPv6 gateway proxy.

For more details about the Network Architecture or how to incorporate this module into your
own repo is available at the [Packet Edge Accelerator Terraform Module](https://github.com/packet-labs/EdgeAccelerator).

## Sample Usage

This repo deploys a single origin server with a small static website and then uses the
[Packet Edge Accelerator Terraform Module](https://github.com/packet-labs/EdgeAccelerator)
to deploy the network of web accelerators.

The Origin Server is deployed as a single bare metal server in ```origin.tf```. The IPv6
URL of the Origin Server is then passed as the input parameter to the Edge Accelerator module.
The module then uses this URL to pull content.

## Prerequisites

### Packet Project ID & API Key

This deployment requires a Packet account for the provisioned bare metal. You'll need your "Packet Project ID" and your "Packet API Key" to proceed. You can use an existing project or create a new project for the deployment.

We recommend setting the Packet API Token and Project ID as environment variables since this prevents tokens from being included in source code files. These values can also be stored within a variables file later if using environment variables isn't desired.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

#### Where is my Packet Project ID?

You can find your Project ID under the 'Manage' section in the Packet Portal. They are listed underneath each project in the listing. You can also find the project ID on the project 'Settings' tab, which also features a very handy "copy to clipboard" piece of functionality, for the clicky among us.

#### How can I create a Packet API Key? 

You will find your API Key on the left side of the portal. If you have existing keys you will find them listed on that page. If you haven't created one yet, you can click here:

https://app.packet.net/portal#/api-keys/new

### Terraform

These instructions use Terraform from Hashicorp to drive the deployment. If you don't have Terraform installed already, you can download and install Terraform using the instructions on the link below:
https://www.terraform.io/downloads.html

## Deployment Prep

Download this repo from GitHub into a local directory.

```bash
git clone https://github.com/packet-labs/EdgeAcceleratedWebsite
cd EdgeAcceleratedWebsite
```

Download the Terraform providers required:
```bash
terraform init
```

## Deployment

Start the deployment:
```bash
terraform apply
```

At the conclusion of the deployment, the list of deployed edge web accelerators will be listed.

```bash
deployed_edge_proxies_ipv4 = [
  "139.178.88.11",
  "139.178.81.103",
]
deployed_edge_proxies_ipv6 = [
  "2604:1380:1000:7800::d",
  "2604:1380:4111:9a00::3",
]
```

## Testing

Retrieve the web page through each web accelerator to verify that they are working correctly.

Test retrieval via IPv4 for each edge:
```bash
curl http://139.178.88.11/
curl http://139.178.81.103/
```

Test retrieval via IPv6 for each edge:
```bash
curl http://[2604:1380:1000:7800::d]
curl http://[2604:1380:4111:9a00::3]
```


