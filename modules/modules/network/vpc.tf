resource "aws_vpc" "vpc_terraform" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "vpc_igw_gateway" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags = {
    Name = "vpc-terraform-igw"
  }
}