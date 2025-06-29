# Production Environment Configuration
terraform {
  required_version = "~> 1.7"
  
  # Backend configuration for production state storage
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "static-site/prod/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Use the root module
module "static_site" {
  source = "../../"

  # General Configuration
  project_name = var.project_name
  environment  = "prod"
  aws_region   = var.aws_region

  # S3 Configuration
  bucket_name               = var.bucket_name
  s3_versioning_enabled     = true  # Enable versioning in production
  s3_block_public_access    = true
  s3_enable_public_access   = false

  # CloudFront Configuration
  cloudfront_enabled                    = true
  cloudfront_price_class                = var.cloudfront_price_class
  cloudfront_geo_restriction_type       = var.geo_restriction_type
  cloudfront_geo_restriction_locations  = var.geo_restriction_locations

  # SSL Configuration
  ssl_certificate_arn = var.ssl_certificate_arn

  # WAF Configuration - Enhanced protection for production
  waf_managed_rules = [
    {
      name                        = "AWS-AWSManagedRulesCommonRuleSet"
      priority                    = 1
      override_action            = "none"
      managed_rule_group_name    = "AWSManagedRulesCommonRuleSet"
      vendor_name                = "AWS"
      excluded_rules             = []
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rule-common-prod"
      sampled_requests_enabled   = true
    },
    {
      name                        = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority                    = 2
      override_action            = "none"
      managed_rule_group_name    = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name                = "AWS"
      excluded_rules             = []
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rule-bad-inputs-prod"
      sampled_requests_enabled   = true
    },
    {
      name                        = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority                    = 3
      override_action            = "none"
      managed_rule_group_name    = "AWSManagedRulesAmazonIpReputationList"
      vendor_name                = "AWS"
      excluded_rules             = []
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rule-ip-reputation-prod"
      sampled_requests_enabled   = true
    }
  ]

  # Rate limiting for production
  waf_rate_limit_rules = var.enable_rate_limiting ? [
    {
      name                        = "RateLimitRule"
      priority                    = 10
      action                     = "block"
      limit                      = var.rate_limit_per_5min
      aggregate_key_type         = "IP"
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rate-limit-prod"
      sampled_requests_enabled   = true
    }
  ] : []

  # Production-specific tags
  tags = merge(var.additional_tags, {
    Environment = "prod"
    CostCenter  = "production"
    Owner       = var.owner_email
    Backup      = "required"
  })
}
