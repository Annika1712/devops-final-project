resource "aws_s3_bucket" "terraform-state-storage" {
  bucket = var.s3bucket_name

  tags = {
    Name = var.s3bucket_name
  }
}