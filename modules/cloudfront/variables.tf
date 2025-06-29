variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "Origin ID for CloudFront distribution"
  type        = string
  default     = "s3-static-site"
}

variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "ipv6_enabled" {
  description = "Whether IPv6 is enabled for the distribution"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the distribution"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition = contains([
      "PriceClass_All",
      "PriceClass_200",
      "PriceClass_100"
    ], var.price_class)
    error_message = "Price class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = "Static site CloudFront distribution"
}

variable "allowed_methods" {
  description = "Allowed methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "Cached methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "compress" {
  description = "Whether to compress content for web requests"
  type        = bool
  default     = true
}

variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers"
  type        = string
  default     = "redirect-to-https"
  validation {
    condition = contains([
      "allow-all",
      "https-only",
      "redirect-to-https"
    ], var.viewer_protocol_policy)
    error_message = "Viewer protocol policy must be allow-all, https-only, or redirect-to-https."
  }
}

variable "cache_policy_id" {
  description = "Cache policy ID (if null, uses forwarded_values)"
  type        = string
  default     = null
}

variable "forward_query_string" {
  description = "Whether to forward query strings to the origin"
  type        = bool
  default     = false
}

variable "forward_headers" {
  description = "Headers to forward to the origin"
  type        = list(string)
  default     = []
}

variable "forward_cookies" {
  description = "How to forward cookies to the origin"
  type        = string
  default     = "none"
  validation {
    condition = contains([
      "none",
      "whitelist",
      "all"
    ], var.forward_cookies)
    error_message = "Forward cookies must be none, whitelist, or all."
  }
}

variable "whitelisted_cookie_names" {
  description = "Cookie names to whitelist when forward_cookies is 'whitelist'"
  type        = list(string)
  default     = []
}

variable "min_ttl" {
  description = "Minimum TTL for the default cache behavior"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default TTL for the default cache behavior"
  type        = number
  default     = 86400
}

variable "max_ttl" {
  description = "Maximum TTL for the default cache behavior"
  type        = number
  default     = 31536000
}

variable "custom_error_responses" {
  description = "Custom error responses for the distribution"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}

variable "geo_restriction_type" {
  description = "Type of geographical restriction"
  type        = string
  default     = "none"
  validation {
    condition = contains([
      "none",
      "whitelist",
      "blacklist"
    ], var.geo_restriction_type)
    error_message = "Geo restriction type must be none, whitelist, or blacklist."
  }
}

variable "geo_restriction_locations" {
  description = "List of country codes for geographical restrictions"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum SSL protocol version for HTTPS"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "web_acl_id" {
  description = "AWS WAF web ACL ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the CloudFront distribution"
  type        = map(string)
  default     = {}
}
