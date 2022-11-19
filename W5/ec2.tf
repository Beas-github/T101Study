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
  instance_type               = var.instance_type_list[count.index]
  vpc_security_group_ids      = ["\${aws_security_group.beas-sg.id}"]
  subnet_id                   = aws_subnet.beas-subnet1.id
  
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
  
  count = 3
  tags = {
    Name = "t101-beas-web server1-\${count.index}"
  }
}

output "beas-ec2_public_ip" {
  value       = [for instance in aws_instance.beas-ec2: instance.public_dns]
  description = "The public IP of the Instance"
}
EOT