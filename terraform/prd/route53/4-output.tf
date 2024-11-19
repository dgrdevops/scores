output "route53_zone_id" {
  value       = aws_route53_zone.scores_xyz.id
  description = "The ID of the Route 53 hosted zone"
}

output "route53_zone_name_servers" {
  value       = aws_route53_zone.scores_xyz.name_servers
  description = "The name servers for the Route 53 hosted zone"
}

# output "acm_certificate_arn" {
#   value       = aws_acm_certificate.wildcard_scores_xyz.arn
#   description = "The ARN of the wildcard ACM certificate"
# }