variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment identifier (e.g. dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to deploy subnets into"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to deploy a NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "purely-cluster-dev"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "admin_iam_usernames" {
  description = "List of IAM usernames to grant cluster admin access"
  type        = list(string)
  default     = []
}

variable "ecr_repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default = [
    "purely_auth_registry",
    "purely_cart_registry",
    "purely_category_registry",
    "purely_gateway_registry",
    "purely_notification_registry",
    "purely_order_registry",
    "purely_product_registry",
    "purely_service_registry",
    "purely_user_registry",
    "purely_web_registry"
  ]
}

variable "enable_helm_addons" {
  description = "Whether to deploy Helm add-ons (ALB Controller, Cluster Autoscaler, Metrics Server)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

