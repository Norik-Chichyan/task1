variable "bucket_prefix" {
  type        = string
  description = "The prefix for the S3 bucket"
  default     = "tf-s3-website-"
}
variable "domain_name" {
  type        = string
  description = "The domain name to use"
  default     = "mytest.domain.mine"
}
variable "front_file_name" {
  type        = string
  description = "Fontend web-site file name in S3 bucket"
  default     = "index.html"
}

variable "lambda_runtime" {
  type        = string
  description = "runtime for lambda backend"
  default     = "python3.9"
}

variable "s3_backend" {
  type        = string
  description = "Backend code files"
  default     = "back/backend_code.zip""
}