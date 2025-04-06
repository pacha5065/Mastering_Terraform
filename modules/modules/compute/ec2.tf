resource "aws_instance" "ec2_instance" {
  count = (var.region == "ap-south-1") ? 3 : 1

  ami           = lookup(var.ami, var.region)
  instance_type = lookup(var.instance_type, var.region)

  subnet_id = element(var.public_subnet, count.index)

  tags = {
    Name = "publci_ec2_instance_${count.index}"
  }

}