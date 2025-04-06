resource "aws_security_group" "sec_group" {
  vpc_id = var.vpc_id
}


resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  count             = length(var.portslist)
  security_group_id = aws_security_group.sec_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = var.cidr_block
  from_port         = element(var.portslist, count.index)
  to_port           = element(var.portslist, count.index)
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.sec_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}