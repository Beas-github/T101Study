cat <<EOT > ec2.tf
data "aws_ami" "beas-amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "beas-ec2" {

  ami                         = data.aws_ami.beas-amazonlinux2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["\${aws_security_group.beas-sg.id}"]
  subnet_id                   = aws_subnet.beas-subnet1.id
  key_name = aws_key_pair.kp1.key_name
  depends_on = [
    aws_efs_mount_target.efs-mt1
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd tree tmux amazon-efs-utils -y
              systemctl start httpd && systemctl enable httpd
              echo "<html><h1>t101-beas-web server1</h1></html>" > /var/www/html/index.html
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install --bin-dir /usr/bin --install-dir /usr/bin --update
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "t101-beas-web server1"
  }
}

output "beas-ec2_public_ip" {
  value       = aws_instance.beas-ec2.public_ip
  description = "The public IP of the Instance"
}
EOT