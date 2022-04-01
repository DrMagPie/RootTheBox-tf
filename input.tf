variable "owner" {
  description = "Email of applications owner"
  type        = string
}

variable "project" {
  description = "The Project of which application is a part of"
  type        = string
}

variable "application" {
  description = "Name of Application"
  type        = string
}

variable "environment" {
  description = "Environment where application is being deployed"
  type        = string
}


variable "domain" {
  description = "Domain name assinged to an instance"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}
variable "aws_hosted_zone" {
  description = "AWS Hosted Zone"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS Hosted Zone"
  type        = string
  default     = "t3.small"
}


