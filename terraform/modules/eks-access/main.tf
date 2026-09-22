resource "aws_eks_access_entry" "admin" {
  for_each      = toset(var.admin_iam_usernames)
  cluster_name  = var.cluster_name
  principal_arn = startswith(each.value, "arn:aws:iam::") ? each.value : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${each.value}"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  for_each      = toset(var.admin_iam_usernames)
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = startswith(each.value, "arn:aws:iam::") ? each.value : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${each.value}"

  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.admin]
}

