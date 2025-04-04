terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }
  required_version = "~> 1.2"
}

provider "aws" {
  region = "ap-south-1"
}