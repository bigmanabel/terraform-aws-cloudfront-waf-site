variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "owner_email" {
  description = "Email of the project owner"
  type        = string
  default     = ""
}
