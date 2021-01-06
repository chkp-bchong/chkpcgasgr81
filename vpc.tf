resource "aws_vpc" "cg_vpc" {
  cidr_block = var.northbound_cidr_vpc
  tags = {
    Name = "${var.project_name}_vpc"
  }
}