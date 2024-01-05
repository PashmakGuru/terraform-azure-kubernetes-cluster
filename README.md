# Terraform Module for Azure Kubernetes Service (AKS) Cluster

[![Terraform CI](https://github.com/PashmakGuru/terraform-azure-kubernetes-cluster/actions/workflows/terraform-ci.yaml/badge.svg)](https://github.com/PashmakGuru/terraform-azure-kubernetes-cluster/actions/workflows/terraform-ci.yaml)

## Overview

This Terraform module is designed to set up an Azure Kubernetes Service (AKS) cluster along with necessary networking and security components. It provides a straightforward approach to deploy a fully functional AKS cluster in Azure.

### Terraform Architecture
```mermaid
%%tfmermaid
%%{init:{"theme":"default","themeVariables":{"lineColor":"#6f7682","textColor":"#6f7682"}}}%%
flowchart LR
classDef r fill:#5c4ee5,stroke:#444,color:#fff
classDef v fill:#eeedfc,stroke:#eeedfc,color:#5c4ee5
classDef ms fill:none,stroke:#dce0e6,stroke-width:2px
classDef vs fill:none,stroke:#dce0e6,stroke-width:4px,stroke-dasharray:10
classDef ps fill:none,stroke:none
classDef cs fill:#f7f8fa,stroke:#dce0e6,stroke-width:2px
n0["azapi_resource.ssh_public_key"]:::r
n1["azapi_resource_action.<br/>ssh_public_key_gen"]:::r
subgraph "n2"["Key Vault"]
n3["azurerm_key_vault.this"]:::r
n4["azurerm_key_vault_secret.<br/>admin_ssh_private_key"]:::r
end
class n2 cs
subgraph "n5"["Container"]
n6["azurerm_kubernetes_cluster.<br/>this"]:::r
end
class n5 cs
subgraph "n7"["Base"]
n8["azurerm_resource_group.this"]:::r
n9{{"data.<br/>azurerm_client_config.<br/>current"}}:::r
end
class n7 cs
subgraph "na"["Authorization"]
nb["azurerm_role_assignment.<br/>aks_nodes_rg_roles"]:::r
nc["azurerm_role_assignment.<br/>aks_rg_roles"]:::r
nd["azurerm_role_assignment.<br/>kv_allow_current_sp"]:::r
ne["azurerm_role_assignment.<br/>kv_allow_platform_engineers"]:::r
end
class na cs
subgraph "nf"["Network"]
ng["azurerm_subnet.cluster"]:::r
nh["azurerm_virtual_network.this"]:::r
end
class nf cs
subgraph "ni"["Groups"]
nj{{"data.<br/>azuread_group.<br/>platform_engineers"}}:::r
end
class ni cs
subgraph "nk"["Compute"]
nl{{"data.<br/>azurerm_ssh_public_key.<br/>admin_ssh_public_key"}}:::r
end
class nk cs
nm["random_string.<br/>azurerm_key_vault_name"]:::r
subgraph "nn"["Input Variables"]
no(["var.environment"]):::v
np(["var.location"]):::v
nq(["var.name"]):::v
nr(["var.resource_group_name"]):::v
end
class nn vs
ns(["local.common_tags"]):::v
nt(["local.aks_nodes_rg_roles"]):::v
nu(["local.aks_rg_roles"]):::v
subgraph "nv"["Output Values"]
nw(["output.kubernetes_cluster"]):::v
nx(["output.resource_group"]):::v
end
class nv vs
n8-->n0
n0-->n1
n8-->n3
n9-->n3
nm-->n3
n1-->n4
nd-->n4
ng-->n6
nl-->n6
ns-->n8
np--->n8
nr--->n8
n6-->nb
nt-->nb
n6-->nc
nu-->nc
n3-->nd
n3-->ne
nj-->ne
nh-->ng
n8-->nh
n1-->nl
no--->ns
nq--->ns
n6--->nw
n8--->nx
```

## Features

- **Azure Resource Group Creation:** Initiates a resource group for managing all related Azure resources.
- **Network Setup:** Establishes a Virtual Network and a dedicated Subnet for the AKS cluster.
- **Key Vault Setup:** Implements an Azure Key Vault for secure key management.
- **SSH Key Management:** Automates the generation and handling of SSH keys for secure cluster access.
- **Azure Kubernetes Service Deployment:** Configures and deploys the AKS cluster with customizable settings.
- **Role Assignments:** Sets up necessary role assignments for resource management within Azure.

## Prerequisites

For details on the required providers, refer to [01-providers.tf](01-providers.tf).

## Usage

A working example of how to use this module is provided in the `example` directory. This example illustrates a practical implementation of the module, offering a starting point for your deployment.

## Variables and Outputs

- **Variables:** For a list of configurable variables, see the [variables.tf](variables.tf) file.
- **Outputs:** To understand the output values that this module generates, refer to the [outputs.tf](outputs.tf) file.

## Workflows
| Name | Description |
|---|---|
| [terraform-ci.yaml](.github/workflows/terraform-ci.yaml) | A workflow for linting and auto-formatting Terraform code. Triggered by pushes to  `main` and `dev` branches or on pull requests, it consists of two jobs: `tflint` for lint checks, `format` for code formatting and submit a PR, and `tfmermaid` to update architecture graph and submit a PR. |
