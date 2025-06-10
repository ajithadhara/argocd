output "subnets_ids" {
  value = aws_subnet.Public[*].id
}

output "vpc_id" {
  value = aws_vpc.Main.id
}

output "security_group_id" {
  value = aws_security_group.Main-sg.id
}
