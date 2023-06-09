#S3 provisioning
resource "aws_s3_bucket" "artifactes" {
  bucket = "artifactes-bucket-${random_id.name-prefix.hex}"
}

resource "aws_s3_bucket_public_access_block" "artifacte_public" {
  bucket = aws_s3_bucket.artifactes.id
}

resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.artifactes.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "front" {
  bucket = aws_s3_bucket_versioning.versioning_enable.id
  key    = "front/"
  depends_on = [aws_s3_bucket.artifactes]
}

resource "aws_s3_object" "back" {
  bucket = aws_s3_bucket_versioning.versioning_enable.id
  key    = "back/"
  depends_on = [aws_s3_bucket.artifactes]
}
data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.artifactes.arn,
      "${aws_s3_bucket.artifactes.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }

  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.artifactes.arn,
      "${aws_s3_bucket.artifactes.arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.id}:distribution/${aws_cloudfront_distribution.cf_dist.id}"
      ]
    }
  }

}


