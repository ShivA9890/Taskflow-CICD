output "controller_public_ip" {
  value = aws_instance.jenkins_controller.public_ip
}

output "worker_public_ip" {
  value = aws_instance.jenkins_workers[*].public_ip
}