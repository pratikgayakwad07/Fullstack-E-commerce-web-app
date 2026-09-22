# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# EKS Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  value       = module.eks_cluster.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  value       = module.eks_cluster.oidc_provider_arn
}

output "alb_controller_role_arn" {
  description = "IAM role ARN for the AWS Load Balancer Controller"
  value       = module.eks_addons.alb_controller_role_arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for the EKS Cluster Autoscaler"
  value       = module.eks_addons.cluster_autoscaler_role_arn
}

output "update_kubeconfig_command" {
  description = "Command to configure kubectl credentials for the cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks_cluster.cluster_name}"
}

# ECR Outputs
output "ecr_repository_urls" {
  description = "Map of repository names to repository URLs"
  value       = module.ecr.repository_urls
}

