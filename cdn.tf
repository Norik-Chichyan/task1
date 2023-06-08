resource "aws_cloudfront_distribution" "frontend_cdn" {
  origin {
    domain_name = aws_s3_bucket.artifactes.bucket_regional_domain_name
    origin_id   = "S3Origin"
  }

  default_cache_behavior {
    target_origin_id = "S3Origin"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }

}
