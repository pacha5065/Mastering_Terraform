cidr_block                = "10.0.0.0/16"
public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr_block = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
portslist                 = [80, 8080, 443, 22]
region                    = "ap-south-1"
avialibility_zones        = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
vpc_name                  = "vpc-terraform"
# vpc_id = mo
ami = {
  "ap-south-1"   = "ami-002f6e91abff6eb96"
  "eu-central-1" = "ami-0ecf75a98fe8519d7"
}
instance_type = {
  "ap-south-1"   = "t3.micro"
  "eu-central-1" = "t3.micro"
}