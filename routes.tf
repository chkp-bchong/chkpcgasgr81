resource "aws_internet_gateway" "cg_igw" {
  vpc_id = aws_vpc.cg_vpc.id

  tags = {
    Name = "${var.project_name}_igw"
  }
}

resource "aws_route_table" "cg_nb_rt" {
  vpc_id = aws_vpc.cg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cg_igw.id
  }

  tags = {
    Name = "${var.project_name}_nb_rt"
  }
}

resource "aws_route_table" "cg_web_rt" {
  vpc_id = aws_vpc.cg_vpc.id

  tags = {
    Name = "${var.project_name}_web_rt"
  }
}

resource "aws_route_table_association" "cg_nb_sub_assoc" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = element(aws_subnet.cg_nb_sub.*.id, count.index)
  route_table_id = aws_route_table.cg_nb_rt.id
}

resource "aws_route_table_association" "cg_mgmt_sub_assoc" {
  subnet_id = aws_subnet.cg_mgmt_a_sub.id
  route_table_id = aws_route_table.cg_nb_rt.id
}

resource "aws_route_table_association" "cg_web_sub_assoc" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = element(aws_subnet.cg_web_sub.*.id, count.index)
  route_table_id = aws_route_table.cg_web_rt.id
}