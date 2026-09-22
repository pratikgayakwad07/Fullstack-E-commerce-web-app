variable "environment" {
  description = "Environment name (dev/prod) — used to tag and name every resource"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (from the vpc module) that the cluster and nodes live in"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Whether to deploy the Cluster Autoscaler Helm release"
  type        = bool
  default     = true
}

variable "enable_alb_controller" {
  description = "Whether to deploy the AWS Load Balancer Controller Helm release"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Whether to deploy the Metrics Server Helm release"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags to apply to every resource in this module"
  type        = map(string)
  default     = {}
}

