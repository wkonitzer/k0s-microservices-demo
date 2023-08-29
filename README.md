# Terraform Kubernetes Project

This Terraform project sets up Equinix Metal servers, installs Mirantis MCR + MKE using Launchpad, configures a Kubernetes cluster and finally installs a demo microservices app to a configured website.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Modules](#modules)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Known Issues](#known-issues)

---

## Prerequisites

- **Terraform**: Version v1.x.x or above.
- **Kubectl Toolchain**: Ensure you have a configured kubectl toolchain.
- **GoDaddy Credentials**: Necessary to configure DNS.
- **Equinix Metal Crendentials**: Necessary to provision the servers.
- **Mirantis Launchpad**: Installs MCR and MKE.

---

## Modules

1. **Common**:
   - Sets up common Equinix resources.
2. **Machines**:
   - Provisions bare metal machines in Equinix.
3. **Launchpad Setup**: 
   - Sets up MCR and MKE.
4. **MetalLB Setup**: 
   - Configures MetalLB within the Kubernetes cluster.
5. **Microservices Demo**:
   - Installs the microservice demo application.
6. **Caddy**:
   - Installs Caddy Server operator .     
7. **Microservice Ingress**: 
   - Sets up an ingress for a microservice.
   - Configures a DNS record for it.

---

## Quick Start

1. **Initialization**:
   ```bash
   terraform init
   ```
2. **Plan**:
   ```bash 
   terraform plan
   ```
3. **Apply**:
   ```bash   
   terraform apply
   ```

---

## Configuration

Several variables need to be exported via environment variables:

  * METAL_AUTH_TOKEN

Any other required variables can be set in terraform.tfvars.

The terraform.tfvars.example file has the minimum required parameters listed.  

---

## Known Issues

- You may need to run `terraform apply` twice due to certain dependencies not being recognized on the first run.
