resource "aws_key_pair" "aws_key" {
  key_name   = "AWS_login_key"
  public_key = file("../keys/aws_login_key.pub")


}