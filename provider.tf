terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}