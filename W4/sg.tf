cat <<EOT > sg.tf
resource "aws_security_group" "beas-sg" {
  vpc_id      = aws_vpc.beas-vpc.id
  name        = "T101-beas-SG"
  description = "T101-beas-SG"
}

resource "aws_security_group_rule" "beas-sg-inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.beas-sg.id
}

resource "aws_security_group_rule" "beas-sg-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.beas-sg.id
}
EOT