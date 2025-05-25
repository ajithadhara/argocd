resource "aws_instance" "Ec2-instance" {
  count = var.ec2_count
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_groups_id]
  subnet_id = element(var.subnet_ids, count.index)
  user_data = file("${path.module}/setup.sh")
  associate_public_ip_address = true
  key_name = var.key_name
 

 root_block_device {
   volume_size = var.volume_size
   volume_type = var.volume_type
   delete_on_termination = true
 }

tags = {
  Name= "Devsecop-server-${count.index}"
}


}

