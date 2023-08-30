resource "aws_route_table_association" "redshift_vpc_rta" {
  subnet_id      = aws_subnet.redshift_subnet[0].id
  route_table_id = aws_vpc.redshift_vpc.main_route_table_id
}

# Route
resource "aws_route" "redshift_vpc_route" {
  route_table_id         = aws_vpc.redshift_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.redshift_vpc_gw.id
}
