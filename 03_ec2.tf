data "aws_ami" "amzn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "jwcho_web" {
  ami                         = data.aws_ami.amzn.id
  instance_type               = var.web_instance_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.jwcho_websg.id]
  availability_zone           = "${var.region}${var.avazone[0]}"
  subnet_id                   = aws_subnet.jwcho_pub[0].id
  associate_public_ip_address = true
  associate_with_private_ip = "10.0.0.101"
  user_data                   = file("install_apache.sh")
  tags = {
    "Name" = "${var.name}-web"
  }
}


resource "aws_instance" "jwcho_was" {
  ami                         = data.aws_ami.amzn.id
  instance_type               = var.was_instance_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.jwcho_websg.id]
  availability_zone           = "${var.region}${var.avazone[0]}"
  subnet_id                   = aws_subnet.jwcho_pub[0].id
  associate_public_ip_address = true
  associate_with_private_ip = "10.0.0.102"
  user_data                   = file("install_was.sh")
  tags = {
    "Name" = "${var.name}-was"
  }
}
/*
resource "aws_eip" "jwcho_web_eip" {
  vpc = true
  instance  = aws_instance.jwcho_weba
  associate_with_private_ip = "10.0.0.11"
  depends_on = [aws_internet_gateway.jwcho_igw
  ]
}
*/
#======================Security Group========================
resource "aws_security_group" "jwcho_websg" {
  name        = "WEB-sg"
  description = "http, ssh, icmp"
  vpc_id      = aws_vpc.jwcho_vpc.id
  ingress = [
    {
      description      = "ssh"
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null

      }, {
      description      = "http"
      from_port        = var.port_http
      to_port          = var.port_http
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      }, {
      description      = "icmp"
      from_port        = var.port_icmp
      to_port          = var.port_icmp
      protocol         = "icmp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      }, {
      description      = "mysql"
      from_port        = var.port_mysql
      to_port          = var.port_mysql
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }, {
      description      = "tomcat"
      from_port        = var.port_tomcat
      to_port          = var.port_tomcat
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "All"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    "Name" = "Allow-WEB"
  }
}
/*
resource "aws_security_group" "jwcho_wassg" {
  name        = "WEB-sg"
  description = "http, ssh, icmp"
  vpc_id      = aws_vpc.jwcho_vpc.id
  ingress = [
    {
      description      = "ssh"
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null

      }, {
      description      = "http"
      from_port        = var.port_http
      to_port          = var.port_http
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      }, {
      description      = "icmp"
      from_port        = var.port_icmp
      to_port          = var.port_icmp
      protocol         = "icmp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
      }, {
      description      = "mysql"
      from_port        = var.port_mysql
      to_port          = var.port_mysql
      protocol         = "tcp"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "All"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.cidr_internet]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    "Name" = "Allow-WEB"
  }
}
*/