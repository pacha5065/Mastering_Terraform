terraform {
  backend "s3" {
    bucket = "prem-terraform-learning-day-1"
    key    = "Day-2/day-2.tfstate"
    region = "ap-south-1"
  }
}