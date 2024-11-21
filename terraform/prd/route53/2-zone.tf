resource "aws_route53_zone" "indevops_io" {
  name    = "indevops.io"
  comment = "Public hosted zone for indevops.io"
}