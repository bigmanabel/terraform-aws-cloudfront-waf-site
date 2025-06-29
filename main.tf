locals {
  tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

# S3 Bucket for static site hosting
module "s3" {
  source = "./modules/s3"

  bucket_name                 = var.bucket_name
  index_document              = var.index_document
  error_document              = var.error_document
  versioning_enabled          = var.s3_versioning_enabled
  block_public_access         = var.s3_block_public_access
  enable_cloudfront_access    = true
  enable_public_access        = var.s3_enable_public_access
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags                        = local.tags
}

# WAF Web ACL
module "waf" {
  source = "./modules/waf"

  name        = "${var.project_name}-waf"
  description = "Web ACL for ${var.project_name} CloudFront static site"
  scope       = "CLOUDFRONT"

  managed_rules = var.waf_managed_rules

  rate_limit_rules = var.waf_rate_limit_rules

  ip_set_rules = var.waf_ip_set_rules

  ip_sets = var.waf_ip_sets

  cloudwatch_metrics_enabled = var.waf_cloudwatch_metrics_enabled
  metric_name                = "${var.project_name}-waf-metric"
  sampled_requests_enabled   = var.waf_sampled_requests_enabled

  tags = local.tags
}

# CloudFront Distribution
module "cloudfront" {
  source = "./modules/cloudfront"

  project_name                   = var.project_name
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  origin_id                      = "s3-${var.project_name}"

  enabled             = var.cloudfront_enabled
  ipv6_enabled        = var.cloudfront_ipv6_enabled
  default_root_object = var.index_document
  price_class         = var.cloudfront_price_class
  comment             = "CloudFront distribution for ${var.project_name}"

  allowed_methods        = var.cloudfront_allowed_methods
  cached_methods         = var.cloudfront_cached_methods
  compress               = var.cloudfront_compress
  viewer_protocol_policy = var.cloudfront_viewer_protocol_policy

  cache_policy_id      = var.cloudfront_cache_policy_id
  forward_query_string = var.cloudfront_forward_query_string
  forward_headers      = var.cloudfront_forward_headers
  forward_cookies      = var.cloudfront_forward_cookies

  custom_error_responses = var.cloudfront_custom_error_responses

  geo_restriction_type      = var.cloudfront_geo_restriction_type
  geo_restriction_locations = var.cloudfront_geo_restriction_locations

  certificate_arn          = var.ssl_certificate_arn
  minimum_protocol_version = var.ssl_minimum_protocol_version

  web_acl_id = module.waf.web_acl_arn

  tags = local.tags
}
