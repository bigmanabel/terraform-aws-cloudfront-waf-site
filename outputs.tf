# S3 Outputs
output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = module.s3.website_endpoint
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = module.cloudfront.distribution_arn
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront Route 53 zone ID"
  value       = module.cloudfront.distribution_hosted_zone_id
}

# WAF Outputs
output "waf_web_acl_id" {
  description = "ID of the WAF web ACL"
  value       = module.waf.web_acl_id
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF web ACL"
  value       = module.waf.web_acl_arn
}

output "waf_web_acl_capacity" {
  description = "Capacity of the WAF web ACL"
  value       = module.waf.web_acl_capacity
}

# Convenience Outputs
output "website_url" {
  description = "URL of the website"
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

# Legacy Outputs (for backward compatibility)
output "bucket_name" {
  description = "Name of the S3 bucket (legacy)"
  value       = module.s3.bucket_name
}

output "cloudfront_url" {
  description = "CloudFront distribution domain name (legacy)"
  value       = module.cloudfront.distribution_domain_name
}

output "waf_acl_arn" {
  description = "ARN of the WAF web ACL (legacy)"
  value       = module.waf.web_acl_arn
}