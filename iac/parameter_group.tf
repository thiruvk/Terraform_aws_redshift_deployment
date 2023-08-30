resource "aws_redshift_parameter_group" "redshift_parameter_group" {
  name        = var.workspace_name
  family      = "redshift-1.0"
  description = "${var.workspace_name}"

  parameter {
    name  = "require_ssl"
    value = "true"
  }
  
  tags = {
    Name = "${var.workspace_name}"
  }
}
