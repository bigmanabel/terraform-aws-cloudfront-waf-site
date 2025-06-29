# General Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# S3 Configuration
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "index_document" {
  description = "Index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for the website"
  type        = string
  default     = "error.html"
}

variable "s3_versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "s3_block_public_access" {
  description = "Block public access to the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_enable_public_access" {
  description = "Enable public access to the S3 bucket (for direct access without CloudFront)"
  type        = bool
  default     = false
}

# CloudFront Configuration
variable "cloudfront_enabled" {
  description = "Whether the CloudFront distribution is enabled"
  type        = bool
  default     = true
}

variable "cloudfront_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the CloudFront distribution"
  type        = bool
  default     = true
}

variable "cloudfront_price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "cloudfront_allowed_methods" {
  description = "Allowed methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cloudfront_cached_methods" {
  description = "Cached methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cloudfront_compress" {
  description = "Whether to compress content for web requests"
  type        = bool
  default     = true
}

variable "cloudfront_viewer_protocol_policy" {
  description = "Protocol policy for viewers"
  type        = string
  default     = "redirect-to-https"
}

variable "cloudfront_cache_policy_id" {
  description = "Cache policy ID (if null, uses forwarded_values)"
  type        = string
  default     = null
}

variable "cloudfront_forward_query_string" {
  description = "Whether to forward query strings to the origin"
  type        = bool
  default     = false
}

variable "cloudfront_forward_headers" {
  description = "Headers to forward to the origin"
  type        = list(string)
  default     = []
}

variable "cloudfront_forward_cookies" {
  description = "How to forward cookies to the origin"
  type        = string
  default     = "none"
}

variable "cloudfront_custom_error_responses" {
  description = "Custom error responses for the distribution"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}

variable "cloudfront_geo_restriction_type" {
  description = "Type of geographical restriction"
  type        = string
  default     = "none"
}

variable "cloudfront_geo_restriction_locations" {
  description = "List of country codes for geographical restrictions"
  type        = list(string)
  default     = []
}

# SSL Configuration
variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = null
}

variable "ssl_minimum_protocol_version" {
  description = "Minimum SSL protocol version for HTTPS"
  type        = string
  default     = "TLSv1.2_2021"
}

# WAF Configuration
variable "waf_managed_rules" {
  description = "List of AWS managed rule groups for WAF"
  type = list(object({
    name                        = string
    priority                    = number
    override_action            = string
    managed_rule_group_name    = string
    vendor_name                = string
    excluded_rules             = list(string)
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
  default = [
    {
      name                        = "AWS-AWSManagedRulesCommonRuleSet"
      priority                    = 1
      override_action            = "none"
      managed_rule_group_name    = "AWSManagedRulesCommonRuleSet"
      vendor_name                = "AWS"
      excluded_rules             = []
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rule-common"
      sampled_requests_enabled   = true
    }
  ]
}

variable "waf_rate_limit_rules" {
  description = "List of rate limiting rules for WAF"
  type = list(object({
    name                        = string
    priority                    = number
    action                     = string
    limit                      = number
    aggregate_key_type         = string
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
  default = []
}

variable "waf_ip_set_rules" {
  description = "List of IP set rules for WAF"
  type = list(object({
    name                        = string
    priority                    = number
    action                     = string
    ip_set_arn                 = string
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
  default = []
}

variable "waf_ip_sets" {
  description = "Map of IP sets to create for WAF"
  type = map(object({
    name               = string
    description        = string
    ip_address_version = string
    addresses          = list(string)
  }))
  default = {}
}

variable "waf_cloudwatch_metrics_enabled" {
  description = "Whether CloudWatch metrics are enabled for WAF"
  type        = bool
  default     = true
}

variable "waf_sampled_requests_enabled" {
  description = "Whether sampled requests are enabled for WAF"
  type        = bool
  default     = true
}