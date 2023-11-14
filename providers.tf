terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ">= 3.5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  ignore_tags {
    keys = [
      "Created by",
      "Creation Date",
      "IAM Role Name",
      "IAM User Name"
    ]
  }
}

