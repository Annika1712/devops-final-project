resource "aws_dynamodb_table" "s3bucket_data_lock" {
  name         = var.dynamo_db_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = var.dynamo_db_name
  }
}
