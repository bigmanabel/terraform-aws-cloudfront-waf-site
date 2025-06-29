# Development Environment Configuration
terraform {
  required_version = "~> 1.7"
  
  # Uncomment and configure backend for remote state storage
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "static-site/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Use the root module
module "static_site" {
  source = "../../"

  # General Configuration
  project_name = var.project_name
  environment  = "dev"
  aws_region   = var.aws_region

  # S3 Configuration
  bucket_name               = "${var.project_name}-dev-${random_id.bucket_suffix.hex}"
  s3_versioning_enabled     = false
  s3_block_public_access    = true
  s3_enable_public_access   = false

  # CloudFront Configuration
  cloudfront_enabled             = true
  cloudfront_price_class         = "PriceClass_100"  # Most cost-effective for dev
  cloudfront_geo_restriction_type = "none"

  # WAF Configuration - Basic protection for dev
  waf_managed_rules = [
    {
      name                        = "AWS-AWSManagedRulesCommonRuleSet"
      priority                    = 1
      override_action            = "none"
      managed_rule_group_name    = "AWSManagedRulesCommonRuleSet"
      vendor_name                = "AWS"
      excluded_rules             = []
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-rule-common-dev"
      sampled_requests_enabled   = true
    }
  ]

  # Development-specific tags
  tags = {
    Environment = "dev"
    CostCenter  = "development"
    Owner       = var.owner_email
  }
}

# Generate random suffix for bucket name uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
