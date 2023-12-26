variable "name" {
  type        = string
  description = "The name of the Azure Kubernetes Service (AKS) cluster. This name must be unique within the Azure resource group and should be descriptive of the cluster's purpose or application."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "The name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "West US"
  description = "The Azure region where the AKS cluster will be deployed. Defaults to 'West Europe'. It's important to select a region close to the users for better performance."
}

variable "environment" {
  type        = string
  default     = "development"
  description = "Specifies the deployment environment of the AKS cluster. Default is 'development'. This can be used to differentiate between stages such as development, staging, and production."
}
