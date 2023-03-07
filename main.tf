terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}

# Create a VPC
resource "aws_vpc" "atproto_main" {
  cidr_block = "10.0.0.0/16"
}