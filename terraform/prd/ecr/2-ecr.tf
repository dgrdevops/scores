resource "aws_ecr_repository" "scores_repo" {
  name                 = "${var.env}-${var.application}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
