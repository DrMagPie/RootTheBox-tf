variable "application" {
  description = "Name of Application"
  type        = string
  default     = "RootTheBox"
}

variable "environment" {
  description = "Environment where application is being deployed"
  type        = string
  default     = "Production"
}

variable "project" {
  description = "The Project of which application is a part of"
  type        = string
  default     = "CaptureTheFlag"
}

variable "owner" {
  description = "Owner of the application"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "AWS Hosted Zone"
  type        = string
  default     = "t3.small"
}

variable "hosted_zone" {
  description = "AWS Hosted Zone"
  type        = string
}

variable "domain" {
  description = "Domain name assinged to an instance"
  type        = string
}
