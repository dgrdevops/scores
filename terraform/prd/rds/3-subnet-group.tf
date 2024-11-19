resource "aws_db_subnet_group" "private_db" {
  name = "${var.env}-${var.application}-private-subnet-group"
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.private_subnet1_id,
    data.terraform_remote_state.vpc.outputs.private_subnet2_id
  ]

  tags = {
    Name = "${var.env}-${var.application}-private-subnet-group"
  }
}