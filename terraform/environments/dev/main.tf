provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name, "--region", var.aws_region]
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = var.tags
}

module "eks_cluster" {
  source = "../../modules/eks-cluster"

  environment        = var.environment
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  tags               = var.tags

  depends_on = [module.vpc]
}

module "eks_node_groups" {
  source = "../../modules/eks-node-groups"

  environment        = var.environment
  cluster_name       = module.eks_cluster.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  tags               = var.tags

  depends_on = [module.eks_cluster]
}

module "eks_access" {
  source = "../../modules/eks-access"

  environment         = var.environment
  cluster_name        = module.eks_cluster.cluster_name
  admin_iam_usernames = var.admin_iam_usernames
  tags                = var.tags

  depends_on = [module.eks_cluster]
}

module "eks_addons" {
  source = "../../modules/eks-addons"

  environment               = var.environment
  cluster_name              = module.eks_cluster.cluster_name
  vpc_id                    = module.vpc.vpc_id
  oidc_provider_arn         = module.eks_cluster.oidc_provider_arn
  cluster_oidc_issuer_url   = module.eks_cluster.cluster_oidc_issuer_url
  enable_alb_controller     = var.enable_helm_addons
  enable_cluster_autoscaler = var.enable_helm_addons
  enable_metrics_server     = var.enable_helm_addons
  tags                      = var.tags

  depends_on = [
    module.eks_cluster,
    module.eks_node_groups,
    module.eks_access
  ]
}

module "ecr" {
  source = "../../modules/ecr"

  environment      = var.environment
  repository_names = var.ecr_repository_names
  tags             = var.tags
}

