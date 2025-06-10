resource "aws_vpc" "Main" {
  cidr_block = var.vpc_cidr

  tags ={
    Name = "Main_vpc"
  }
}


resource "aws_subnet" "Public" {
    vpc_id = aws_vpc.Main.id
  count = var.subnet_count
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index) # 8 new bits → 256 subnets max
  availability_zone = element(var.aws_availabilty_zones, count.index % length(var.aws_availabilty_zones))
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public_subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "RTA" {
  count = var.subnet_count
  subnet_id =aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group"  "Main-sg" {
  vpc_id = aws_vpc.Main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
     }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 9000
        to_port = 9000
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
       ingress {
        from_port = 3000
        to_port = 3000
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
       egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
       }

       tags = {
         Name = "Main-SG"
       }
}
