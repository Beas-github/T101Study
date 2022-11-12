cat <<EOT > sg-efs.tf
resource "aws_security_group" "beas-sg-efs" {
   vpc_id      = aws_vpc.beas-vpc.id
   name        = "T101-beas-SG-efs"
   description = "T101-beas-SG-efs"

   ingress {
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
	 cidr_blocks       = ["0.0.0.0/0"]
   }     
        
   egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
	 cidr_blocks       = ["0.0.0.0/0"]
   }
 }

EOT
 
