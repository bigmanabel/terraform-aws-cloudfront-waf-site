variable "name" {
  description = "Name of the WAF web ACL"
  type        = string
}

variable "description" {
  description = "Description of the WAF web ACL"
  type        = string
  default     = "WAF Web ACL"
}

variable "scope" {
  description = "Scope of the WAF web ACL"
  type        = string
  default     = "CLOUDFRONT"
  validation {
    condition = contains([
      "CLOUDFRONT",
      "REGIONAL"
    ], var.scope)
    error_message = "Scope must be CLOUDFRONT or REGIONAL."
  }
}

variable "default_action" {
  description = "Default action for the WAF web ACL"
  type        = string
  default     = "allow"
  validation {
    condition = contains([
      "allow",
      "block"
    ], var.default_action)
    error_message = "Default action must be allow or block."
  }
}

variable "managed_rules" {
  description = "List of managed rule groups"
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
  default = []
}

variable "rate_limit_rules" {
  description = "List of rate limiting rules"
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

variable "ip_set_rules" {
  description = "List of IP set rules"
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

variable "ip_sets" {
  description = "Map of IP sets to create"
  type = map(object({
    name               = string
    description        = string
    ip_address_version = string
    addresses          = list(string)
  }))
  default = {}
}

variable "cloudwatch_metrics_enabled" {
  description = "Whether CloudWatch metrics are enabled for the web ACL"
  type        = bool
  default     = true
}

variable "metric_name" {
  description = "CloudWatch metric name for the web ACL"
  type        = string
  default     = "waf-metric"
}

variable "sampled_requests_enabled" {
  description = "Whether sampled requests are enabled for the web ACL"
  type        = bool
  default     = true
}

variable "associate_with_resource" {
  description = "Whether to associate the web ACL with a resource"
  type        = bool
  default     = false
}

variable "resource_arn" {
  description = "ARN of the resource to associate with the web ACL"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the WAF resources"
  type        = map(string)
  default     = {}
}
