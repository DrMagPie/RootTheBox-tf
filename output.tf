output "domain" {
  value = "http://${var.domain}"
}

output "ip" {
  value = module.aws.ip
}
