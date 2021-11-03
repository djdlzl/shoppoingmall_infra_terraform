resource "aws_eip" "lb_ip" {
  #instance = aws_instace.web.id
  vpc = true
  tags = {
    "Name" = "${var.name}-IP"
  }
}

resource "aws_nat_gateway" "jwcho_nga" {
  allocation_id = aws_eip.lb_ip.id
  subnet_id     = aws_subnet.jwcho_pub[0].id
  tags = {
    "Name" = "${var.name}-nga"
  }
}

resource "aws_route_table" "jwcho_ngart" {
  vpc_id = aws_vpc.jwcho_vpc.id
  route {
    cidr_block = var.cidr_internet
    gateway_id = aws_nat_gateway.jwcho_nga.id
  }
  tags = {
    "Name" = "${var.name}-natrt"
  }
}


resource "aws_route_table_association" "jwcho_ngarta" {
  count          = length(var.private_s)
  subnet_id      = aws_subnet.jwcho_pri[count.index].id
  route_table_id = aws_route_table.jwcho_ngart.id
}

