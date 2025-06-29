variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for production"
  type        = string
}

variable "owner_email" {
  description = "Email of the project owner"
  type        = string
}

variable "cloudfront_price_class" {
  description = "CloudFront price class for production"
  type        = string
  default     = "PriceClass_All"
}

variable "geo_restriction_type" {
  description = "Type of geographical restriction"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of country codes for geographical restrictions"
  type        = list(string)
  default     = []
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = null
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting in WAF"
  type        = bool
  default     = true
}

variable "rate_limit_per_5min" {
  description = "Rate limit per 5 minutes per IP"
  type        = number
  default     = 2000
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
