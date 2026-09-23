aws_region           = "us-east-1"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
enable_nat_gateway   = true

cluster_name       = "purely-cluster-dev"
cluster_version    = "1.36"
node_instance_type = "c7i-flex.large"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 6

admin_iam_usernames = ["eks_admin"]
enable_helm_addons  = true
enable_monitoring   = true
grafana_admin_password = "admin"   # change this to a strong password before applying
enable_ebs_csi_driver  = true

tags = {
  Project   = "Purely"
  ManagedBy = "Terraform"
}

