provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "vpc-terraform" {
  id = var.vpc_id
}

data "aws_subnet" "public-subnet-1" {
  id = var.subnet_id
}


resource "aws_instance" "ec2-terraform" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public-subnet-1.id
  tags = {
    Name = "ec2-terraform"
  }
}