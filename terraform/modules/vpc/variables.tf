variable "environment" {
  description = "Environment name (e.g. dev, prod) — used to tag and name every resource"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across (2 recommended for HA)"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets — must have one entry per AZ"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets — must have one entry per AZ"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnet outbound internet access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags to apply to every resource in this module"
  type        = map(string)
  default     = {}
}