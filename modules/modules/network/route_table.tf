resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw_gateway.id

  }
}

resource "aws_route_table_association" "public_rtb_associate" {
  count          = length(var.public_subnet_cidr_block)
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc_terraform.id
}

resource "aws_route_table_association" "private_rtb_associate" {
  count          = length(var.private_subnet_cidr_block)
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
}