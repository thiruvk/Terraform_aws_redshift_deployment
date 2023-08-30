data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "redshift_subnet" {
  count                   = var.multi_az ? length(data.aws_availability_zones.available.names) : 1
  vpc_id                  = aws_vpc.redshift_vpc.id
  cidr_block              = var.multi_az ? element(local.subnet_cidr, count.index) : local.subnet_cidr[0]
  availability_zone       = var.multi_az ? element(data.aws_availability_zones.available.names, count.index) : data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.workspace_name}-public-${count.index}"
  }
  
  lifecycle {
    ignore_changes = [
      cidr_block
    ]
  }
}

locals {
  vpc_cidr_parts    = split("/", var.rs_vpc_cidr)
  vpc_prefix_length = try(tonumber(local.vpc_cidr_parts[1]), 0)

  subnet_cidr = var.multi_az ? [
    for i in range(length(data.aws_availability_zones.available.names)) :
    cidrsubnet(var.rs_vpc_cidr, 4, i + 4 + 16 * pow(2, 16 - local.vpc_prefix_length - 4))
  ] : [var.rs_vpc_cidr]

}
