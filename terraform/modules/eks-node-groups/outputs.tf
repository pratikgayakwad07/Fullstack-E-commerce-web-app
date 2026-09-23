output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "EKS node group ARN"
  value       = aws_eks_node_group.main.arn
}

output "node_role_arn" {
  description = "IAM role ARN for the EKS node group"
  value       = aws_iam_role.node.arn
}

