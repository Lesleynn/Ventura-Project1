
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Ventura-Prod-VPC"
  }
}
#resource "aws_subnet" "main" {
#vpc_id     = aws_vpc.main.id
# cidr_block = "10.0.1.0/24"
#tags = {
# Name = "Main"
#}
#}

resource "aws_internet_gateway" "ventura-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ventura-igw"
  }
}


resource "aws_subnet" "ventura-prod-subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "Ventura-Prod-NAT-ALB-Subnet1"
  }
}

resource "aws_subnet" "ventura-prod-subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[1]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "Ventura-Prod-ALB-Subnet2"
  }
}

resource "aws_subnet" "ventura-prod-subnet3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "Ventura-Prod-Web-Subnet1"
  }
}
resource "aws_subnet" "ventura-prod-subnet4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[1]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "Ventura-Prod-Web-Subnet2"
  }
}

resource "aws_subnet" "ventura-prod-subnet5" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[2]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "Ventura-Prod-App-Subnet1"
  }
}

resource "aws_subnet" "ventura-prod-subnet6" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[3]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "Ventura-Prod-App-subnet2"
  }
}

resource "aws_subnet" "ventura-prod-subnet7" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[4]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "Ventura-Prod-DB-Subnet1"
  }
}

resource "aws_subnet" "ventura-prod-subnet8" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[5]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "Ventura-Prod-DB-Subnet2"
  }
}

resource "aws_nat_gateway" "example-1a" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.ventura-prod-subnet1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ventura-igw]
}

resource "aws_nat_gateway" "example-1b" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.ventura-prod-subnet2.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ventura-igw]
}

resource "aws_eip" "lb" {
  instance   = aws_instance.web.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ventura-igw]
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[0]
  tags          = var.tags
}

resource "aws_instance" "web1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[1]
  tags          = var.tags
}

resource "aws_security_group" "allow_tls" {
  name        = var.aws_security_group.les
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}