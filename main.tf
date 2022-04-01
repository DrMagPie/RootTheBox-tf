module "aws" {
  source = "./aws"

  owner         = var.owner
  project       = var.project
  application   = var.application
  environment   = var.environment
  domain        = var.domain
  region        = var.aws_region
  hosted_zone   = var.aws_hosted_zone
  instance_type = var.aws_instance_type
}
