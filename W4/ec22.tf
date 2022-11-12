cat <<EOT > ec22.tf
data "aws_ami" "beas2-amazonlinux2" {
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

resource "aws_instance" "beas-ec22" {

  ami                         = data.aws_ami.beas2-amazonlinux2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["\${aws_security_group.beas-sg.id}"]
  subnet_id                   = aws_subnet.beas-subnet2.id
  key_name = aws_key_pair.kp2.key_name
  depends_on = [
    aws_efs_mount_target.efs-mt2
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd tree tmux amazon-efs-utils -y
              systemctl start httpd && systemctl enable httpd
              echo "<html><h1>t101-beas-web server2</h1></html>" > /var/www/html/index.html
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install --bin-dir /usr/bin --install-dir /usr/bin --update
			  sudo mkdir -p /var/www/html/efs
			  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \${aws_efs_file_system.efs.dns_name}:/ /var/www/html/efs
              EOF

  user_data_replace_on_change = true
  
  
  tags = {
    Name = "t101-beas-web server2"
  }
}

output "beas-ec22_public_ip" {
  value       = aws_instance.beas-ec22.public_ip
  description = "The public IP of the Instance"
}
EOT