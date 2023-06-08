#S3 provisioning
resource "aws_s3_bucket" "artifactes" {
  bucket = "example-bucket"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.artifactes.id
  acl    = "private"
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