
resource "aws_internet_gateway" "redshift_vpc_gw" {

 vpc_id = "${aws_vpc.redshift_vpc.id}"

tags = {

   Name = "${var.workspace_name}"

 }

depends_on = [

   aws_vpc.redshift_vpc

 ]

}
