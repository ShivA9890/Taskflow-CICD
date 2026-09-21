resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "taskflow_credentials"
}

resource "aws_secretsmanager_secret_version" "db_secret_v" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "taskflow_admin"
    password = random_password.db_password.result
  })

}