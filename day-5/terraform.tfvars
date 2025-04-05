region                    = "ap-south-1"
vpc_cidr_block            = "10.0.0.0/16"
public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr_block = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
instance_type             = "t2.micro"
amis = {
  "ap-south-1"   = "ami-002f6e91abff6eb96"
  "eu-central-1" = "ami-02cd5b9bfb2512340"
}