output "route53_zone_id" {
  value       = aws_route53_zone.indevops_io.id
  description = "The ID of the Route 53 hosted zone"
}

output "route53_zone_name_servers" {
  value       = aws_route53_zone.indevops_io.name_servers
  description = "The name servers for the Route 53 hosted zone"
}

output "acm_certificate_arn" {
  value       = aws_acm_certificate.wildcard_indevops_io.arn
  description = "The ARN of the wildcard ACM certificate"
}