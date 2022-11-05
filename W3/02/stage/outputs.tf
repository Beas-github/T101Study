cat <<EOT > outputs.tf
output "address" {
  value       = aws_db_instance.beas-rds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.beas-rds.port
  description = "The port the database is listening on"
}

output "vpcid" {
  value       = aws_vpc.beas-vpc.id
  description = "My VPC Id"
}
EOT