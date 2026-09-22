locals {
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
