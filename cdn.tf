#module "cdn" {
#  source = "terraform-aws-modules/cloudfront/aws"
#
#  aliases = ["cdn.example.com"]
#
#  comment             = "My awesome CloudFront"
#  enabled             = true
#  is_ipv6_enabled     = true
#  price_class         = "PriceClass_All"
#  retain_on_delete    = false
#  wait_for_deployment = false
#
#  create_origin_access_identity = true
#  origin_access_identities = {
#    s3_bucket_one = "My awesome CloudFront can access"
#  }
#
#  logging_config = {
#    bucket = "logs-my-cdn.s3.amazonaws.com"
#  }
#
#  origin = {
#    s3_one = {
#      domain_name = "my-s3-bycket.s3.amazonaws.com"
#      s3_origin_config = {
#        origin_access_identity = "s3_bucket_one"
#      }
#    }
#  }
#
#  default_cache_behavior = {
#    target_origin_id       = "something"
#    viewer_protocol_policy = "allow-all"
#
#    allowed_methods = ["GET", "HEAD", "OPTIONS"]
#    cached_methods  = ["GET", "HEAD"]
#    compress        = true
#    query_string    = true
#  }
#
#  ordered_cache_behavior = [
#    {
#      path_pattern           = "/static/*"
#      target_origin_id       = "s3_one"
#      viewer_protocol_policy = "redirect-to-https"
#
#      allowed_methods = ["GET", "HEAD", "OPTIONS"]
#      cached_methods  = ["GET", "HEAD"]
#      compress        = true
#      query_string    = true
#    }
#  ]
#
#  viewer_certificate = {
#    acm_certificate_arn = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
#    ssl_support_method  = "sni-only"
#  }
#}
#
#resource "aws_cloudfront_distribution" "this" {
#  origin {
#    domain_name = local.s3_origin_domain_name
#    #origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#    origin_id = local.s3_origin_id
#  }
#  viewer_certificate {
#    cloudfront_default_certificate = true
#  }
#  enabled = true
#  default_cache_behavior {
#    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#    cached_methods   = ["GET", "HEAD"]
#    target_origin_id = local.s3_origin_id
#
#    forwarded_values {
#      query_string = false
#
#      cookies {
#        forward = "none"
#      }
#    }
#
#    viewer_protocol_policy = "allow-all"
#    min_ttl                = 0
#    default_ttl            = 3600
#    max_ttl                = 86400
#  }
#
#  restrictions {
#    geo_restriction {
#      restriction_type = "whitelist"
#      locations        = ["US", "CA", "GB", "DE"]
#    }
#  }
#}


resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  aliases             = [var.domain_name]
  default_root_object = "website/index.html"
  origin {
    domain_name = aws_s3_bucket.artifactes.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.artifactes.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.artifactes.id
    viewer_protocol_policy = "redirect-to-https" # other options - https only, http
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = {
    "Project"   = "hands-on.cloud"
    "ManagedBy" = "Terraform"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

