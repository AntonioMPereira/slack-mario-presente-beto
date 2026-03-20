variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "pessoal"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "mario-slackware"
}
