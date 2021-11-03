provider "aws" {
  region = var.region
}
/*
#============================key pair================================
resource "aws_key_pair" "jwcho_key" {
  key_name   = var.key
  public_key = file("../../../.ssh/id_rsa.pub")
}
*/
#============================vpc================================
resource "aws_vpc" "jwcho_vpc" {
  cidr_block = var.cidr_main
  tags = {
    "Name" = "${var.name}-vpc"
  }
}


#============================subnet================================
#AZ-a / public subnet
resource "aws_subnet" "jwcho_pub" {
  count             = length(var.public_s)
  vpc_id            = aws_vpc.jwcho_vpc.id
  cidr_block        = var.public_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"

  tags = {
    Name = "final-${var.name}-pub-${var.avazone[count.index]}"
  }
}
#AZ-a / private subnet
resource "aws_subnet" "jwcho_pri" {
  count             = length(var.private_s)
  vpc_id            = aws_vpc.jwcho_vpc.id
  cidr_block        = var.private_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"

  tags = {
    Name = "final-${var.name}-pri-${var.avazone[count.index]}"
  }
}
#AZ-c / db subnet
resource "aws_subnet" "jwcho_db" {
  count             = length(var.db_s)
  vpc_id            = aws_vpc.jwcho_vpc.id
  cidr_block        = var.db_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"

  tags = {
    Name = "final-${var.name}-db-${var.avazone[count.index]}"
  }
}

#================================igw===================================
resource "aws_internet_gateway" "jwcho_igw" {
  vpc_id = aws_vpc.jwcho_vpc.id

  tags = {
    Name = "jwcho-igw"
  }
}
#================================rt, rt association======================
resource "aws_route_table" "jwcho_rt" {
  vpc_id = aws_vpc.jwcho_vpc.id

  route {
    cidr_block = var.cidr_internet
    gateway_id = aws_internet_gateway.jwcho_igw.id
  }
  tags = {
    "Name" = "jwcho-rt"
  }
}

resource "aws_route_table_association" "jwcho_rtas" {
  count          = 2
  subnet_id      = aws_subnet.jwcho_pub[count.index].id
  route_table_id = aws_route_table.jwcho_rt.id
}
