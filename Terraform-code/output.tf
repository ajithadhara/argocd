output "ec2_public_ips" {
  value = module.ec2.aws_instance_id
}

output "subnets_ids" {
  value = module.vpc.subnets_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_id" {
  value = module.vpc.security_group_id
}

output "jenkins_url" {
  value = module.ec2.jenkins_url
}

output "sonarqube_url" {
  value = module.ec2.sonarquebe_url
}
