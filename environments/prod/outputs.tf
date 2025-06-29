output "website_url" {
  description = "URL of the production website"
  value       = module.static_site.website_url
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.static_site.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.static_site.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.static_site.cloudfront_domain_name
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = module.static_site.waf_web_acl_arn
}

output "waf_web_acl_capacity" {
  description = "WAF Web ACL capacity"
  value       = module.static_site.waf_web_acl_capacity
}
