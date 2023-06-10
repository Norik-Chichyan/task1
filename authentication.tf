resource "aws_cognito_user_pool" "user_pool" {
  name = "employees"

}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                         = "your-user-pool-client-name"
  user_pool_id                 = aws_cognito_user_pool.user_pool.id
  generate_secret              = true
  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["openid", "email"]
  callback_urls                = ["https://${aws_s3_bucket.artifactes.id}/front/${var.front_file_name}"]
  supported_identity_providers = ["COGNITO"]
  depends_on                   = [aws_s3_bucket.artifactes]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "my-domain${random_id.name-prefix.hex}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
