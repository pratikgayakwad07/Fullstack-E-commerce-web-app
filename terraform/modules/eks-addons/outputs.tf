output "alb_controller_role_arn" {
  description = "IAM role ARN for the AWS Load Balancer Controller"
  value       = try(aws_iam_role.alb_controller[0].arn, null)
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for the EKS Cluster Autoscaler"
  value       = try(aws_iam_role.cluster_autoscaler[0].arn, null)
}

