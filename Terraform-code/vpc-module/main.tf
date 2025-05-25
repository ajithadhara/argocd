module "vpc" {
  source = "./vpc-module"
  vpc_cidr = var.vpc_cidr
  subnet_count = var.subnet_count
  aws_availabilty_zones = var.aws_availabilty_zones

}

module "ec2" {
  source = "./ec2-module"
  ami = var.ami
  instance_type = var.instance_type
  ec2_count = var.ec2_count
  subnet_ids = module.vpc.subnets_ids
  security_groups_id = module.vpc.security_group_id
  key_name = var.key_name
  volume_size = var.volume_size
  volume_type = var.volume_type
}
