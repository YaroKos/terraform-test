terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    template = {
      source = "hashicorp/template"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

resource "aws_default_vpc" "default" {
  
}