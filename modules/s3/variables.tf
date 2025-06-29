variable "bucket_name" {
  description = "Name of the S3 bucket for static site hosting"
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

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block public access to the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_cloudfront_access" {
  description = "Enable CloudFront access to the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_public_access" {
  description = "Enable public access to the S3 bucket (for direct access without CloudFront)"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution for OAC"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
