variable "environment" {
  description = "Environment name (dev/prod) — used to tag and name every resource"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "admin_iam_usernames" {
  description = "IAM usernames to grant admin access to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Extra tags to apply to every resource in this module"
  type        = map(string)
  default     = {}
}

