resource "aws_instance" "jenkins_controller" {
  ami = "ami-006f82a1d5a27da54"

  instance_type = "t3.micro"
  //instance_type = "c7i-flex.large"

  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws_key.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_controller.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name    = "Jenkins_controller"
    Role    = "Controller"
    SSHUser = "ubuntu"
  }
}


resource "aws_instance" "jenkins_workers" {
  count = 2
  ami   = "ami-006f82a1d5a27da54"

  //instance_type = "m7i-flex.large"
  instance_type = "t3.micro"

  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws_key.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_workers.id]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name    = "Jenkins Workers"
    Role    = "Workers"
    SSHUser = "ubuntu"
  }
}

resource "aws_instance" "sonarqube_instance" {

  ami                         = "ami-006f82a1d5a27da54"
  //instance_type               = "m7i-flex.large"
  instance_type = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws_key.key_name
  vpc_security_group_ids      = [aws_security_group.sonar_qube.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name    = "sonarqube"
    Role    = "Sonarqube_worker"
    SSHUser = "ubuntu"

  }

}