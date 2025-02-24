terraform {
  required_version = ">=1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.1"
    }
  }
  # backend "s3" {
  #   bucket = ""
  #   key    = "terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Name        = var.app_name
      Environment = var.env
    }
  }
}