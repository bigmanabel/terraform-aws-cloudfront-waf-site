output "web_acl_id" {
  description = "ID of the WAF web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_arn" {
  description = "ARN of the WAF web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_capacity" {
  description = "Capacity of the WAF web ACL"
  value       = aws_wafv2_web_acl.this.capacity
}

output "ip_sets" {
  description = "Map of created IP sets"
  value = {
    for k, v in aws_wafv2_ip_set.this : k => {
      id  = v.id
      arn = v.arn
    }
  }
}
