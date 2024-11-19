resource "aws_route53_zone" "scores_xyz" {
  name    = "scores.xyz"
  comment = "Public hosted zone for scores.xyz"
}

resource "aws_route53_zone" "dgrdevops" {
  name    = "dgrdevops.com"
  comment = "Public hosted zone for dgrdevops.com"
}