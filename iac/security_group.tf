resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = aws_vpc.redshift_vpc.id

  dynamic "ingress" {
    for_each = var.ip_ingress_ranges
    content {
      from_port   = 5439
      to_port     = 5439
      protocol    = "tcp"
      cidr_blocks = [ingress.value[0]]
      description = ingress.value[1]
    }
  }

  dynamic "egress" {
    for_each = var.ip_egress_ranges
    content {
      from_port   = 5439
      to_port     = 5439
      protocol    = "tcp"
      cidr_blocks = [egress.value[0]]
      description = egress.value[1]
    }
  }

  tags = {
    Name = "${var.workspace_name}-sg"
  }

  depends_on = [
    aws_vpc.redshift_vpc
  ]
}
