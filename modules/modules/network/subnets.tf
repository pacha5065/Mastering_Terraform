resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr_block)
  vpc_id                  = aws_vpc.vpc_terraform.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet_cidr_block, count.index)
  availability_zone       = element(var.avialibility_zones, count.index)
  tags = {
    Name = "public_subnet_${count.index + 1}"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_terraform.id
  count             = length(var.private_subnet_cidr_block)
  cidr_block        = element(var.private_subnet_cidr_block, count.index)
  availability_zone = element(var.avialibility_zones, count.index)
  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}