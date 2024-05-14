# Microservices Demo Project

This Terraform project sets up Equinix Metal servers, installs k0s using k0sctl, configures a Kubernetes cluster and finally installs a demo microservices app, along with Longhorn Storage and Mirantis MSR.

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
- **k0sctl**: Installs k0s.
- **Linux tools**: awk, sed, grep.

---

## Modules

1. **Provision**:
   - Sets up Equinix resources.
2. **k0s**: 
   - Sets up k0s.
3. **MetalLB**: 
   - Configures MetalLB within the Kubernetes cluster.
4. **Caddy**:
   - Installs Caddy Server operator.
5. **External DNS**:
   - Installs External DNS operator.   
6. **Longhorn**:
   - Installs Longhorn storage.   
7. **MSR**:
   - Installs MSR.        
8. **Microservices Demo**:
   - Installs the microservice demo application.
9. **Microservice Ingress**: 
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

- Longhorn doesn't uninstall cleanly, so to tear everything down:
   ```bash
   terraform state rm module.longhorn.module.longhorn.helm_release.longhorn   
   terraform destroy
   ```  
