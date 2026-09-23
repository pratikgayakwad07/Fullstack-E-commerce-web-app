variable "environment" {
  description = "Environment name (dev/prod) — used to tag and name every resource"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.29"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (from the vpc module) — worker nodes go here"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs (from the vpc module) — needed for the ALB the ingress creates"
  type        = list(string)
}

variable "tags" {
  description = "Extra tags to apply to every resource in this module"
  type        = map(string)
  default     = {}
}

