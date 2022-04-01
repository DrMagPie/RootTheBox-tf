provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Application = var.application
      Environment = var.environment
      Project     = var.project
      Owner       = var.owner
    }
  }
}
terraform {
  required_version = ">= 1.1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}
