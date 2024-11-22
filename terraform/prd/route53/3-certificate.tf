resource "aws_acm_certificate" "wildcard_indevops_io" {
  domain_name       = "*.indevops.io"
  validation_method = "DNS"

  tags = {
    Name = "Wildcard Certificate for indevops.io"
  }
}

# resource "aws_route53_record" "validation_records" {
#   for_each = {
#     for dvo in aws_acm_certificate.wildcard_indevops_io.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.indevops_io.zone_id
# }

# resource "aws_acm_certificate_validation" "wildcard_validation" {
#   certificate_arn         = aws_acm_certificate.wildcard_indevops_io.arn
#   validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
# }