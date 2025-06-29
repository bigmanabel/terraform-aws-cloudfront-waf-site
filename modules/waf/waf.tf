resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_name
          vendor_name = rule.value.vendor_name

          dynamic "excluded_rule" {
            for_each = rule.value.excluded_rules
            content {
              name = excluded_rule.value
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.rate_limit_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = rule.value.aggregate_key_type
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.ip_set_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        ip_set_reference_statement {
          arn = rule.value.ip_set_arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.metric_name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "this" {
  count        = var.associate_with_resource && var.resource_arn != null ? 1 : 0
  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

resource "aws_wafv2_ip_set" "this" {
  for_each = var.ip_sets

  name               = each.value.name
  description        = each.value.description
  scope              = var.scope
  ip_address_version = each.value.ip_address_version
  addresses          = each.value.addresses

  tags = var.tags
}
