variable "bucket_prefix" {
  type        = string
  description = "The prefix for the S3 bucket"
  default     = "tf-s3-website-"
}
variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "demo.hands-on-cloud.com"
}
