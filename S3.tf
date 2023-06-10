#S3 provisioning
resource "aws_s3_bucket" "artifactes" {
  bucket = "artifactes-bucket-${random_id.name-prefix.hex}"
}

#resource "aws_s3_bucket_public_access_block" "artifacte_public" {
#  bucket = aws_s3_bucket.artifactes.id
#}

resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.artifactes.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "front" {
  bucket     = aws_s3_bucket_versioning.versioning_enable.id
  key        = "index.html"
  source     = "index.html"
  depends_on = [aws_s3_bucket.artifactes]
}

resource "aws_s3_object" "front_error" {
  bucket     = aws_s3_bucket_versioning.versioning_enable.id
  key        = "error.html"
  source     = "error.html"
  depends_on = [aws_s3_bucket.artifactes]
}

resource "aws_s3_object" "back" {
  bucket     = aws_s3_bucket_versioning.versioning_enable.id
  key        = "back/backend_code.zip"
  source     = "back/backend_code.zip"
  depends_on = [aws_s3_bucket.artifactes]
}
#data "aws_iam_policy_document" "bucket_policy_document" {
#  statement {
#    actions = ["s3:GetObject"]
#    resources = [
#      aws_s3_bucket.artifactes.arn,
#      "${aws_s3_bucket.artifactes.arn}/*"
#    ]
#    principals {
#      type        = "AWS"
#      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
#    }
#  }
#
#  statement {
#    actions = ["s3:GetObject"]
#    resources = [
#      aws_s3_bucket.artifactes.arn,
#      "${aws_s3_bucket.artifactes.arn}/*"
#    ]
#    principals {
#      type        = "Service"
#      identifiers = ["cloudfront.amazonaws.com"]
#    }
#    condition {
#      test     = "StringEquals"
#      variable = "AWS:SourceArn"
#
#      values = [
#        "arn:aws:cloudfront::${data.aws_caller_identity.current.id}:distribution/${aws_cloudfront_distribution.cf_dist.id}"
#      ]
#    }
#  }
#
#}

resource "aws_s3_bucket_website_configuration" "my_web_site" {
  bucket = aws_s3_bucket.artifactes.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "my_policy" {
  bucket     = aws_s3_bucket.artifactes.id
  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowInternetAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
            "s3:GetObject",
            "s3:ListBucket"
      ],
      "Resource": [
            "${aws_s3_bucket.artifactes.arn}/*",
            "${aws_s3_bucket.artifactes.arn}"
      ]
    },
    {
      "Sid": "AllowLambdaAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.artifactes.id}/*"
    },
    {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.artifactes.id}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cf_dist.id}"
            }
        }
    }

  ]
}
EOF
  depends_on = [aws_s3_bucket.artifactes]
}