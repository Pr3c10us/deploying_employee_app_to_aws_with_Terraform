data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "employee-vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    "Name" = "employee-vpc"
  }  
}

resource "aws_internet_gateway" "employee-igw" {
  vpc_id = aws_vpc.employee-vpc.id

  tags = {
    "Name" = "employee-igw"
  }
}

resource "aws_subnet" "employee-subnet" {
  vpc_id = aws_vpc.employee-vpc.id
  for_each = {
    "employee Public Subnet 1" = [ data.aws_availability_zones.available.names[0], "10.1.1.0/24" , true]
    "employee Public Subnet 2" = [ data.aws_availability_zones.available.names[1], "10.1.2.0/24" , true ]
    "employee Private Subnet 1" = [ data.aws_availability_zones.available.names[0], "10.1.3.0/24" , false ]
    "employee Private Subnet 2" = [ data.aws_availability_zones.available.names[1], "10.1.4.0/24", false ]
  }

  availability_zone = each.value[0]
  cidr_block = each.value[1]
  map_public_ip_on_launch = each.value[2]

  tags = {
    "Name" = each.key
  }
}

resource "aws_route_table" "employee-prt" {
  vpc_id = aws_vpc.employee-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.employee-igw.id
  }

  tags = {
    "Name" = "employee-prt"
  }
}

resource "aws_route_table_association" "empoloyee-prta" {
  for_each = {
    "employee Public Subnet 1" = aws_subnet.employee-subnet["employee Public Subnet 1"].id
    "employee Public Subnet 2" = aws_subnet.employee-subnet["employee Public Subnet 2"].id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.employee-prt.id
}

resource "aws_route_table" "employee-pprt" {
  vpc_id = aws_vpc.employee-vpc.id

  tags = {
    "Name" = "employee-pprt"
  }
}

resource "aws_route_table_association" "empoloyee-pprta" {
  for_each = {
    "employee Private Subnet 1" = aws_subnet.employee-subnet["employee Private Subnet 1"].id
    "employee Private Subnet 2" = aws_subnet.employee-subnet["employee Private Subnet 2"].id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.employee-pprt.id
}

resource "aws_security_group" "employee-sg" {
  name = "employee-sg"
  vpc_id = aws_vpc.employee-vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "employee-sg"
  }
}

resource "aws_security_group_rule" "employee-ingress" {
  for_each = {
    ssh = {
      description = "SSH inboud rule"
      from_port = 22
      to_port = 22
    }
    HTTP = {
      description = "SSH inboud rule"
      from_port = 80
      to_port = 80
    }
    HTTPS = {
      description = "SSH inboud rule"
      from_port = 443
      to_port = 443
    }
  }
    type = "ingress"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = each.value.description
    from_port = each.value.from_port
    ipv6_cidr_blocks = [ "::/0" ]
    protocol = "tcp"
    to_port = each.value.to_port
    security_group_id = aws_security_group.employee-sg.id
}