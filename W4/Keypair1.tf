cat <<EOT > keypair1.tf
resource "tls_private_key" "pk1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "kp1" {
  key_name   = "t101-beas-kp1"
  public_key = tls_private_key.pk1.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "\${aws_key_pair.kp1.key_name}.pem"
  content  = tls_private_key.pk1.private_key_pem
}
EOT