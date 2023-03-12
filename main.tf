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

# for Cloudfront Certification
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}
