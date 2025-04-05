resource "aws_vpc" "vpc-Terraform" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name       = "vpc-terraform"
    costCenter = local.costCenter
    TeamName   = local.TeamName
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr_block)
  vpc_id                  = aws_vpc.vpc-Terraform.id
  cidr_block              = element(var.public_subnet_cidr_block, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name       = "public_subnet-${count.index + 1}"
    costCenter = local.costCenter
    TeamName   = local.TeamName

  }

}

resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnet_cidr_block)
  vpc_id     = aws_vpc.vpc-Terraform.id
  cidr_block = element(var.private_subnet_cidr_block, count.index)

  tags = {
    Name       = "private_subnet-${count.index + 1}"
    costCenter = local.costCenter
    TeamName   = local.TeamName
  }

}

resource "aws_internet_gateway" "IGW-terraform" {
  vpc_id = aws_vpc.vpc-Terraform.id

  tags = {
    Name       = "vpc-terraform-igw"
    costCenter = local.costCenter
    TeamName   = local.TeamName
  }
}

resource "aws_route_table" "public_rtb_terraform" {
  vpc_id = aws_vpc.vpc-Terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-terraform.id
  }

}

resource "aws_route_table_association" "public_rtb_associate" {
  count          = length(var.public_subnet_cidr_block)
  route_table_id = aws_route_table.public_rtb_terraform.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}

resource "aws_route_table" "private_rtb_terraform" {
  vpc_id = aws_vpc.vpc-Terraform.id
}

resource "aws_route_table_association" "private_rtb_associate" {
  count          = length(var.private_subnet_cidr_block)
  route_table_id = aws_route_table.private_rtb_terraform.id
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
}

resource "aws_instance" "public_instance" {
  count         = (var.region == "ap-south-1") ? 3 : 1
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  instance_type = var.instance_type
  ami           = lookup(var.amis, var.region)
  
  availability_zone = element(aws_subnet.public_subnet.*.availability_zone, count.index) 

  tags = {
    Name = "public-instance-${count.index + 1}"
  }

}