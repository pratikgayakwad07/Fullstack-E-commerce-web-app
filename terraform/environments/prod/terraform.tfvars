aws_region           = "us-east-1"
environment          = "prod"
vpc_cidr             = "10.1.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
enable_nat_gateway   = true

cluster_name       = "purely-cluster-prod"
cluster_version    = "1.36"
node_instance_type = "c7i-flex.large"
node_desired_size  = 3
node_min_size      = 2
node_max_size      = 6

admin_iam_usernames = ["pratik"]
enable_helm_addons  = true

tags = {
  Project   = "Purely"
  ManagedBy = "Terraform"
}

