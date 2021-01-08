resource "aws_subnet" "cg_nb_sub" {
  count             = length(data.aws_availability_zones.azs.names)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id            = aws_vpc.cg_vpc.id
  cidr_block        = cidrsubnet(var.northbound_cidr_vpc, 8, count.index + 10)

  tags = {
    Name = "${var.project_name}_nb_sub_${count.index + 1}"
  }
}

resource "aws_subnet" "cg_web_sub" {
  count             = length(data.aws_availability_zones.azs.names)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id            = aws_vpc.cg_vpc.id
  cidr_block        = cidrsubnet(var.northbound_cidr_vpc, 8, count.index + 20)

  tags = {
    Name = "${var.project_name}_web_sub_${count.index + 1}"
  }
}

resource "aws_subnet" "cg_mgmt_a_sub" {
  vpc_id        = aws_vpc.cg_vpc.id
  cidr_block    = cidrsubnet(var.northbound_cidr_vpc, 8, 1)
  availability_zone = "${var.region}a"
  tags          = {
    Name = "${var.project_name}_mgmt_sub_1"
  }
}