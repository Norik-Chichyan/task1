resource "aws_cognito_user_pool" "user_pool" {
  name = "your-user-pool-name"
  # Add any additional configuration options as needed
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                   = "your-user-pool-client-name"
  user_pool_id           = aws_cognito_user_pool.user_pool.id
  generate_secret        = true
  allowed_oauth_flows    = ["code"]
  allowed_oauth_scopes   = ["openid", "email"]
  callback_urls          = ["https://your-app.com/callback"]
  supported_identity_providers = ["COGNITO"]
}
