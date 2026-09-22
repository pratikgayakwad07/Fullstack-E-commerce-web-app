output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data, needed by kubectl/helm providers"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider, used for IRSA role trust policies"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster control plane"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

