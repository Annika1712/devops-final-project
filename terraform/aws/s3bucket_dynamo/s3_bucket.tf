resource "aws_s3_bucket" "terraform-state-storage" {
  bucket = var.s3bucket_name
  force_destroy = true

  tags = {
    Name = var.s3bucket_name
  }
}