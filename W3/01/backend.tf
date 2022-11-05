cat <<EOT > backend.tf
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "beas-s3bucket" {
  bucket = "$NICKNAME-t101study-tfstate-w3"
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "beas-s3bucket_versioning" {
  bucket = aws_s3_bucket.beas-s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "beas-dynamodbtable" {
  name         = "terraform-locks-w3"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute { 
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.beas-s3bucket.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.beas-dynamodbtable.name
  description = "The name of the DynamoDB table"
}

EOT