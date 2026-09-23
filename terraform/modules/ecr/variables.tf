variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default = [
    "purely_auth_registry",
    "purely_cart_registry",
    "purely_category_registry",
    "purely_gateway_registry",
    "purely_notification_registry",
    "purely_order_registry",
    "purely_product_registry",
    "purely_service_registry",
    "purely_user_registry",
    "purely_web_registry"
  ]
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags to apply to every repository"
  type        = map(string)
  default     = {}
}

