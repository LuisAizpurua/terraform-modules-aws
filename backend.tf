terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket = "demo-terrafom-s3"
  #   key = "envs/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
}