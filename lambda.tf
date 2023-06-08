data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_rds_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_elasticache_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_security_group" "lambda-sg" {
  name_prefix = "lambda-sg"
  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lambda_function" "back_lambda_function" {
  function_name = "my-lambda-function"
  handler       = "index.handler"
  runtime       = "python3.8"
  timeout       = 60
  memory_size   = 128
  role          = aws_iam_role.iam_for_lambda.arn
  vpc_config {
    subnet_ids         = [aws_subnet.lambda.id]
    security_group_ids = [aws_security_group.lambda-sg.id]
  }
  # Specify the S3 bucket and object key for the Lambda code
  s3_bucket = aws_s3_bucket.artifactes.id
  s3_key    = "back/backend_code"
}

