
resource "aws_redshift_subnet_group" "redshift_subnet_group" {

 name       = "${var.workspace_name}-redshift-snt-grp"

# subnet_ids = ["${aws_subnet.redshift_subnet.id}"]
 subnet_ids = [for subnet in aws_subnet.redshift_subnet : subnet.id]

tags = {

   Name = "${var.workspace_name}-redshift-snt-grp"

 }

}
