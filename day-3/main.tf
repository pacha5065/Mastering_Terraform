resource "aws_vpc" "vpc-terraform" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "Igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_route_table" "RTB-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw-terraform.id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "rtb-associate" {
  route_table_id = aws_route_table.RTB-terraform.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_security_group" "security-grp-terraform" {
  name   = "allow-all"
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = var.sec_grp_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_rule" {
  security_group_id = aws_security_group.security-grp-terraform.id
  ip_protocol       = "tcp"
  from_port         = "0"
  to_port           = "0"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  security_group_id = aws_security_group.security-grp-terraform.id
  ip_protocol       = -1
  from_port         = "0"
  to_port           = "0"
  cidr_ipv4         = "0.0.0.0/0"
}