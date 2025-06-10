output "aws_instance_id" {
  value = aws_instance.Ec2-instance[*].public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.Ec2-instance[0].public_ip}:8080"
}

output "sonarquebe_url" {
  value = "http://${aws_instance.Ec2-instance[0].public_ip}:9000"
}

