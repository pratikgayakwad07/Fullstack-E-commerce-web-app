variable "environment" {
  description = "Environment name (dev/prod) — used to tag and name every resource"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (from the vpc module) — worker nodes go here"
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of worker nodes (Cluster Autoscaler scales within this range)"
  type        = number
}

variable "tags" {
  description = "Extra tags to apply to every resource in this module"
  type        = map(string)
  default     = {}
}

