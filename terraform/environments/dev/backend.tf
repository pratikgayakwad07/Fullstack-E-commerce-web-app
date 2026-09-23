terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Remote backend configuration (uncomment and configure when ready to use remote state)
  backend "s3" {
    bucket         = "fullstack-backend-bucket-2"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = true
    encrypt        = true
  }
}

