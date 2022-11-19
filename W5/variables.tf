cat <<EOT > variable.tf
variable "instance_type_list" {
  description = "EC2 Instance Type"
  type = list(string)
  default = ["t2.micro", "t2.small", "t2.medium"]  
}
EOT