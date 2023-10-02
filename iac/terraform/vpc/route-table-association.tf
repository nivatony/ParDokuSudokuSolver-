# Assuming you have subnet resources defined
resource "aws_subnet" "public_subnet_1" {
  # Configuration for public subnet 1
}

resource "aws_subnet" "public_subnet_2" {
  # Configuration for public subnet 2
}

resource "aws_subnet" "private_subnet_1" {
  # Configuration for private subnet 1
}

resource "aws_subnet" "private_subnet_2" {
  # Configuration for private subnet 2
}

# Assuming you have declared the above resources, you can now create route table associations
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private2.id
}
