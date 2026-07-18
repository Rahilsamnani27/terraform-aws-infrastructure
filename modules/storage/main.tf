variable "project_name" {
  type = string
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_name}-app-storage-${random_id.suffix.hex}"

  tags = {
    Name = "${var.project_name}-app-storage"
  }
}

# Block all public access — this bucket is for app data, never meant to be public
resource "aws_s3_bucket_public_access_block" "app_bucket" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app_bucket" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
