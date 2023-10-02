resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "public route"
  }
}

 

resource "aws_route_table" "public_rt2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "public route"
  }
}
resource "aws_route_table" "private1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private1"
  }
}

resource "aws_route_table" "private2" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private2"
  }
}
