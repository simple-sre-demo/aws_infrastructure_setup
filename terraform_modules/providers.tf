# aws_setup/providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Configure the S3 backend here
  backend "s3" {
    bucket         = "d-ec1-sre-s3-bucket-aws-setup-tfstate"
    key            = "tfstate/terraform.tfstate" # Path to your state file within the bucket
    region         = "eu-central-1"
    dynamodb_table = "d-ec1-sre-dynamo-aws-setup-tf-lock" # REPLACE WITH YOUR DYNAMODB TABLE NAME
    encrypt        = true # Encrypt the state file at rest
  }
}

provider "aws" {
  region = var.region
}