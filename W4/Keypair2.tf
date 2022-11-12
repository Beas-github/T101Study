cat <<EOT > keypair2.tf
# RSA 알고리즘을 이용해 private 키 생성.
resource "tls_private_key" "pk2" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# private 키를 가지고 keypair 파일 생성.
resource "aws_key_pair" "kp2" {
  key_name   = "t101-beas-kp2"
  public_key = tls_private_key.pk2.public_key_openssh
}

# 키 파일을 생성하고 로컬에 다운로드.
resource "local_file" "ssh_key2" {
  filename = "\${aws_key_pair.kp2.key_name}.pem"
  content  = tls_private_key.pk2.private_key_pem
}
EOT