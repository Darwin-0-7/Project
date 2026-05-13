terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # We removed the region line. 
  # Terraform will now automatically use the "ap-south-1" 
  # you set in your PowerShell environment variables.
}