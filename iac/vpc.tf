
#
resource "aws_vpc" "redshift_vpc" {

 cidr_block       = "${var.rs_vpc_cidr}"
 #cidr_block       = "10.70.0.0/16"

 instance_tenancy = "default"

tags = {

   Name = "${var.workspace_name}"

 }

}
